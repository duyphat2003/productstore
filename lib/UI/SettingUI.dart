import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:productstore/Database/connecttodatabase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Entity/account.dart';
import 'MyApp.dart';

class SettingsUI extends StatefulWidget {
  const SettingsUI({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsUI> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late DateTime _birthdate;
  late String _address;
  late String _gender;
  late String _password;
  ConnectToDatabase connectToDatabase = ConnectToDatabase();
  final _birthdayController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _name = Singleton.account.name;
    DateFormat inputFormat = DateFormat('dd/MM/yyyy');
    DateFormat outputFormat = DateFormat('yyyy-MM-dd');

    DateTime parsedDate = inputFormat.parse(Singleton.account.birthdate);
    _birthdayController.text = outputFormat.format(parsedDate);
    _address = Singleton.account.address;
    _gender = Singleton.account.gender;
    _password = Singleton.account.password;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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

                  Singleton.account.name = _name;

                  _birthdate = DateTime.parse(_birthdayController.text);

                  Singleton.account.birthdate =  DateFormat('dd/MM/yyyy').format(_birthdate);
                  Singleton.account.address = _address;
                  Singleton.account.gender = _gender;
                  Singleton.account.password = _password;

                  Map<String, dynamic> map = {
                    'name' : Singleton.account.name,
                    'birthdate' : Singleton.account.birthdate,
                    'address' : Singleton.account.address,
                    'gender' : Singleton.account.gender,
                    'password' : Singleton.account.password,
                  };
                  print(Singleton.account.name + ' | ' + Singleton.account.birthdate+ ' | ' + Singleton.account.address+ ' | ' + Singleton.account.gender+ ' | ' + Singleton.account.password);
                  connectToDatabase.Update(map, 'ACCOUNT', 'account', Singleton.account.account);
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