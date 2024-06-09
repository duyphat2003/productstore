import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:productstore/Database/connecttodatabase.dart';
import 'package:productstore/Entity/account.dart';


class RegistrationUI extends StatefulWidget {
  const RegistrationUI({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationUI> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _addressController = TextEditingController();
  final _genderController = TextEditingController();

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
          accounts.add(Account(doc.get('name'), doc.get('birthdate'), doc.get('address'), doc.get('gender'), doc.get('account'), doc.get('password'), doc.get('doc')));
        }
      });
    });
    super.initState();
  }

  late bool isGet = false;
  @override
  Widget build(BuildContext context) {
    if(!isGet) {
      _genderController.text = 'Male';
      isGet = true;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('DP Store'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text('Create a new account'),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }

                    for (Account account in accounts)
                      {
                        if(account.account.toLowerCase() == value.toLowerCase())
                          {
                            return 'Email\'s already existed';
                          }
                      }

                    if (!EmailValidator.validate(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                GestureDetector(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().toUtc().add(Duration(hours: 7)),
                      firstDate: DateTime(1900).toUtc().add(Duration(hours: 7)),
                      lastDate: DateTime.now().toUtc().add(Duration(hours: 7)),
                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                    );
                    if (picked != null) {
                      setState(() {
                        _birthdayController.text = picked.toString().substring(0, 10);
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _birthdayController,
                      decoration: InputDecoration(labelText: 'Birthday'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your birthday';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: 'Male',
                  decoration: InputDecoration(labelText: 'Gender'),
                  onChanged: (value) {
                    setState(() {
                      _genderController.text = value!;
                    });
                  },
                  items: ['Male', 'Female', 'Other'].map((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      DateFormat dateFormat = DateFormat('dd/MM/yyyy');
                      DateTime parsedDate = DateTime.parse(_birthdayController.text);
                      String formattedDate = dateFormat.format(parsedDate);

                      Map<String, dynamic> map = {
                        'name' : _nameController.text,
                        'birthdate' : formattedDate,
                        'address' : _addressController.text,
                        'gender' : _genderController.text,
                        'account' : _emailController.text,
                        'password' : _passwordController.text,
                        'status' : 'Not Log In'
                        };
                      connectToDatabase.Insert(map, 'ACCOUNT');
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}