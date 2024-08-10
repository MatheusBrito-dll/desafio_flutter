import 'package:flutter/material.dart';
import '../controllers/assets_controller.dart';
import '../models/hierarchy_node.dart';
import 'package:get/get.dart';

class AssetNodeWidget extends StatelessWidget {
  final HierarchyNode node;
  final AssetsController controller;
  final double indent;

  AssetNodeWidget({required this.node, required this.controller, this.indent = 0.0});

  Widget _getIcon(HierarchyNode node) {
    if (node.isLocation) {
      return Image.asset('assets/images/location.png', width: 24, height: 24);
    } else if (node.sensorType != null) {
      return Image.asset('assets/images/sub_assets.png', width: 24, height: 24);
    } else if (node.children.isNotEmpty) {
      return Image.asset('assets/images/assets.png', width: 24, height: 24);
    } else {
      return Image.asset('assets/images/sub_assets.png', width: 24, height: 24);
    }
  }

  Widget _getStatusIcon(HierarchyNode node) {
    if (node.status == 'alert') {
      return Icon(Icons.error, color: Colors.red, size: 16);
    } else if (node.status == 'operating') {
      return Icon(Icons.flash_on, color: Colors.green, size: 16);
    } else {
      return Container(); // Sem ícone de status
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: indent),
      child: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: node.children.isNotEmpty
                  ? IconButton(
                icon: controller.isNodeExpanded(node.id)
                    ? Icon(Icons.expand_less)
                    : Icon(Icons.expand_more),
                onPressed: () {
                  controller.toggleNode(node.id);
                },
              )
                  : SizedBox(width: 24),
              title: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _getIcon(node),
                    SizedBox(width: 8),
                    Text(
                      node.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (node.sensorType != null || node.status != null) ...[
                      _getStatusIcon(node),
                    ]
                  ],
                ),
              ),
            ),
            if (controller.isNodeExpanded(node.id))
              Column(
                children: node.children
                    .map((child) =>
                    AssetNodeWidget(node: child, controller: controller, indent: indent + 16.0))
                    .toList(),
              ),
          ],
        );
      }),
    );
  }
}
