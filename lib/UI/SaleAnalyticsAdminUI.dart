import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'package:productstore/Database/ConnectToDatabase.dart';

import '../Entity/Account.dart';
import '../Entity/CartItem.dart';
import '../Entity/Order.dart';
import '../Entity/Product.dart';

class SaleAnalyticsAdminUI extends StatefulWidget {
  const SaleAnalyticsAdminUI({super.key});

  @override
  SaleAnalyticsAdminUIState createState() => SaleAnalyticsAdminUIState();
}

class SaleAnalyticsAdminUIState extends State<SaleAnalyticsAdminUI> {
  late String _minDateOrder = '';
  late String _maxDateOrder = '';
  late int _totalOrders = 0;
  late int _totalProducts = 0;
  late int _totalAccounts = 0;
  late double _totalProductValue = 0;
  late double _totalOrderValue = 0;

  late List<Product> products;
  late QuerySnapshot productsSnapshot;

  late List<OrderInfo> orders;
  late List<CartItem> cartItems;
  late QuerySnapshot orderQS;
  late QuerySnapshot cartItemQS;

  late List<Account> accounts;
  late QuerySnapshot accountsSnapshot;

  ConnectToDatabase connectToDatabase =  ConnectToDatabase();

  Future<void> _loadData() async {
    setState(() {
      products = [];
      connectToDatabase.Read('PRODUCT').then((results) {
        setState(() {
          productsSnapshot = results;
          for (DocumentSnapshot doc in productsSnapshot.docs)
          {
            products.add(Product(0, doc.get('name'), doc.get('description'), doc.get('category'), doc.get('imageUrl'), doc.get('price')));
          }
        });
      });

      cartItems = [];
      connectToDatabase.Read('ORDERITEM').then((results) {
        setState(() {
          cartItemQS = results;
          for (DocumentSnapshot doc in cartItemQS.docs)
          {
            cartItems.add(CartItem(doc.get('productName'),
              doc.get('price'),
              doc.get('quantity'),
              doc.get('imageUrl'),
              doc.get('account'),
              doc.get('orderNumber'),
            ));
            print('doc.get(\'orderNumber\') ' + doc.get('orderNumber').toString());

          }
        });
      });


      orders = [];
      connectToDatabase.Read('ORDER').then((results) {
        setState(() {
          orderQS = results;
          for (DocumentSnapshot doc in orderQS.docs)
          {
            orders.add(OrderInfo(doc.get('orderNumber'),
                cartItems,
                doc.get('orderDate'),
                doc.get('deliveryDate'),
                StatusConvert(doc.get('orderStatus')),
                doc.get('account')
            ));
          }
        });
      });

      accounts = [];
      connectToDatabase.Read('ACCOUNT').then((results) {
        setState(() {
          accountsSnapshot = results;
          for (DocumentSnapshot doc in accountsSnapshot.docs)
          {
            accounts.add(Account(doc.get('name'), doc.get('birthdate'), doc.get('address'), doc.get('gender'), doc.get('account'), doc.get('password'), doc.get('status')));
          }
        });
      });
    });
  }

  OrderStatus StatusConvert (String orderStatus){
    switch (orderStatus) {
      case 'Pending':
        return OrderStatus.Pending;
      case 'Processing':
        return OrderStatus.Processing;
      case 'InTransit':
        return OrderStatus.InTransit;
      case 'Delivered':
        return OrderStatus.Delivered;
    }
    return  OrderStatus.Pending;
  }


  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {

    _totalOrders = orders.length;
    _totalProducts = products.length;
    _totalAccounts = accounts.length;
    for(Product product in products)
    {
      _totalProductValue += product.price;
    }

    for(CartItem cartItem in cartItems)
    {
      _totalOrderValue += cartItem.price * cartItem.quantity;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Analytics'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Orders: $_totalOrders orders'),
            Text('Total Products: $_totalProducts products'),
            Text('Total Accounts: $_totalAccounts accounts'),
            Text('Total Product Value: \$${MoneyConvert(_totalProductValue)}'),
            Text('Total Order Value: \$${MoneyConvert(_totalOrderValue)}'),
          ],
        ),
      ),
    );
  }

  double MoneyConvert(double value) {
    String formattedNumber = value.toStringAsFixed(2);

    return double.parse(formattedNumber);
  }
}