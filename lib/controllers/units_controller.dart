import 'package:get/get.dart';
import '../models/unit.dart';

class UnitsController extends GetxController {
  final List<Unit> units = [
    Unit(name: 'Jaguar Unit', assetPath: 'assets/data/Jaguar_Unit/assets.json'),
    Unit(name: 'Tobias Unit', assetPath: 'assets/data/Tobias_Unit/assets.json'),
    Unit(name: 'Apex Unit', assetPath: 'assets/data/Apex_Unit/assets.json'),
  ];

  Unit getUnit(String name) {
    return units.firstWhere((unit) => unit.name == name);
  }
}
