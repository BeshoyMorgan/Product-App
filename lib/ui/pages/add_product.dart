import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../widgets/my_text_field.dart';
import '../../provider/my_provider.dart';

class AddProduct extends StatefulWidget {
  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController titleController = TextEditingController();

  TextEditingController descController = TextEditingController();

  TextEditingController priceController = TextEditingController();

  TextEditingController imageController = TextEditingController();

  double price = 0;
  bool priceCheck = true;

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              MyTextField(
                controller: titleController,
                labelText: 'add title',
                hintText: 'title',
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 15),
              MyTextField(
                controller: descController,
                labelText: 'describtion',
                hintText: 'add describtion',
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 15),
              MyTextField(
                controller: priceController,
                labelText: 'price',
                hintText: 'price',
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 15),
              MyTextField(
                controller: imageController,
                labelText: 'image URL',
                hintText: 'image',
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 30),
              RaisedButton(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 60),
                  child: Text('Add',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      )),
                ),
                onPressed: () {
                  try {
                    setState(() {
                      price = double.parse(priceController.text);
                      priceCheck = true;
                    });
                  } catch (e) {
                    setState(() {
                      priceCheck = false;
                    });
                  }

                  if (titleController.text.isEmpty || descController.text.isEmpty || priceController.text.isEmpty || imageController.text.isEmpty) {
                    Toast.show("enter all fields", duration: Toast.lengthLong, gravity: Toast.bottom);
                  } else if (!priceCheck) {
                    Toast.show("enter a valid price", duration: Toast.lengthLong, gravity: Toast.bottom);
                  } else {
                    Provider.of<MyProvider>(context, listen: false).isLoading = true;
                    Provider.of<MyProvider>(context, listen: false)
                        .addProduct(
                      title: titleController.text,
                      desc: descController.text,
                      price: priceController.text,
                      imgUrl: imageController.text,
                    )
                        .catchError((_) {
                      return showDialog(
                          context: context,
                          builder: (BuildContext ctx) => AlertDialog(
                                title: Text('Error'),
                                content: Text('Something went wrong'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("ok"),
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(Colors.green),
                                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 10, horizontal: 30)),
                                      ))
                                ],
                              ));
                    }).then((_) {
                      Provider.of<MyProvider>(context, listen: false).isLoading = true;
                      Navigator.pop(context);
                    });
                  }
                },
                color: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
