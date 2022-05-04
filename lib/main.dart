import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'ui/pages/add_product.dart';
import './provider/my_provider.dart';
import './provider/auth.dart';
import 'ui/pages/home.dart';
import 'ui/pages/details.dart';
import 'ui/pages/update.dart';
import 'ui/pages/sign_up.dart';
import 'ui/pages/login.dart';
import 'ui/pages/spash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
//  var _ref = FirebaseDatabase.instance.ref().child('product');
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(
          create: (_) => Auth(),
        ),
        ChangeNotifierProvider<MyProvider>(
          //create: (ctx) => MyProvider(Provider.of<Auth>(ctx, listen: false).token, Provider.of<MyProvider>(ctx, listen: true).myProducts),
          create: (_) => MyProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter UI Controls',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Provider.of<Auth>(context, listen: false).alreadyAuth
          ? HomePage()
          : FutureBuilder(
              future: Provider.of<Auth>(context, listen: false).autoLogin(),
              builder: (ctx, snapShot) => snapShot.connectionState == ConnectionState.waiting ? SpashScreen() : LogIn(),
            ),
      routes: {
        'add_product_screen': (context) => Provider.of<Auth>(context, listen: false).alreadyAuth ? AddProduct() : LogIn(),
        'details': (context) => DetailsScreen(),
        'update': (context) => UpdateScreen(),
        'sign_up': (context) => SignUp(),
        'log_in': (context) => LogIn(),
        'home': (context) => HomePage(),
      },
    );
  }
}
