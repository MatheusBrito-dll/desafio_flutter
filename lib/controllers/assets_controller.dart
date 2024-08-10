import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/asset.dart';
import '../models/hierarchy_node.dart';
import '../models/location.dart';
import '../services/data_loader.dart';

class AssetsController extends GetxController {
  var futureHierarchy = Future.value(<HierarchyNode>[]).obs;
  var allNodes = <HierarchyNode>[].obs;
  var filteredNodes = <HierarchyNode>[].obs;
  var filterEnergy = false.obs;
  var filterCritical = false.obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void loadHierarchy(String unit) {
    futureHierarchy.value = _loadHierarchy(unit);
  }

  Future<List<HierarchyNode>> _loadHierarchy(String unit) async {
    List<Location> locations = await loadLocations(unit);
    List<Asset> assets = await loadAssets(unit);
    return compute(buildHierarchy, {'locations': locations, 'assets': assets});
  }

  static List<HierarchyNode> buildHierarchy(Map<String, List<dynamic>> data) {
    List<Location> locations = data['locations'] as List<Location>;
    List<Asset> assets = data['assets'] as List<Asset>;

    Map<String, HierarchyNode> locationMap = {};
    Map<String, HierarchyNode> assetMap = {};

    //Criar nós de localização
    for (var location in locations) {
      locationMap[location.id] = HierarchyNode(
        id: location.id,
        name: location.name,
        children: [],
        isLocation: true,
      );
    }

    //Criar nós de ativos
    for (var asset in assets) {
      assetMap[asset.id] = HierarchyNode(
        id: asset.id,
        name: asset.name,
        sensorType: asset.sensorType,
        status: asset.status,
        children: [],
        isLocation: false,
      );
    }

    //Adicionar ativos aos seus respectivos locais ou pais
    for (var asset in assets) {
      if (asset.locationId != null && locationMap.containsKey(asset.locationId)) {
        locationMap[asset.locationId]!.children.add(assetMap[asset.id]!);
      } else if (asset.parentId != null && assetMap.containsKey(asset.parentId)) {
        assetMap[asset.parentId]!.children.add(assetMap[asset.id]!);
      }
    }

    //Construir a hierarquia de locais
    List<HierarchyNode> rootNodes = [];
    for (var location in locations) {
      if (location.parentId == null) {
        rootNodes.add(locationMap[location.id]!);
      } else if (locationMap.containsKey(location.parentId)) {
        locationMap[location.parentId]!.children.add(locationMap[location.id]!);
      }
    }

    //Adicionar ativos sem localização ou pai diretamente à raiz
    for (var asset in assets) {
      if (asset.locationId == null && asset.parentId == null) {
        rootNodes.add(assetMap[asset.id]!);
      }
    }

    return rootNodes;
  }

  void toggleNode(String nodeId) {
    final node = _findNodeById(allNodes, nodeId);
    if (node != null) {
      node.isExpanded = !node.isExpanded;
      allNodes.refresh();
    }
  }

  HierarchyNode? _findNodeById(List<HierarchyNode> nodes, String nodeId) {
    for (var node in nodes) {
      if (node.id == nodeId) return node;
      var found = _findNodeById(node.children, nodeId);
      if (found != null) return found;
    }
    return null;
  }

  bool isNodeExpanded(String nodeId) {
    final node = _findNodeById(allNodes, nodeId);
    return node?.isExpanded ?? false;
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
    _updateFilteredNodes();
  }

  void toggleFilterEnergy() {
    filterEnergy.value = !filterEnergy.value;
    _updateFilteredNodes();
  }

  void toggleFilterCritical() {
    filterCritical.value = !filterCritical.value;
    _updateFilteredNodes();
  }

  void _updateFilteredNodes() {
    filteredNodes.value = filterNodes(allNodes);
  }

  List<HierarchyNode> filterNodes(List<HierarchyNode> nodes) {
    if (searchQuery.isEmpty && !filterEnergy.value && !filterCritical.value) return nodes;

    List<HierarchyNode> filteredNodes = [];

    for (var node in nodes) {
      var filteredChildren = filterNodes(node.children);

      if (searchQuery.isNotEmpty && node.name.toLowerCase().contains(searchQuery.value.toLowerCase())) {
        filteredNodes.add(node);
      } else if ((filterEnergy.value && node.sensorType == 'energy') ||
          (filterCritical.value && node.status == 'alert') ||
          filteredChildren.isNotEmpty) {
        filteredNodes.add(HierarchyNode(
          id: node.id,
          name: node.name,
          sensorType: node.sensorType,
          status: node.status,
          children: filteredChildren,
          isLocation: node.isLocation,
        ));
      } else if (node.isLocation &&
          (node.children.any((child) => child.sensorType == 'energy' && filterEnergy.value) ||
              node.children.any((child) => child.status == 'alert' && filterCritical.value))) {
        filteredNodes.add(node);
      }
    }
    return filteredNodes;
  }
}
