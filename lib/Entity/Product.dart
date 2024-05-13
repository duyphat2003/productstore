import 'dart:convert';

import 'package:tuple/tuple.dart';

List<Product> productFromJson(String str) => List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  late int id;
  late String title;
  late double price;
  late String description;
  late int category;
  late String imageUrl;

  Product(this.id, this.title, this.description, this.category, this.imageUrl,
      this.price);

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        json["id"],
        json["title"],
        json["description"],
        json["category"],
        json["image"],
        json["price"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
      'title': title,
      'price': price,
      'description': description,
      'image': imageUrl,
      'category': category,
    };
}
