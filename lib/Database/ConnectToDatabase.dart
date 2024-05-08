import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../Entity/Product.dart';


class ConnectToDatabase {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Read(String nameTable) async {
    return await firestore.collection(nameTable).get();
  }

  Insert(Map<String, dynamic> datas, String nameTable) async {
    await firestore.collection(nameTable).add(datas);
    print('Inserted one product');
  }

  Update(Map<String, dynamic> datas, String nameTable, String field, String condition) async {
    CollectionReference collectionReference = FirebaseFirestore.instance.collection(nameTable);
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

  Delete (String nameTable, String field, String condition)
  async
  {
    final snapshot = await FirebaseFirestore.instance.collection(nameTable).where(field, isEqualTo: condition).get();
    if (snapshot.docs.isNotEmpty) {
      for (final doc in snapshot.docs) {
        await doc.reference.delete();
      }
    }
  }
}


