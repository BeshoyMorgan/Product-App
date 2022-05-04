import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../provider/my_provider.dart';
import '../../provider/auth.dart';

import '../widgets/product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Provider.of<MyProvider>(context, listen: false).fetchData().then((_) {
      Provider.of<MyProvider>(context, listen: false).isLoading = false;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final li = Provider.of<MyProvider>(context, listen: true).myProducts;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home',
            style: TextStyle(
              fontSize: 30,
              color: Colors.white,
            )),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              Provider.of<Auth>(context, listen: false).logOut();
              Navigator.of(context).pushReplacementNamed('log_in');
              print('${Provider.of<Auth>(context, listen: false).alreadyAuth}');
              // Provider.of<Auth>(context, listen: true).alreadyAuth;
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text('Log out'),
              ),
            ),
          ),
        ],
      ),
      body: li.length > 0
          ? (Provider.of<MyProvider>(context, listen: false).isLoading
              ? Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: () async => await Provider.of<MyProvider>(context, listen: false).fetchData(),
                  child: ListView(children: [
                    ...li.map((val) {
                      return InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              'details',
                              arguments: val.id,
                            );
                          },
                          child: MyCard(id: val.id, title: val.title, desc: val.descruption, price: val.price, imgUrl: val.imgUrl));
                    }).toList(),
                  ]),
                ))
          : Center(child: Text('There is no data yet')),
      floatingActionButton: FlatButton.icon(
        color: Colors.teal,
        label: Text("Add Product", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 19)),
        icon: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.of(context).pushNamed("add_product_screen");
        },
      ),
    );
  }
}
