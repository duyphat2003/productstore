import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:productstore/UI/MyApp.dart';

import '../Database/ConnectToDatabase.dart';
import '../Entity/Account.dart';

class LoginUI extends StatefulWidget {
  const LoginUI({super.key});

  @override
  _LoginUIState createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late String account = '';

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

  late bool denied = false;
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
              const Center(
                child: Text(
                  'Login to your account',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }

                  if(accounts.where((element) => element.account.toLowerCase() == value.toLowerCase()).length <= 0)
                  {
                    return 'This email\'s not existed';
                  }

                  if(accounts.where((element) => element.account.toLowerCase() == _emailController.text.toLowerCase()).first.status == 'Log In')
                  {
                    return 'This Email\'s already logged in by another person';
                  }

                  if (!EmailValidator.validate(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }

                  if(accounts.where((element) => element.account == _emailController.text &&  element.password.toLowerCase() == value.toLowerCase()).length <= 0)
                  {
                    return 'Wrong password';
                  }

                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),

              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      if(accounts.where((element) => element.account.toLowerCase() == _emailController.text.toLowerCase()).first.status == 'Log In')
                      {
                        return;
                      }
                      Account account = accounts.where((element) => element.account.toLowerCase() == _emailController.text.toLowerCase()).first;
                      Map<String, dynamic> map = {
                        'status' : 'Log In'
                      };

                      Singleton.account = account;

                      connectToDatabase.Update(map, 'ACCOUNT', 'account', _emailController.text);

                      Navigator.pushNamed(context, '/myapp');
                    } catch (e) {
                      print(e);
                    }
                  }
                },
                child: const Text('Sign in'),
              ),

              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    Navigator.pushNamed(context, '/register');
                  });
                },
                child: const Text('Sign up'),
              ),


              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    setState(() {
                      Navigator.pushNamed(context, '/forgetpassword');
                    });
                  });
                },
                child: const Text('Forget password?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}