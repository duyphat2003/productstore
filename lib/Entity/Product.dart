import 'dart:convert';
import 'dart:math';

import 'package:tuple/tuple.dart';

List<Product> productFromJson(String str) =>
    List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  late int id;
  late String title;
  late double price;
  late String description;
  late int category;
  late String imageUrl;

  Product(this.id, this.title, this.description, this.category, this.imageUrl,
      this.price);

  Product.fromJson(Map<Object, dynamic> json) {
    final _random = new Random();
    int GetIntNum(int min, int max) => min + _random.nextInt(max - min);

    double GetDoubleNum(double min, double max) =>
        min + _random.nextDouble() * (max - min);

    id = json["id"];
    title = json["title"];
    description = json["description"];
    category = GetIntNum(1, 4);
    imageUrl = 'https://picsum.photos/204';
    price = double.parse(GetDoubleNum(10000, 400000).toStringAsFixed(2));
  }

  Map<Object, dynamic> toJson() {
    final _random = new Random();
    int GetIntNum(int min, int max) => min + _random.nextInt(max - min);

    double GetDoubleNum(double min, double max) =>
        min + _random.nextDouble() * (max - min);
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['title'] = title;
    data['publication_year'] =
        double.parse(GetDoubleNum(10000, 400000).toStringAsFixed(2));
    data['description'] = description;
    data['cover_image'] = 'https://picsum.photos/204';
    data['genre'] = GetIntNum(1, 4);
    return data;
  }
}
