import 'package:flutter/material.dart';

class SalesAnalyticsUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/saleanalyticsadmin');
            },
            child: Text('View Sales Analytics'),
          ),
        ],
      ),
    );
  }
}