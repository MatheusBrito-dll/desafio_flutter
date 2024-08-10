class HierarchyNode {
  final String id;
  final String name;
  final String? sensorType;
  final String? status;
  final bool isLocation;
  final List<HierarchyNode> children;
  bool isExpanded;

  HierarchyNode({
    required this.id,
    required this.name,
    this.sensorType,
    this.status,
    this.isLocation = false,
    this.children = const [],
    this.isExpanded = false,
  });
}
