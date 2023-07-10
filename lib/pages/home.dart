import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_serch/pages/add_page.dart';
import 'package:flutter_serch/pages/serch.dart';
import 'package:flutter_serch/services/provider.dart';

// class Home extends ConsumerWidget {
//   const Home({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final AsyncValue<List<Map<String, dynamic>>> booksList =
//         ref.watch(booksProvider);

//     // AsyncValue<List> booksGenreList = ref.watch(booksgenreProvider);
//     // AsyncValue<List> booksKeywordList = ref.watch(bookskeywordProvider);
//     // AsyncValue<List> booksBothList = ref.watch(booksbothProvider);

//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: false,
//         title: Text('著者一覧'),
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.of(context)
//                   .push(MaterialPageRoute(builder: (context) => SerchPage()));
//             },
//             icon: Icon(Icons.search),
//           ),
//         ],
// ),
// body: booksList.when(
//   data: (books) {
//     // データが正常に取得された場合の処理
//     return ListView.builder(
//       itemCount: books.length,
//       itemBuilder: (context, index) {
//         Map<String, dynamic> bookData = books[index];
//         // データの表示や処理を行うウィジェットを返す
//         return Card(
//           child: Column(
//             children: [
//               Text(
//                 '${bookData['title']}-${bookData['author']}',
//                 style:
//                     TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
//               ),
//               Text(
//                 '${bookData['content']}',
//                 style: TextStyle(fontSize: 20),
//               )
//             ],
//           ),
//         );
//       },
//     );
//   },
//         loading: () {
//           // データの読み込み中の表示など、ローディング状態の処理
//           return Center(child: CircularProgressIndicator());
//         },
//         error: (error, stackTrace) {
//           // エラーが発生した場合の処理
//           return Text('エラーが発生しました');
//         },
//       ),
//       floatingActionButton: FloatingActionButton(onPressed: () {
//         Navigator.of(context)
//             .push(MaterialPageRoute(builder: (context) => AddPage()));
//       }),
//     );
//   }
// }

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksList = ref.watch(booksProvider);
    final keyword = ref.watch(keywordProvider);
    final serchIndexListNotifier = ref.watch(serchIndexListProvider.notifier);
    final serchIndexList = ref.watch(serchIndexListProvider);

    List<Map<String, dynamic>> filteredBooks = [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: false,
        title: Text('著者一覧'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => SerchPage()));
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: keyword != ''
          ? booksList.when(
              data: (books) {
                filteredBooks = books
                    .where((element) => element['content'].contains(keyword))
                    .toList();
                return _searchBooks(ref, filteredBooks);
              },
              loading: () => CircularProgressIndicator(),
              error: (error, stackTrace) => Text('Error: $error'),
            )
          : _allbooks(booksList),
    );
  }

  Widget? _allbooks(AsyncValue<List<Map<String, dynamic>>> booksList) {
    return booksList.when(
      data: (books) {
        // データが正常に取得された場合の処理
        return ListView.builder(
          itemCount: books.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> bookData = books[index];
            // データの表示や処理を行うウィジェットを返す
            return Card(
              child: Column(
                children: [
                  Text(
                    '${bookData['title']}-${bookData['author']}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  Text(
                    '${bookData['content']}',
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
            );
          },
        );
      },
      loading: () => CircularProgressIndicator(),
      error: (error, stackTrace) => Text('Error: $error'),
    );
  }

  Widget _searchBooks(
    WidgetRef ref,
    List<Map<String, dynamic>> filteredBooks,
  ) {
    return ListView.builder(
      itemCount: filteredBooks.length,
      itemBuilder: (context, int index) {
        Map<String, dynamic> bookData = filteredBooks[index];
        return Card(
          child: Column(
            children: [
              Text(
                '${bookData['title']}-${bookData['author']}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              Text(
                '${bookData['content']}',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        );
      },
    );
  }
}
