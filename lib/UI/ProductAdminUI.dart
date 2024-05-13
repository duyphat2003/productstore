import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Database/ConnectToDatabase.dart';
import '../Entity/Product.dart';

class ProductAdminUI extends StatefulWidget {
  const ProductAdminUI({super.key});

  @override
  ProductAdminUIState createState() => ProductAdminUIState();
}

class ProductAdminUIState extends State<ProductAdminUI> {
  late List<Product> popularProducts;

  ConnectToDatabase connectToDatabase = new ConnectToDatabase();
  late QuerySnapshot products;


  @override
  void initState()
  {
    popularProducts = [];
    connectToDatabase.Read('PRODUCT').then((results) {
      setState(() {
        products = results;
        for (DocumentSnapshot doc in products.docs)
        {
          popularProducts.add(Product(0, doc.get('name'), doc.get('description'), doc.get('category'), doc.get('imageUrl'), doc.get('price')));
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.orange,
            title: Text('Product List')
        ),
        body: ListView.builder(
          itemCount: popularProducts.length, // Replace 3 with the number of products in your list
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('${popularProducts[index].title}'),
              subtitle: Text('\$${popularProducts[index].price}'), // Replace with the actual price of the product
              leading: Image.network('${popularProducts[index].imageUrl}'), // Replace with the actual image url of the product
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.pushNamed(context, '/editproductadmin', arguments: Product(0, popularProducts[index].title, popularProducts[index].description, popularProducts[index].category, popularProducts[index].imageUrl, popularProducts[index].price));
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _showDeleteDialog(context, index);
                    },
                  ),
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/addproduct');
            },
          child: Icon(Icons.add),
        ),
    );
  }

  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Product'),
          content: Text('Do you want to delete this product?'),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Delete'),
              onPressed: () {
                setState(() {
                  connectToDatabase.Delete('PRODUCT', 'name', popularProducts[index].title);
                  popularProducts.removeAt(index);
                  Navigator.of(context).pop();
                });

              },
            ),
          ],
        );
      },
    );
  }
}