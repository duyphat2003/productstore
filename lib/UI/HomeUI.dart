import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';// Ui library
import '../Database/ConnectToDatabase.dart';
import '../Entity/Product.dart';

class HomeUI extends StatefulWidget {
  const HomeUI({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeUI> with ChangeNotifier{
  TextEditingController textController = TextEditingController();
  late List<Product> popularProducts;
  late List<Product> popularProductsShow;

  ConnectToDatabase connectToDatabase = new ConnectToDatabase();
  late QuerySnapshot products;


  @override
  void initState()
  {
    popularProducts = [];
    popularProductsShow = [];
    connectToDatabase.Read('PRODUCT').then((results) {
        setState(() {
          products = results;
          for (DocumentSnapshot doc in products.docs)
            {
              popularProducts.add(Product(0, doc.get('name'), doc.get('description'), doc.get('category'), doc.get('imageUrl'), doc.get('price')));
            }
          popularProductsShow = popularProducts;
        });
    });
    super.initState();
  }
  final bool isAdmin = true;
  @override
  Widget build(BuildContext context) {
    popularProductsShow = popularProducts;
    final String? nameProduct = ModalRoute.of(context)!.settings.arguments as String?;
    popularProductsShow = popularProductsShow.where((element) => element.title.contains(nameProduct != null ? nameProduct : '')).toList();

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () {
              // Handle notification button press
            },
            icon: const Icon(Icons.notifications),
          ),

          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
            icon: const Icon(Icons.shopping_cart),

          ),

          IconButton(
            onPressed: () {
              if (isAdmin) {
                Navigator.pushNamed(context, '/admin');
              }
            },
            icon: const Icon(Icons.dashboard),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: textController,
              onSubmitted: (value){
                Navigator.pushNamed(context, '/home', arguments: value);

              },
              decoration: InputDecoration(
                hintText: 'Search for products',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
            onRefresh: _handleRefresh,
              child : ListView.builder(
                itemCount: popularProductsShow.length,
                itemBuilder: (context, index) {
                  final product = popularProductsShow[index];
                  return ListTile(
                    onTap: (){
                      Navigator.pushNamed(context, '/productdetail', arguments: Product(0, product.title, product.description, product.category, product.imageUrl, product.price));
                    },
                    leading: Image.network(product.imageUrl),
                    title: Text(product.title),
                    subtitle: Text('\$${product.price}'),
                  );
                },
              ),

            ),
          ),
        ],
      ),
    );
  }
  Future<void> _handleRefresh() async {
    popularProductsShow = popularProducts;
  }
}