import 'package:flutter/material.dart';
import '../screens/home_page.dart';
import '../screens/assets_screen.dart';

// ignore: slash_for_doc_comments
/**
  O objeto routes é um Map e que cada chave é uma -string- e representa o link
  da rota, e cada valor é um -WidgetBuilder- que cria e retorna o widget que
  está vinculado a rota chamada.
*/
Map<String, WidgetBuilder> routes = {
  '/': (context) => HomePage(),
  '/assets': (context) => AssetsScreen(),
};
