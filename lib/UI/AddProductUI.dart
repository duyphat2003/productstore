import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:productstore/ui/CategoryUI.dart';

import '../Database/connecttodatabase.dart';
import '../Entity/product.dart';

class AddProductUI extends StatefulWidget {
  const AddProductUI({super.key});

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductUI> {
  final _formKey = GlobalKey<FormState>();
  late String _productName = '';
  late String _productDescription = '';
  late int _producCategory = 0;
  late double _productPrice = 0;
  late String _productImageUrl = '';

  late List<Product> popularProducts;
  ConnectToDatabase connectToDatabase = ConnectToDatabase();
  late QuerySnapshot products;

  @override
  void initState() {
    popularProducts = [];
    connectToDatabase.Read('PRODUCT').then((results) {
      setState(() {
        products = results;
        for (DocumentSnapshot doc in products.docs) {
          popularProducts.add(Product(
              0,
              doc.get('name'),
              doc.get('description'),
              doc.get('category'),
              doc.get('imageUrl'),
              doc.get('price')));
        }
      });
    });

    getListCategory();
    super.initState();
  }

  
  List<String>? categories;
  var isLoaded = false;

  getListCategory() async {
    categories = await connectToDatabase.fetchCategories();
    if (categories != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.orange, title: const Text('Add Product')),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Product Name'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a product name';
                }
                if (popularProducts
                    .where((product) =>
                        product.title.toLowerCase() ==
                        value.toString().toLowerCase())
                    .isNotEmpty) {
                  return 'This product name is already existed';
                }
                return null;
              },
              onChanged: (value) {
                _productName = value;
              },
            ),
            TextFormField(
              decoration:
                  const InputDecoration(labelText: 'Product Description'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a product description';
                }
                return null;
              },
              onChanged: (value) {
                _productDescription = value;
              },
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  const Text('Category', style: TextStyle(color: Colors.black)),
                  const SizedBox(width: 10),
                  DropdownMenu<String>(
                    initialSelection: categories?.first,
                    onSelected: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        _producCategory =  categories!.indexOf(value!);
                      });
                    },
                    dropdownMenuEntries: categories!.map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                          value: value, label: value);
                    }).toList(),
                  ),
                ],
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Product Price'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a product price';
                }
                return null;
              },
              onChanged: (value) {
                _productPrice = double.parse(value);
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Product Image Url'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a product image url';
                }
                return null;
              },
              onChanged: (value) {
                _productImageUrl = value;
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Save the product to shared preferences or a database
                  Map<String, dynamic> map = {
                    'name': _productName,
                    'category': _producCategory + 1,
                    'price': _productPrice,
                    'description': _productDescription,
                    'imageUrl': _productImageUrl,
                  };

                  connectToDatabase.Insert(map, 'PRODUCT');
                  Navigator.pop(context);
                }
              },
              child: const Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}
