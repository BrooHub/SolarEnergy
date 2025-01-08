
import 'package:flutter/material.dart';

class CardButton extends StatelessWidget {
  const CardButton({
    super.key,
    required this.image,
    required this.title,
    required this.descaption,
  });
  final String image;
  final String title;
  final String descaption;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side:const  BorderSide(color: Color.fromARGB(255, 150, 206, 253)),
      ),
      elevation: 8,
      child: Container(

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image Container
            Container(
              height: 80,
              width: 150,
              decoration: BoxDecoration(

                image: DecorationImage(
                  image: AssetImage(
                    image,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  // Title
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      
                    ),
                  ),

                  // Description
                  Text(
                    descaption,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // Date
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
