import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:productstore/Database/ConnectToDatabase.dart';
import 'package:productstore/UI/MyApp.dart';
import 'package:productstore/UI/ProductDetailUI.dart';

import '../Entity/CartItem.dart';

class CartUI extends StatefulWidget {
  const CartUI({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartUI> {
  ConnectToDatabase connectToDatabase = ConnectToDatabase();
  late QuerySnapshot orderQS;
  late bool isGet = false;

  @override
  Widget build(BuildContext context) {
    if (!isGet) {
      final CartItemOrder? item =
          ModalRoute.of(context)!.settings.arguments as CartItemOrder?;

      if (item != null) {
        Singleton.instance.AddCartItem(CartItem(
            item.product.title,
            item.product.price,
            item.amount,
            item.product.imageUrl,
            Singleton.account.account,
            ''));

        Singleton.instance.AddProduct(item.product);
        isGet = true;
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Cart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: Singleton.instance.cartItem.length,
        itemBuilder: (context, index) {
          final cartItem = Singleton.instance.cartItem[index];
          return ListTile(
            onTap: () {
              Navigator.pushNamed(context, '/productdetail',
                  arguments: Singleton.instance.products[index]);
            },
            leading: Image.network(cartItem.imageUrl),
            title: Text(cartItem.productName),
            subtitle:
                Text('${cartItem.price} | Amount: ${cartItem.quantity} x'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (cartItem.quantity > 1) {
                        cartItem.quantity--;
                      }
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      if (cartItem.quantity < 5) {
                        cartItem.quantity++;
                      }
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      Singleton.instance.removeCartItem(cartItem);
                      Singleton.instance
                          .removeProduct(Singleton.instance.products[index]);
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        height: 60.0,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total: \$${_calculateTotal()}'),
            ElevatedButton(
              onPressed: () {
                // Handle buy button press
                setState(() {
                  int index = 0;
                  connectToDatabase.Read('ORDER').then((results) {
                    setState(() {
                      orderQS = results;
                      for (DocumentSnapshot doc in orderQS.docs) {
                        int i = int.parse(doc.get('orderNumber'));
                        if (index <= i) {
                          index = i + 1;
                        }
                      }

                      Map<String, dynamic> map = {
                        'orderNumber': index.toString(),
                        'orderDate':
                            DateFormat('dd/MM/yyyy').format(DateTime.now()),
                        'deliveryDate': '',
                        'orderStatus': 'Pending',
                        'account': Singleton.account.account,
                      };

                      connectToDatabase.Insert(map, 'ORDER');

                      for (CartItem item in Singleton.instance.cartItem) {
                        Map<String, dynamic> data = {
                          'productName': item.productName,
                          'price': item.price,
                          'quantity': item.quantity,
                          'imageUrl': item.imageUrl,
                          'account': item.account,
                          'orderNumber': index.toString(),
                        };
                        connectToDatabase.Insert(data, 'ORDERITEM');
                      }
                      Singleton.instance.clearCartItems();
                      Singleton.instance.clearProducts();
                      Navigator.pushNamed(context, '/home');
                    });
                  });
                });
              },
              child: const Text('Buy'),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateTotal() {
    double total = 0.0;
    for (CartItem cartItem in Singleton.instance.cartItem) {
      total += cartItem.price * cartItem.quantity;
    }
    String formattedNumber = total.toStringAsFixed(2);

    return double.parse(formattedNumber);
  }
}
