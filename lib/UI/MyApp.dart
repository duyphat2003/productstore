import 'package:flutter/material.dart';

import 'package:productstore/Entity/Account.dart';
import 'package:productstore/UI/AccountAdminUI.dart';
import 'package:productstore/UI/AddProductUI.dart';
import 'package:productstore/UI/EditOrderAdminUI.dart';
import 'package:productstore/UI/LoginUI.dart';
import 'package:productstore/UI/OrderHistoryUI.dart';

import 'package:productstore/UI/OrderListAdminUI.dart';

import '../Entity/CartItem.dart';
import '../Entity/Product.dart';
import 'AdminUI.dart';
import 'CartUI.dart';
import 'CategoryUI.dart';
import 'EditAccountUI.dart';
import 'EditProductUI.dart';
import 'HomeUI.dart';

import 'Main.dart';
import 'ProductAdminUI.dart';
import 'ProductDetailUI.dart';
import 'ProductUI.dart';
import 'ProfileUI.dart';
import 'SaleAnalyticsAdminUI.dart';
import 'SettingUI.dart'; // Ui library

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MainState createState() => MainState();
}

class MainState extends State<MyApp> {
  int _selectedIndex = 0;

  final List<Widget> _children = [
    const Center(child: HomeUI()),
    const Center(child: CategoryUI()),
    const Center(child: ProfileUI()),
  ];

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('DP Store'),
          centerTitle: true,
        ),

        body: IndexedStack(
          index: _selectedIndex,
          children: _children,
        ),

        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: 'Category',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Account',
            ),

          ],

          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.blue,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),


      ),
      routes: {
        '/admin': (context) => const AdminUI(),
        '/home': (context) => const HomeUI(),
        '/cart': (context) => const CartUI(),
        '/setting': (context) => const SettingsUI(),
        '/productdetail': (context) => const ProductDetailUI(),
        '/product': (context) => const ProductUI(),
        '/addproduct': (context) => const AddProductUI(),
        '/productadmin': (context) => const ProductAdminUI(),
        '/editproductadmin': (context) => const EditProductUI(),
        '/accountadmin': (context) => const AccountAdminUI(),
        '/editaccountadmin': (context) => const EditAccountUI(),
        '/ordermanagementadmin': (context) => const OrderListAdminUI(),
        '/editorderadmin': (context) => const EditOrderAdminUI(),
        '/saleanalyticsadmin': (context) => const SaleAnalyticsAdminUI(),
        '/orderhistory': (context) => const OrderHistoryUI(),
        '/login': (context) => const StartUI(),
      },

      debugShowCheckedModeBanner: false,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class Singleton {
  static Singleton? _instance;
  static Account? _account;
  static List<CartItem>? _cartItems;
  static List<Product>? _products;

  factory Singleton({
    required String name,
    required String birthdate,
    required String address,
    required String gender,
    required String accountNumber,
    required String password,
    required String status,
  }) {
    if (_instance == null) {
      _instance = Singleton._internal();
      _account = Account(
        name,
        birthdate,
        address,
        gender,
        accountNumber,
        password,
        status,
      );

      _cartItems = [];
      _products = [];
    }
    return _instance!;
  }

  Singleton._internal();

  static Singleton get instance => _instance!;
  static Account get account => _account!;
  List<CartItem> get cartItem => List.unmodifiable(_cartItems!);
  List<Product> get products => List.unmodifiable(_products!);

  static set account(Account account) => _account = account;
  //static set cartItem(List<CartItem> cartItem) => _cartItems = cartItem;
  void  AddCartItem(CartItem item) => _cartItems!.add(item);
  void  AddProduct(Product item) => _products!.add(item);

  void clearCartItems() => _cartItems!.clear();
  void clearProducts() => _products!.clear();
  void removeCartItem(CartItem item) => _cartItems!.remove(item);
  void removeProduct(Product item) => _products!.remove(item);

}