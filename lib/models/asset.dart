class Asset {
  final String name;
  final String id;
  final String? locationId;
  final String? parentId;
  final String? sensorType;
  final String? status;

  Asset({
    required this.name,
    required this.id,
    this.locationId,
    this.parentId,
    this.sensorType,
    this.status,
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      name: json['name'],
      id: json['id'],
      locationId: json['locationId'],
      parentId: json['parentId'],
      sensorType: json['sensorType'],
      status: json['status'],
    );
  }
}
