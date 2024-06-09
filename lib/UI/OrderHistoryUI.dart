import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Database/connecttodatabase.dart';
import '../Entity/CartItem.dart';
import '../Entity/order.dart';
import '../Entity/Product.dart';


class OrderHistoryUI extends StatefulWidget {
  const OrderHistoryUI({super.key});

  @override
  OrderHistoryUIState createState() => OrderHistoryUIState();
}

class OrderHistoryUIState extends State<OrderHistoryUI> {

  late List<OrderInfo> orders;
  ConnectToDatabase connectToDatabase = new ConnectToDatabase();

  late QuerySnapshot orderQS;
  late QuerySnapshot cartItemQS;

  late List<CartItem> cartItems;
  @override
  void initState()
  {
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

    print('cartItems.length ' + cartItems.length.toString());

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
    super.initState();
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
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
      ),
        body: ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            OrderInfo order = orders[index];
            return Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Order Date: ${order.orderDate.toString()}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Order Status: ${OrderStatusExtension(order.orderStatus)}'),
                  ),
                  ExpansionTile(
                    title: Text('Order Items'),
                    leading: Icon(Icons.shopping_bag),
                    children: [
                      for (CartItem item in order.orderItems)
                        if(item.orderNumber == order.orderNumber)
                        Row(
                          children: [
                            Image.network(
                              item.imageUrl,
                              height: 100, // specify the height
                              width: 100, // specify the width
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.productName),
                                  const SizedBox(height: 5),
                                  Text('\$${item.price}'),
                                  const SizedBox(height: 5),
                                  Text('Quantity: ${item.quantity}'),
                                ],
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
    );
  }
}

String OrderStatusExtension (OrderStatus orderStatus){
  switch (orderStatus) {
    case OrderStatus.Pending:
      return 'Pending';
    case OrderStatus.Processing:
      return 'Processing';
    case OrderStatus.InTransit:
      return 'InTransit';
    case OrderStatus.Delivered:
      return 'Delivered';
  }
}