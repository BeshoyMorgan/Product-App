import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../provider/my_provider.dart';

import '../widgets/product_card.dart';

class DetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prodId = ModalRoute.of(context)!.settings.arguments as String;
    final li = Provider.of<MyProvider>(context, listen: true).myProducts;
    final prodItem = li.firstWhere((element) => element.id == prodId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed('update', arguments: prodId);
            },
            child: Center(child: Text('Update Product')),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            MyCard(id: prodItem.id, title: prodItem.title, desc: prodItem.descruption, price: prodItem.price, imgUrl: prodItem.imgUrl),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(20),
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.blue,
                  ),
                ),
                child: Text(prodItem.descruption,
                    style: TextStyle(
                      fontSize: 25,
                    )),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.delete),
        onPressed: () {
          Provider.of<MyProvider>(context, listen: false).deleteData(prodItem.id);
          Navigator.pop(context);
        },
      ),
    );
  }
}
