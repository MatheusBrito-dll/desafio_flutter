import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/location.dart';
import '../models/asset.dart';

Future<List<Location>> loadLocations(String unit) async {
  final String response = await rootBundle.loadString('assets/data/$unit/locations.json');
  final data = await json.decode(response);
  return (data as List).map((locationJson) => Location.fromJson(locationJson)).toList();
}

Future<List<Asset>> loadAssets(String unit) async {
  final String response = await rootBundle.loadString('assets/data/$unit/assets.json');
  final data = await json.decode(response);
  return (data as List).map((assetJson) => Asset.fromJson(assetJson)).toList();
}
