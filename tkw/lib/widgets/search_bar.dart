import 'package:flutter/material.dart';
import '../providers/app_state.dart';

// ignore: must_be_immutable, use_key_in_widget_constructors
class MySearchBar extends StatelessWidget {
  final Function(String) onSearchResultSelected;

  const MySearchBar({super.key, 
    required this.onSearchResultSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25,50,25,0),
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
          
          // Filter the list based on both `ilce` and `il` names
          final filteredList = AppState.ilceList.where((ilce) {
            final ilceName = ilce['ilce'].toLowerCase();
            final postaCode = int.parse(ilce['posta_code']);
            final ilName = AppState.ilList[postaCode - 1]['il'].toLowerCase();
            return ilceName.contains(query) || ilName.contains(query);
          }).toList();

          return List<ListTile>.generate(filteredList.length, (int index) {
            final item = filteredList[index];
            final postaCode = int.parse(item['posta_code']);
            final city = AppState.ilList[postaCode - 1]['il'];
            return ListTile(
              dense: true,
              trailing: const Icon(Icons.ads_click_outlined),
              title: Text("İlçe: ${item['ilce']} "),
              subtitle: Text("Türkiye, İl: $city"),
              leading: const Icon(Icons.location_on),
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