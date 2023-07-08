import 'package:flutter/material.dart';

@immutable
class Book {
  const Book(
      {required this.id,
      required this.title,
      required this.content,
      required this.genre,
      required this.author});

  final int id;
  final String title;
  final String content;
  final String genre;
  final String author;

  Book copywith(
      {int? id,
      String? title,
      String? content,
      String? genre,
      String? author}) {
    return Book(
        id: id ?? this.id,
        title: title ?? this.title,
        content: content ?? this.content,
        genre: genre ?? this.genre,
        author: author ?? this.author);
  }
}
