import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:productstore/Database/ConnectToDatabase.dart';

import '../Entity/CartItem.dart';
import '../Entity/Order.dart';

class EditOrderAdminUI extends StatefulWidget {
  const EditOrderAdminUI({super.key});

  @override
  EditOrderAdminState createState() => EditOrderAdminState();
}

class EditOrderAdminState extends State<EditOrderAdminUI> {
  final _formKey = GlobalKey<FormState>();

  final _orderIdController = TextEditingController();
  final _orderDateController = TextEditingController();
  final _shippingDateController = TextEditingController();

  late String orderNumber;
  late List<CartItem> orderItems;
  late String deliveryDate;
  late OrderStatus orderStatus;

  ConnectToDatabase connectToDatabase = ConnectToDatabase();

  late bool isGet = false;

  @override
  Widget build(BuildContext context) {
    final OrderInfo order = ModalRoute.of(context)!.settings.arguments as OrderInfo;

    const List<String> status = <String>[
      'Pending',
      'Processing',
      'InTransit',
      'Delivered'
    ];

    if (!isGet) {
      _orderIdController.text = order.orderNumber;
      _orderDateController.text = order.orderDate;
      _shippingDateController.text = order.deliveryDate;
      orderStatus = order.orderStatus;
      orderItems = order.orderItems;

      isGet = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Order'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _orderIdController,
                decoration: const InputDecoration(labelText: 'Order ID'),
                readOnly: true,
              ),
              TextFormField(
                controller: _orderDateController,
                decoration: const InputDecoration(labelText: 'Order Date'),
                readOnly: true,
              ),
              GestureDetector(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().toUtc().add(Duration(hours: 7)),
                    firstDate: DateTime(DateTime.now().year).toUtc().add(Duration(hours: 7)),
                    lastDate: DateTime.now().toUtc().add(Duration(days: 3600)),
                    initialEntryMode: DatePickerEntryMode.calendarOnly,
                  );
                  if (picked != null) {
                    setState(() {
                      _shippingDateController.text = picked.toString().substring(0, 10);
                      DateFormat inputFormat = DateFormat('yyyy-MM-dd');
                      DateFormat outputFormat = DateFormat('dd/MM/yyyy');

                      DateTime date = inputFormat.parse(_shippingDateController.text);
                      String formattedDate = outputFormat.format(date);
                      _shippingDateController.text = formattedDate;
                    });
                  }
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _shippingDateController,
                    decoration: InputDecoration(labelText: 'Delievery Date'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your delievery date';
                      }
                      DateFormat inputFormat = DateFormat('dd/MM/yyyy');

                      DateTime date1 = inputFormat.parse(_orderDateController.text);
                      DateTime date2 = inputFormat.parse(_shippingDateController.text);

                      Duration duration = date2.difference(date1);
                      int days = duration.inDays;

                      if (days <= 15) {
                        return 'Please enter delievery date larger than order date 15 days';
                      }

                      return null;
                    },
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    const Text('Gender', style: TextStyle(color: Colors.black)),
                    const SizedBox(width: 10),
                    DropdownMenu<String>(
                      initialSelection: OrderStatusExtension(orderStatus),
                      onSelected: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          orderStatus = StatusConvert(value!);
                        });
                      },
                      dropdownMenuEntries: status.map<DropdownMenuEntry<String>>((String value) {
                        return DropdownMenuEntry<String>(value: value, label: value);
                      }).toList(),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                child: const Text('Save'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Save the updated information here
                    Map<String, dynamic> map = {
                      'deliveryDate': _shippingDateController.text,
                      'orderStatus': OrderStatusExtension(orderStatus),
                    };

                    connectToDatabase.Update(map, 'ORDER', 'orderNumber', order.orderNumber);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ) ,
      ),
    );
  }

  String OrderStatusExtension(OrderStatus orderStatus) {
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

  OrderStatus StatusConvert(String orderStatus) {
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
    return OrderStatus.Pending;
  }
}