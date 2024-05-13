import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../Entity/Product.dart';
import 'package:http/http.dart' as http;

class ConnectToDatabase {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Read(String nameTable) async {
    return await firestore.collection(nameTable).get();
  }

  Insert(Map<String, dynamic> datas, String nameTable) async {
    await firestore.collection(nameTable).add(datas);
    print('Inserted one product');
  }

  Update(Map<String, dynamic> datas, String nameTable, String field,
      String condition) async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(nameTable);
    final query = collectionReference.where(field, isEqualTo: condition);
    final snapshot = await query.get();
    if (snapshot.docs.isNotEmpty) {
      final ref = snapshot.docs.first.reference;

      await ref.update(datas).then((value) {
        print('Updated successfully');
      }).catchError((error) {
        print('Error updating: $error');
      });
    }
  }

  Delete(String nameTable, String field, String condition) async {
    final snapshot = await FirebaseFirestore.instance
        .collection(nameTable)
        .where(field, isEqualTo: condition)
        .get();
    if (snapshot.docs.isNotEmpty) {
      for (final doc in snapshot.docs) {
        await doc.reference.delete();
      }
    }
  }
  List<String> categoriesFromJson(String str) => List<String>.from(json.decode(str).map((x) => x));

  String categoriesToJson(List<String> data) => json.encode(List<dynamic>.from(data.map((x) => x)));

  Future<List<String>?> fetchCategories() async {
    final httpClient = http.Client();
    final response = await httpClient
        .get(Uri.parse('https://fakestoreapi.com/products/categories'));

    if (response.statusCode == 200) {
      final jsonString = response.body;
      return categoriesFromJson(jsonString);
    } else {
      throw Exception('Failed to load categories: ${response.statusCode}');
    }
  }

}
