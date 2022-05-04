import 'package:flutter/foundation.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/product_model.dart';
import '../../model/product_model.dart';

class MyProvider with ChangeNotifier {
  bool isLoading = false;
  List myProducts = <Product>[];

  Future<void> addProduct({required String title, required String desc, required String price, required String imgUrl}) async {
    var url = Uri.parse('https://test-39eda-default-rtdb.firebaseio.com/product.json');
    var response = await http
        .post(url,
            body: json.encode({
              'title': title,
              'description': desc,
              'price': price,
              'imageUrl': imgUrl,
            }))
        .then((val) {
      print(json.decode(val.body));
      myProducts.add(Product(
        id: json.decode(val.body)['name'],
        title: title,
        descruption: desc,
        price: price,
        imgUrl: imgUrl,
      ));
    });
    notifyListeners();

    //print(response.statusCode);

    // _ref.set(100);
    catchError(e) {
      throw e;
    }
  }

  Future<void> fetchData() async {
    try {
      isLoading = true;

      var url = Uri.parse('https://test-39eda-default-rtdb.firebaseio.com/product.json');
      http.Response res = await http.get(url);
      final data = json.decode(res.body) as Map<String, dynamic>;
      data.forEach((prodId, prodVal) {
        var isExist = myProducts.firstWhere((item) => item.id == prodId, orElse: () => null);
        if (isExist == null) {
          myProducts.add(Product(id: prodId, title: prodVal['title'], descruption: prodVal['description'], price: prodVal['price'], imgUrl: prodVal['imageUrl']));
        }
      });
      print(myProducts.length);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateData(String id, {required String title, required String desc, required String price, required String imgUrl}) async {
    var url = Uri.parse('https://test-39eda-default-rtdb.firebaseio.com/product/$id.json');
    final prodIndex = myProducts.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      await http.patch(url,
          body: json.encode({
            'title': title,
            'description': desc,
            'price': price,
            'imageUrl': imgUrl,
          }));
      myProducts[prodIndex] = Product(id: id, title: title, descruption: desc, price: price, imgUrl: imgUrl);
      notifyListeners();
    }
  }

  Future<void> deleteData(String id) async {
    var url = Uri.parse('https://test-39eda-default-rtdb.firebaseio.com/product/$id.json');
    final prodIndex = myProducts.indexWhere((element) => element.id == id);
    var prodItem = myProducts[prodIndex];
    if (prodIndex >= 0) {
      myProducts.removeAt(prodIndex);
      var res = await http.delete(url);
      if (res.statusCode >= 400) {
        myProducts.insert(prodIndex, prodItem);
        notifyListeners();
      }
      notifyListeners();
    }
  }

  notifyListeners();
}
