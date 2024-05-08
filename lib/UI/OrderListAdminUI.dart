import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Database/ConnectToDatabase.dart';
import '../Entity/CartItem.dart';
import '../Entity/Order.dart';

class OrderListAdminUI extends StatefulWidget {
  const OrderListAdminUI({super.key});

  @override
  OrderListState createState() => OrderListState();
}

class OrderListState extends State<OrderListAdminUI> {

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

//Thêm trang chỉnh sửa đơn hàng (Thông tin(ngày đặt (Không chỉnh), trạng thái, ngày giao), nút đồng ý sửa)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Orders'),
      ),
        body: ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            OrderInfo order = orders[index];
            return Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
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
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.pushNamed(context, '/editorderadmin', arguments: order);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                connectToDatabase.Delete('ORDER', 'orderNumber', order.orderNumber);
                                connectToDatabase.Delete('ORDERITEM', 'orderNumber', order.orderNumber);
                                orders.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  ExpansionTile(
                    title: Text('Order Items'),
                    leading: Icon(Icons.shopping_cart),
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
        )
    );
  }
}

String OrderStatusExtension (OrderStatus orderStatus){
  switch (orderStatus) {
    case OrderStatus.Pending:
      return 'Pending';
    case OrderStatus.Processing:
      return 'Shipped';
    case OrderStatus.InTransit:
      return 'inTransit';
    case OrderStatus.Delivered:
      return 'delivered';
  }
}
