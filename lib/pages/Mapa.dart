import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proj_comp_movel/pages.dart';

class Mapa extends StatelessWidget {
  const Mapa({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pages[2].title),),
    );
  }
}
