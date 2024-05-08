import 'package:flutter/material.dart';

import 'OrderManagementUI.dart';
import 'ProductManagementUI.dart';
import 'SalesAnalyticsUI.dart';
import 'UserManagementUI.dart';

class AdminUI extends StatefulWidget {
  const AdminUI({super.key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminUI> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Admin Management'),
      ),

      body: _getBody(),

      bottomNavigationBar: BottomNavigationBar(

        items: const <BottomNavigationBarItem> [

          BottomNavigationBarItem(
            icon: Icon(Icons.analytics, color: Colors.black),
            label: 'Sales Analytics',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.store, color: Colors.black),
            label: 'Product Management',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.people, color: Colors.black),
            label: 'User Management',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart, color: Colors.black),
            label: 'Order Management',
          ),

        ],

        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.blue,

        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _getBody() {
    switch (_currentIndex) {
      case 0:
        return SalesAnalyticsUI();
      case 1:
        return ProductManagementUI();
      case 2:
        return UserManagementUI();
      case 3:
        return OrderManagementUI();
      default:
        return Container();
    }

  }
}