import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Database/connecttodatabase.dart';
import '../Entity/account.dart';

class EditAccountUI extends StatefulWidget {
  const EditAccountUI({super.key});

  @override
  _EditAccountPageState createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountUI> {
  final _formKey = GlobalKey<FormState>();

  late String _name;
  late DateTime _birthdate;
  late String _address;
  late String _gender;
  late String _password;

  ConnectToDatabase connectToDatabase = new ConnectToDatabase();
  final _birthdayController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Account account = ModalRoute.of(context)!.settings.arguments as Account;

    _name = account.name;
    DateFormat inputFormat = DateFormat('dd/MM/yyyy');
    DateFormat outputFormat = DateFormat('yyyy-MM-dd');

    DateTime parsedDate = inputFormat.parse(account.birthdate);
    _birthdayController.text = outputFormat.format(parsedDate);
    _address = account.address;
    _gender = account.gender;
    _password = account.password;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Edit Account'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              initialValue: _name,
              decoration: InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
              onSaved: (value) => _name = value!,
            ),
            SizedBox(height: 16),
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
            SizedBox(height: 16),
            TextFormField(
              initialValue: _address,
              decoration: InputDecoration(labelText: 'Address'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an address';
                }
                return null;
              },
              onSaved: (value) => _address = value!,
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _gender,
              decoration: InputDecoration(labelText: 'Gender'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a gender';
                }
                return null;
              },
              onChanged: (value) => setState(() => _gender = value!),
              onSaved: (value) => _gender = value!,
              items: ['Male', 'Female']
                  .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              ))
                  .toList(),
            ),
            SizedBox(height: 16),
            TextFormField(
              initialValue: _password,
              decoration: InputDecoration(labelText: 'Password'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                }
                return null;
              },
              onSaved: (value) => _password = value!,
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  account.name = _name;

                  _birthdate = DateTime.parse(_birthdayController.text);

                  account.birthdate =  DateFormat('dd/MM/yyyy').format(_birthdate);
                  account.address = _address;
                  account.gender = _gender;
                  account.password = _password;

                  Map<String, dynamic> map = {
                    'name' : account.name,
                    'birthdate' : account.birthdate,
                    'address' : account.address,
                    'gender' : account.gender,
                    'password' : account.password,
                  };
                  print(account.name + ' | ' + account.birthdate+ ' | ' + account.address+ ' | ' + account.gender+ ' | ' + account.password);
                  connectToDatabase.Update(map, 'ACCOUNT', 'account', account.account);
                  Navigator.pop(context);
                }
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}