import 'package:flutter/material.dart';
import '../controllers/assets_controller.dart';
import '../models/hierarchy_node.dart';
import 'package:get/get.dart';

// Widget que representa a árvore de ativos
class AssetTreeView extends StatelessWidget {
  final List<HierarchyNode> nodes; // Lista de nós que compõem a árvore
  final AssetsController controller = Get.find(); // Encontra e injeta o controller usando GetX

  AssetTreeView({required this.nodes}); // Construtor que requer a lista de nós

  @override
  Widget build(BuildContext context) {
    //Gambiarra pois nao consgui fazer ela ter largura dinamica D:
    double treeViewWidth = 800.0;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: treeViewWidth,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: nodes.map((node) => AssetNodeWidget(node: node, controller: controller)).toList(),
            //Mapeia cada nó para um widget AssetNodeWidget que vai desenhado na tela
          ),
        ),
      ),
    );
  }
}

// Widget que representa um nó individual na árvore de ativos
class AssetNodeWidget extends StatelessWidget {
  final HierarchyNode node;
  final AssetsController controller;
  final double indent;

  AssetNodeWidget({required this.node, required this.controller, this.indent = 0.0});

  //Função que retorna o ícone adequado para o nó baseado no seu tipo
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

  //Função que retorna o ícone de status do nó
  Widget _getStatusIcon(HierarchyNode node) {
    if (node.status == 'alert') {
      return Icon(Icons.error, color: Colors.red, size: 16);
    } else if (node.status == 'operating') {
      return Icon(Icons.flash_on, color: Colors.green, size: 16);
    } else {
      return Container(); // Nenhum ícone de status
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: indent), // Aplica a indentação para simular a hierarquia
      child: Obx(() {
        //Obx observa mudanças no estado e redesenha o widget quando necessário
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Alinha o conteúdo à esquerda
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
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _getIcon(node),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      node.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 8),
                  if (node.sensorType != null || node.status != null) ...[
                    _getStatusIcon(node),
                  ]
                ],
              ),
            ),
            if (controller.isNodeExpanded(node.id))
              Column(

                children: node.children
                    .map((child) => AssetNodeWidget(
                  node: child,
                  controller: controller,
                  indent: indent + 16.0, //Aumenta a indentação para os filhos :D
                ))
                    .toList(),
              ),
          ],
        );
      }),
    );
  }
}
