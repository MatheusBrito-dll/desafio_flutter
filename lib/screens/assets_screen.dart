import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/assets_controller.dart';
import '../models/hierarchy_node.dart';
import '../widgets/asset_tree_view.dart';
import '../widgets/shimmer_loading.dart';


class AssetsScreen extends StatelessWidget {
  final AssetsController controller = Get.put(AssetsController());

  @override
  void didChangeDependencies(BuildContext context) {
    final String? unit = ModalRoute.of(context)!.settings.arguments as String?;
    if (unit != null) {
      controller.loadHierarchy(unit);
    }
  }

  @override
  Widget build(BuildContext context) {
    didChangeDependencies(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF17192D),
        elevation: 0,
        centerTitle: true,
        title: Text('Assets', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: TextEditingController(),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Buscar Ativo ou Local',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: controller.onSearchChanged,
            ),
            SizedBox(height: 8),
            Obx(() => Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    side: controller.filterEnergy.value
                        ? BorderSide(color: Color(0xFF17192D), width: 1.0)
                        : BorderSide.none,
                  ),
                  onPressed: controller.toggleFilterEnergy,
                  child: Row(
                    children: [
                      Icon(Icons.bolt, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Sensor de Energia', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    side: controller.filterCritical.value
                        ? BorderSide(color: Color(0xFF17192D), width: 1.0)
                        : BorderSide.none,
                  ),
                  onPressed: controller.toggleFilterCritical,
                  child: Row(
                    children: [
                      Icon(Icons.warning, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Crítico', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            )),
            SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<HierarchyNode>>(
                future: controller.futureHierarchy.value,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ShimmerLoadingEffect(); // Exibir efeito de carregamento enquanto os dados estão sendo carregados
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No data available'));
                  } else {
                    controller.allNodes.value = snapshot.data!;
                    return Obx(() => AssetTreeView(nodes: controller.filterNodes(controller.allNodes)));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
