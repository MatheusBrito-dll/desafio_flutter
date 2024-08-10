import 'package:flutter/material.dart';
import '../controllers/assets_controller.dart';
import '../models/hierarchy_node.dart';
import 'asset_node_widget.dart';
import 'package:get/get.dart';

class AssetTreeView extends StatelessWidget {
  final List<HierarchyNode> nodes;
  final AssetsController controller = Get.find();

  AssetTreeView({required this.nodes});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView.builder(
          itemCount: nodes.length,
          itemBuilder: (context, index) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
                maxWidth: constraints.maxWidth,
              ),
              child: AssetNodeWidget(
                node: nodes[index],
                controller: controller,
              ),
            );
          },
        );
      },
    );
  }
}
