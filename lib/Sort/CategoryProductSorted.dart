import 'package:flutter/cupertino.dart';

import '../Entity/Product.dart';

class CategoryProductSorted extends ChangeNotifier {
  final int category;
  final String sortType;

  CategoryProductSorted(this.category, this.sortType);

  void RefreshList(List<Product> products, String sortIndex)
  {
    switch(sortIndex)
    {
      case 'Sort by A-Z':
        products.sort((a, b) => a.title.compareTo(b.title));
        break;

      case 'Sort by Z-A':
        products.sort((a, b) => b.price.compareTo(a.price));
        break;

      case 'Sort by price (low to high)':
        products.sort((a, b) => a.price.compareTo(b.price));
        break;

      case 'Sort by price (high to low)':
        products.sort((a, b) => b.price.compareTo(a.price));
        break;
    }
    notifyListeners();
  }
}