import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Database/connecttodatabase.dart';
import '../Entity/Product.dart';
import '../Sort/categoryproductsorted.dart';

class ProductUI extends StatefulWidget {
  const ProductUI({super.key});
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductUI> {
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

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as CategoryProductSorted;
    final int category = data.category;
    String sortIndex = data.sortType;

    popularProductsShow = popularProducts;
    popularProductsShow = popularProductsShow.where((product) => product.category == category).toList();;


    switch(sortIndex)
    {
      case '1':
        popularProductsShow.sort((a, b) => a.title.compareTo(b.title));
        break;

      case '2':
        popularProductsShow.sort((a, b) => b.price.compareTo(a.price));
        break;

      case '3':
        popularProductsShow.sort((a, b) => a.price.compareTo(b.price));
        break;

      case '4':
        popularProductsShow.sort((a, b) => b.price.compareTo(a.price));
        break;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Product List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle shopping cart button press
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Products',
                  style: TextStyle(fontSize: 24.0),
                ),
                DropdownButton<String>(
                  value: sortIndex,
                  onChanged: (value) {
                    setState(() {
                      sortIndex = value!;
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/product', arguments: CategoryProductSorted(category, sortIndex));
                    });
                  },
                  items: const [
                    DropdownMenuItem(
                      value: '1',
                      child: Text('Sort by A-Z'),
                    ),

                    DropdownMenuItem(
                      value: '2',
                      child: Text('Sort by Z-A'),
                    ),

                    DropdownMenuItem(
                      value: '3',
                      child: Text('Sort by price (low to high)'),
                    ),

                    DropdownMenuItem(
                      value: '4',
                      child: Text('Sort by price (high to low)'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: popularProductsShow.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: (){
                    Navigator.pushNamed(context, '/productdetail', arguments: Product(0, popularProductsShow[index].title, popularProductsShow[index].description, popularProductsShow[index].category, popularProductsShow[index].imageUrl, popularProductsShow[index].price));
                  },
                  leading: Image.network(popularProductsShow[index].imageUrl),
                  title: Text('${popularProductsShow[index].title}'),
                  subtitle: Text('${popularProductsShow[index].description}'),
                  trailing: Text('\$${popularProductsShow[index].price}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}