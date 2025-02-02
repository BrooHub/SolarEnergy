import 'package:flutter/material.dart';

import 'card_button.dart';

void showPaymentModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
    ),
    // isScrollControlled: true,
    builder: (BuildContext context) {
      return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
          color: Colors.white,
        ),
        padding: EdgeInsets.only(
          left: 10,
          right: 10,
          top: 10,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 250,
                  height: 60,
                  child: SizedBox(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Zaman Dağılımı ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                          Icon(
                            Icons.hourglass_bottom,
                            color: Colors.black,
                          )
                        ]),
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/web_view');
                    },
                    icon: Image.asset('assets/images/warning.png',
                        width: 70, height: 70)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/search');
                  },
                  child: const CardButton(
                    image: 'assets/images/atom.png',
                    title: 'Yıllık Enerji',
                    descaption: 'kWh/m²-yıl',
                  ),
                ),
                // GestureDetector(
                //   onTap: () {
                //     Navigator.pushNamed(context, '/district_info_page');
                //   },
                //   child: const CardButton(
                //     image: 'assets/images/fabrika.png',
                //     title: 'Aylık Enerji',
                //     descaption: 'kWh/m²-Ay',
                //   ),
                // )
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/web_view');
                  },
                  child: const CardButton(
                    image: 'assets/images/radar.png',
                    title: 'Kayanak Sayfası',
                    descaption: 'Ziyaret edin',
                  ),
                ),
              ],
            ),
            
            const SizedBox(
              height: 20,
            )
          ],
        ),
      );
    },
  );
}
