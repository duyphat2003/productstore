import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Database/ConnectToDatabase.dart';
import '../Entity/Product.dart';

class EditProductUI extends StatefulWidget {
  const EditProductUI({super.key});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<EditProductUI> {
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageLinkController = TextEditingController();

  ConnectToDatabase connectToDatabase = new ConnectToDatabase();

  late int _productType = 0;
  late double _productPrice = 0;
  late String _productDescription = '';
  late String _productImageLink = '';

  static const List<String> categories = [
    'Electronics',
    'Fashion',
    'Home & Garden',
    'Sports & Outdoors',
    'Health & Beauty',
  ];

  @override
  Widget build(BuildContext context) {
    final Product product = ModalRoute.of(context)!.settings.arguments as Product;

    _nameController.text = product.name;
    _typeController.text = categories[product.category];
    _priceController.text = product.price.toString();
    _descriptionController.text = product.description;
    _imageLinkController.text = product.imageUrl;

    print('_productType ' + product.category.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(hintText: 'Enter product name'),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  const Text('Gender', style: TextStyle(color: Colors.black)),
                  const SizedBox(width: 10),
                  DropdownMenu<String>(
                    initialSelection:  _typeController.text,
                    onSelected: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        product.category = categories.indexWhere((element) => element == value);

                        print('_productType ' + product.category.toString());

                      });
                    },
                    dropdownMenuEntries: categories.map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(value: value, label: value);
                    }).toList(),
                  ),
                ],
              ),
            ),


            TextField(
              controller: _priceController,
              decoration: InputDecoration(hintText: 'Enter product price'),
              onChanged: (value) {
                product.price  = double.tryParse(value)!;
              },
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(hintText: 'Enter product description'),
              onChanged: (value) {
                product.description = value;
              },
            ),
            TextField(
              controller: _imageLinkController,
              decoration: InputDecoration(hintText: 'Enter product image link'),
              onChanged: (value) {
                product.imageUrl = value;
              },
            ),
            ElevatedButton(
              child: Text('Save'),
              onPressed: () {
                print(product.category);

                Map<String, dynamic> map = {
                  'category': product.category,
                  'price': product.price,
                  'description': product.description,
                  'imageUrl': product.imageUrl,
                };


                connectToDatabase.Update(map, 'PRODUCT', 'name', product.name);
                Navigator.pop(context);

              },
            ),
          ],
        ),
      ),
    );
  }
}