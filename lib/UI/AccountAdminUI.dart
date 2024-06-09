import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:productstore/Entity/account.dart';

import '../Database/connecttodatabase.dart';

class AccountAdminUI extends StatefulWidget {
  const AccountAdminUI({super.key});
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountAdminUI> {
  late List<Account> accounts;

  ConnectToDatabase connectToDatabase = new ConnectToDatabase();
  late QuerySnapshot products;

  @override
  void initState()
  {
    accounts = [];
    connectToDatabase.Read('ACCOUNT').then((results) {
      setState(() {
        products = results;
        for (DocumentSnapshot doc in products.docs)
        {
          accounts.add(Account(doc.get('name'), doc.get('birthdate'), doc.get('address'), doc.get('gender'), doc.get('account'), doc.get('password'), doc.get('status')));
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateFormat format = new DateFormat("dd/MM/yyyy");
    DateTime currentDate = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Accounts'),
      ),
      body: ListView.builder(
        itemCount: accounts.length,
        itemBuilder: (context, index) {
          DateTime dateTime = format.parse(accounts[index].birthdate);

          final getAge = daysBetween(dateTime, currentDate);
          String formattedNumber = (getAge/365).toStringAsFixed(0);
          return ListTile(
            leading: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.pushNamed(context, '/editaccountadmin', arguments:  accounts[index]);
              },
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  connectToDatabase.Delete('ACCOUNT', 'account', accounts[index].account);
                  accounts.removeAt(index);
                });

              },
            ),
            title: Text(accounts[index].account),
            subtitle: Text(accounts[index].name + ' | ' + accounts[index].gender + ' | ' + formattedNumber + ' ages'),
          );
        },
      ),
    );
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }
}