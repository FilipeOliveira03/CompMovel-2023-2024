import 'package:flutter/material.dart';

import '../../pages.dart';

class ParqueB extends StatelessWidget {
  const ParqueB({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pageParque[1].title),),
    );
  }
}