import 'package:flutter/material.dart';
import 'package:proj_comp_movel/pages.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pages[0].title),),
    );
  }
}
