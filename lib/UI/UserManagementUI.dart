import 'package:flutter/material.dart';

class UserManagementUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children:[
        ListTile(
          title: Text('View Users'),
          onTap: () {
            Navigator.pushNamed(context, '/accountadmin');
          },
        ),

      ],
    );
  }
}