import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/units_controller.dart';
import '../models/unit.dart';

class UnitDetailPage extends StatelessWidget {
  final UnitsController unitsController = Get.find();

  @override
  Widget build(BuildContext context) {
    final String unitName = Get.arguments;
    final Unit unit = unitsController.getUnit(unitName);

    return Scaffold(
      appBar: AppBar(
        title: Text(unit.name),
      ),
      body: Center(
        child: Text('Details for ${unit.name} will be shown here'),
      ),
    );
  }
}
