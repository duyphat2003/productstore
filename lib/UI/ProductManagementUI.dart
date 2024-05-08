import 'package:flutter/material.dart';

class ProductManagementUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Text('View Products'),
          onTap: () {
            Navigator.pushNamed(context, '/productadmin');
            },
        ),
        ListTile(
          title: Text('Add Product'),
          onTap: () {
            Navigator.pushNamed(context, '/addproduct');
          },
        ),
      ],
    );
  }
}