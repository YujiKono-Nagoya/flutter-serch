import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateProvider<List<int>> serchIndexListProvider = StateProvider((ref) {
  return [];
});

final booksProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  //監視は.sateいらない
  final selectedValue = ref.watch(selectedValueProvider);

  Stream<QuerySnapshot<Map<String, dynamic>>> stream;

  if (selectedValue != '指定なし') {
    stream = FirebaseFirestore.instance
        .collection('book')
        .where('genre', isEqualTo: selectedValue)
        .snapshots();
  } else {
    stream = FirebaseFirestore.instance.collection('book').snapshots();
  }

  return stream.map((querySnapshot) => querySnapshot.docs
      .map((doc) => doc.data() as Map<String, dynamic>)
      .toList());
});

final selectedValueProvider = StateProvider<String?>((ref) {
  return '指定なし';
});

final keywordProvider = StateProvider<String?>((ref) {
  return '';
});
