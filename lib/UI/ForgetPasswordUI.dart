import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Database/connecttodatabase.dart';
import '../Entity/account.dart';

class PasswordResetUI extends StatefulWidget {
  const PasswordResetUI({super.key});
  @override
  PasswordResetUIState createState() => PasswordResetUIState();
}

class PasswordResetUIState extends State<PasswordResetUI> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();


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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('DP Store'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Reset your password'),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }

                  if(accounts.where((element) => element.account.toLowerCase() == value.toLowerCase()).length <= 0)
                  {
                    return 'This email\'s not existed';
                  }

                  if (!EmailValidator.validate(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _newPasswordController,
                decoration: InputDecoration(labelText: 'New Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your new password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(labelText: 'Confirm New Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your new password';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      Map<String, dynamic> map = {
                        'password' : _newPasswordController.text
                      };

                      connectToDatabase.Update(map, 'ACCOUNT', 'account', _emailController.text);
                      Navigator.pop(context);
                    } catch (e) {
                      print(e);
                    }
                  }
                },
                child: const Text('Reset Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}