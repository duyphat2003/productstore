import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:productstore/Database/connecttodatabase.dart';
import 'package:productstore/Entity/account.dart';
import 'package:productstore/UI/MyApp.dart';

class ProfileUI extends StatefulWidget {
  const ProfileUI({super.key});

  @override
  ProfileUIState createState() => ProfileUIState();
}

class ProfileUIState extends State<ProfileUI> {
  late bool isConverted = false;
  late String formattedNumber = '';
  ConnectToDatabase connectToDatabase = ConnectToDatabase();

  @override
  Widget build(BuildContext context) {

    if(!isConverted) {
      DateFormat format = DateFormat("dd/MM/yyyy");
      DateTime currentDate = DateTime.now();

      DateTime dateTime = format.parse(Singleton.account.birthdate);

      final getAge = daysBetween(dateTime, currentDate);
      formattedNumber = (getAge / 365).toStringAsFixed(0);
      isConverted = true;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/setting');
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
        ],
      ),

      body: Column(
        children: [

          // Profile Header
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/profile_image.png'),
                ),
                const SizedBox(height: 16),
                Text(
                  Singleton.account.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  '${Singleton.account.gender} | $formattedNumber ages',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Menu Items
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ListTile(
                  leading: const Icon(Icons.receipt, color: Colors.blue),
                  title: const Text('Order History'),
                  onTap: () {
                    Navigator.pushNamed(context, '/orderhistory');
                  },
                ),
              ),
              Expanded(
                child: ListTile(
                  leading: const Icon(Icons.favorite, color: Colors.red),
                  title: const Text('Wishlist'),
                  onTap: () {
                    // Handle wishlist button press
                  },
                ),
              ),

              Expanded(
                child: ListTile(
                  leading: const Icon(Icons.exit_to_app, color: Colors.red),
                  title: const Text('Log out'),
                  onTap: () {
                    setState(() {
                      Map<String, dynamic> map = {
                        'status' : 'Not Log In'
                      };


                      connectToDatabase.Update(map, 'ACCOUNT', 'account', Singleton.account.account);
                      Navigator.pushNamed(context, '/login');
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }
}