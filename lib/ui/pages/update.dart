import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../widgets/my_text_field.dart';
import '../../provider/my_provider.dart';

class UpdateScreen extends StatefulWidget {
  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  TextEditingController titleController = TextEditingController();

  TextEditingController descController = TextEditingController();

  TextEditingController priceController = TextEditingController();

  TextEditingController imageController = TextEditingController();

  double price = 0;
  bool priceCheck = true;

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    final prodId = ModalRoute.of(context)!.settings.arguments as String;
    final li = Provider.of<MyProvider>(context, listen: true).myProducts;
    final prodItem = li.firstWhere((element) => element.id == prodId);
    titleController.text = prodItem.title;
    descController.text = prodItem.descruption;
    priceController.text = prodItem.price;
    imageController.text = prodItem.imgUrl;

    return Scaffold(
      appBar: AppBar(
        title: Text('Update Product'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              MyTextField(
                controller: titleController,
                labelText: 'Update title',
                hintText: '${prodItem.title}',
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 15),
              MyTextField(
                controller: descController,
                labelText: 'Update describtion',
                hintText: '${prodItem.descruption}',
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 15),
              MyTextField(
                controller: priceController,
                labelText: 'Update price',
                hintText: '${prodItem.price}',
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 15),
              MyTextField(
                controller: imageController,
                labelText: 'Update image URL',
                hintText: '${prodItem.imgUrl}',
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 30),
              RaisedButton(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 60),
                  child: Text('Update',
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
                        .updateData(
                      prodItem.id,
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
                    Toast.show("Update done", duration: Toast.lengthLong, gravity: Toast.bottom);
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
