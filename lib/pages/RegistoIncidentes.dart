import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proj_comp_movel/pages.dart';

class RegistoIncidentes extends StatelessWidget {
  const RegistoIncidentes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pages[3].title),),
    );
  }
}
