// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import '../providers/app_state.dart';

// ignore: must_be_immutable, use_key_in_widget_constructors
class MySearchBar extends StatelessWidget {
  final Function(String) onSearchResultSelected;

  const MySearchBar({
    required this.onSearchResultSelected,
  });

  @override
  Widget build(BuildContext context) {
    

    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: SearchAnchor(
        viewBackgroundColor: Colors.white,
        viewOnChanged: (value) {},
        isFullScreen: false,
        dividerColor: Colors.black,
        viewHintText: "Ara",
        builder: (BuildContext context, SearchController controller) {
          return SearchBar(
            controller: controller,
            padding: const WidgetStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 20.0)),
            onTap: () {
              controller.openView();
            },
            onChanged: (_) {
              controller.openView();
            },
            leading: const Icon(Icons.search),
          );
        },
        suggestionsBuilder:
            (BuildContext context, SearchController controller) {
          final query = controller.value.text.toLowerCase();
          final filteredList = AppState.ilceList
              .where((ilce) => ilce['ilce'].toLowerCase().contains(query))
              .toList();

          return List<ListTile>.generate(filteredList.length, (int index) {
            final item = filteredList[index];
            return ListTile(
              dense: true,
              trailing: Icon(Icons.ads_click_outlined),
              title: Text("ilçe: ${item['ilce']} "),
              subtitle: Text("Turkiye, il: " +
                  AppState.ilList[int.parse(item['posta_code']) - 1]['il']),
              leading: const Icon(Icons.home),
              onTap: () {
                onSearchResultSelected(item['ilce']);
                controller.closeView("");
              },
            );
          });
        },
      ),
    );
  }
}
