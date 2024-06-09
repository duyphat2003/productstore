import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:productstore/view_model/productmodel.dart';

import '../Database/connecttodatabase.dart';
import '../Entity/Product.dart';

class ProductDetailUI extends StatefulWidget {
  const ProductDetailUI({super.key});

  @override
  ProductDetailState createState() => ProductDetailState();
}

class ProductDetailState extends State<ProductDetailUI> {
  late List<Product> popularProducts;
  late List<Product> popularProductsShow;

  ConnectToDatabase connectToDatabase = ConnectToDatabase();
  late QuerySnapshot products;

  final ProductModel productModel = ProductModel();
  @override
  void initState() {
    popularProducts = [];
    popularProductsShow = [];
    connectToDatabase.Read('PRODUCT').then((results) {
      setState(() {
        products = results;
        for (DocumentSnapshot doc in products.docs) {
          popularProducts.add(Product(
              0,
              doc.get('name'),
              doc.get('description'),
              doc.get('category'),
              doc.get('imageUrl'),
              doc.get('price')));
        }
        popularProductsShow = popularProducts;
      });
    });

    getListCategory();
    super.initState();
    productModel.fetchProductList();
  }

  List<String>? categories;
  var isLoaded = false;

  getListCategory() async {
    categories = await connectToDatabase.fetchCategories();
    if (categories != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    popularProductsShow = popularProducts;
    final Product product =
        ModalRoute.of(context)!.settings.arguments as Product;
    popularProductsShow = popularProductsShow
        .where((element) =>
            element.category == product.category &&
            element.title != product.title)
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/cart', arguments: product);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Image.network(product.imageUrl),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(product.title),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    if (_quantity > 1) {
                      _quantity--;
                    }
                  });
                },
              ),
              Text('$_quantity'),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    _quantity++;
                  });
                },
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/cart',
                  arguments: CartItemOrder(product, _quantity));
            },
            child: const Text('Buy'),
          ),
          Text(product.description),
          Expanded(
              child: ListView.builder(
            itemCount: popularProductsShow.length,
            itemBuilder: (context, index) {
              final relatedProduct = popularProductsShow[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/productdetail',
                      arguments: Product(
                          0,
                          relatedProduct.title,
                          relatedProduct.description,
                          relatedProduct.category,
                          relatedProduct.imageUrl,
                          relatedProduct.price));
                },
                child: ListTile(
                  leading: Image.network(relatedProduct.imageUrl),
                  title: Text(relatedProduct.title),
                  subtitle: Text(categories![relatedProduct.category - 1]),
                  trailing: Text('\$${relatedProduct.price}'),
                ),
              );
            },
          )),
        ],
      ),
    );
  }
}

class CartItemOrder {
  final Product product;
  final int amount;

  CartItemOrder(this.product, this.amount);
}
