import 'package:flutter/material.dart';

class OrderManagementUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Text('View Orders'),
          onTap: () {
            Navigator.pushNamed(context, '/ordermanagementadmin');
          },
        ),
      ],
    );
  }
}