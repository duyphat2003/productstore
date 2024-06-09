import 'package:flutter/material.dart';
import 'package:productstore/Entity/product.dart';
import 'package:productstore/api_service/product_service.dart';

class ProductModel extends ChangeNotifier {
  List<Product> products = [];
  void fetchProductList() async {
    products = await ProductServices.fetchProductList();
    notifyListeners();
  }
}
