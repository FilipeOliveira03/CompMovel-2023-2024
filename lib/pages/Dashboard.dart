import 'package:flutter/material.dart';
import 'package:proj_comp_movel/pages.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pages[0].title),),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /*
          SearchAnchor(builder: (BuildContext context, SearchController controller) {
            return SearchBar(
              controller: controller,
              padding: const MaterialStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 16.0)),
              onTap: () {
                controller.openView();
              },
              onChanged: (_) {
                controller.openView();
              },
            );
          }, suggestionsBuilder:
              (BuildContext context, SearchController controller) {
                return minhaListaParques.take(5).map((park) => park.name).toList()
          }
          ),
          */


          Text('map'),
          Text('3 parques proximos'),
        ],
      ),
    );
  }
}
