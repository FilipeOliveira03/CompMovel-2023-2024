import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proj_comp_movel/pages.dart';

class ListaParques extends StatelessWidget {
  const ListaParques({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pages[1].title),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => pageParque[0].widget),
              );
            },
                child: Column(
                  children: [
                    Text(pageParque[0].title)
                  ],
                ),),
            TextButton(onPressed: () {},
              child: Column(
                children: [
                  Text(pageParque[1].title)
                ],
              ),),
          ],
        ),
      ),
    );
  }
}
