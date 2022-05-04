import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  final String id;
  final String title;
  final String desc;
  final String price;
  final String imgUrl;

  MyCard({required this.id, required this.title, required this.desc, required this.price, required this.imgUrl});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          Container(
            width: 400,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.network(imgUrl, fit: BoxFit.cover),
          ),
          Container(
            width: 400,
            height: 100,
            color: Colors.black.withOpacity(0.3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    child: Text('$title', style: TextStyle(color: Colors.white, fontSize: 25))),
                const SizedBox(height: 20),
                Container(
                    height: 30,
                    padding: EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), bottomLeft: Radius.circular(20.0)),
                    ),
                    child: Text('price= $price', style: TextStyle(color: Colors.white, fontSize: 20))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
