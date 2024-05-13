import 'package:flutter/material.dart';
import 'package:productstore/Database/ConnectToDatabase.dart';
import 'dart:developer';
import '../Sort/CategoryProductSorted.dart';

class CategoryUI extends StatefulWidget {
  const CategoryUI({super.key});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryUI> {
  late ConnectToDatabase connectToDatabase;

  late List<String> _categoriesImage = [
    'https://cdn-icons-png.freepik.com/512/3696/3696504.png',
    'https://cdn0.iconfinder.com/data/icons/fashion-and-clothes-accessories-icons/64/Clothes_NECKLACE-512.png',
    'https://cdn-icons-png.flaticon.com/512/6909/6909544.png',
    'https://cdn-icons-png.flaticon.com/512/3534/3534312.png'
  ];

  List<String>? categories;
  var isLoaded = false;

  @override
  void initState() {
    super.initState();
    connectToDatabase = ConnectToDatabase();
    getListCategory();
  }

  getListCategory() async {
    categories = await connectToDatabase.fetchCategories();
    if (categories != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Categories'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categories?.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        itemBuilder: (context, index) {
          String category = categories![index];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/product',
                  arguments: CategoryProductSorted(index + 1, '1'));
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Image.network(_categoriesImage[index]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
