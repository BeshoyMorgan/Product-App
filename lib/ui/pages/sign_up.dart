import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../../provider/auth.dart';

import '../widgets/text_field_auth.dart';

class SignUp extends StatefulWidget {
  SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController email = TextEditingController();

  TextEditingController pass = TextEditingController();

  TextEditingController rePass = TextEditingController();
  bool visible1 = true;

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50),
              Row(
                children: [
                  Text(
                    'Sign ',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  Text(
                    'Up',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              TextFieldAuth(
                obscureText: false,
                prefixIcon: Icon(Icons.email),
                controller: email,
                labelText: 'Email',
                hintText: 'enter Email',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              TextFieldAuth(
                obscureText: Provider.of<Auth>(context, listen: true).isVisible,
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                    onPressed: () {
                      Provider.of<Auth>(context, listen: false).changeVisibility();
                    },
                    icon: Icon(Provider.of<Auth>(context, listen: true).isVisible ? Icons.visibility_off : Icons.visibility)),
                controller: pass,
                labelText: 'Password',
                hintText: 'enter Password',
                keyboardType: TextInputType.visiblePassword,
              ),
              const SizedBox(height: 20),
              TextFieldAuth(
                obscureText: Provider.of<Auth>(context, listen: true).isVisible2,
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                    onPressed: () {
                      Provider.of<Auth>(context, listen: false).changeVisibility2();

                      //Provider.of<Auth>(context, listen: true).changeVisibility();
                    },
                    icon: Icon(Provider.of<Auth>(context, listen: true).isVisible2 ? Icons.visibility_off : Icons.visibility)),
                controller: rePass,
                labelText: 're-Password',
                hintText: 're-enter Password',
                keyboardType: TextInputType.visiblePassword,
              ),
              const SizedBox(height: 30),
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Colors.teal,
                padding: EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 40,
                ),
                child: Text('Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                    )),
                onPressed: () async {
                  try {
                    if (email.text.isEmpty || pass.text.isEmpty || rePass.text.isEmpty) {
                      Toast.show("enter all fields", duration: Toast.lengthLong, gravity: Toast.bottom);
                    } else if (pass.text != rePass.text) {
                      Toast.show("password dose not match", duration: Toast.lengthLong, gravity: Toast.bottom);
                    } else {
                      await Provider.of<Auth>(context, listen: false).signUp(email.text, pass.text);
                      Navigator.of(context).pushNamed('home');
                    }
                  } catch (e) {
                    Toast.show('$e', duration: Toast.lengthLong, gravity: Toast.bottom);
                  }
                },
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already Have An Account? '),
                  TextButton(
                    child: Text('Click here', style: TextStyle(color: Colors.blue)),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('log_in');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
