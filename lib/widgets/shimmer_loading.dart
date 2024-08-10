import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

//Lista de itens com efeito shimmer, simulando o carregamento
class ShimmerLoadingEffect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      //cria uma lista de itens que pode ser rolada
      itemCount: 5,
      itemBuilder: (context, index) => ShimmerLoadingItem(), //Cria cada item da lista usando ShimmerLoadingItem
    );
  }
}

//Widget chamado para cada item a ser chamado para cada item a ser carregado
class ShimmerLoadingItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}
