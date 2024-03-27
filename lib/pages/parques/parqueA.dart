import 'package:flutter/material.dart';

import '../../pages.dart';

class ParqueA extends StatelessWidget {
  const ParqueA({super.key});

  @override
  Widget build(BuildContext context) {

    var barra = Divider(
      height: 20, // Altura da barra
      thickness: 2, // Espessura da barra
      color: Colors.grey, // Cor da barra
      indent: 20, // Espaço à esquerda da barra
      endIndent: 20, // Espaço à direita da barra
    );

    return Scaffold(
      appBar: AppBar(title: Text(pageParque[0].title),),
      body: Center(
        child: Column(
          children: [
            Image.asset(
              'assets/parqueA.jpg',
              width: 320,
              height: 320,
            ),
            Text('Texto 1'),
            barra,
            Text('Texto 2'),
            barra,
          ],
        ),
      ),
    );

  }
}
