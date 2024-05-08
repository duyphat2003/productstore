import 'package:flutter/material.dart';
import 'package:productstore/UI/HomeUI.dart';
import 'package:productstore/UI/LoginUI.dart';
import 'package:productstore/UI/MyApp.dart';

import '../firebase_options.dart';

import 'package:firebase_core/firebase_core.dart';

import 'ForgetPasswordUI.dart';
import 'RegisterUI.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Singleton(name: '', birthdate: '', address: '', gender: '', accountNumber: '', password: '', status: '');

  runApp(const StartUI());
}
class StartUI extends StatefulWidget {
  const StartUI({super.key});

  @override
  StartUIState createState() => StartUIState();

}

class StartUIState extends State<StartUI>
{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home : const LoginUI(),

      routes: {
        '/register': (context) => const RegistrationUI(),
        '/forgetpassword': (context) => const PasswordResetUI(),
        '/myapp': (context) => const MyApp(),
      },

      debugShowCheckedModeBanner: false,
    );
  }
}

