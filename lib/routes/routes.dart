import 'package:flutter/material.dart';
import '../screens/home_page.dart';
import '../screens/assets_screen.dart';

Map<String, WidgetBuilder> routes = {
  '/': (context) => HomePage(),
  '/assets': (context) => AssetsScreen(),
};
