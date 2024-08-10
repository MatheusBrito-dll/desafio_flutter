import 'package:flutter/material.dart';
import 'routes/routes.dart'; //Rotas da aplicação

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //Remove a faixa de debug
      title: 'Asset Management',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // Rota mãe
      routes: routes,
    );
  }
}
