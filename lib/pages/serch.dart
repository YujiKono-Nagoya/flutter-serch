import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_serch/pages/home.dart';
import 'package:flutter_serch/services/provider.dart';

class SerchPage extends ConsumerStatefulWidget {
  const SerchPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SerchPageState();
}

class _SerchPageState extends ConsumerState<SerchPage> {
  String keyword = '';
  String selectedValue = '指定なし';
  final genre = <String>['指定なし', '人文・思想', '歴史・地理', '科学・工学', '文学・評論', 'アート・建築'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('検索条件')),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.75,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                '検索条件',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              const SizedBox(height: 20),
              SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('ジャンル'),
                    DropdownButton(
                        value: selectedValue,
                        items: genre
                            .map((String list) => DropdownMenuItem(
                                child: Text(list), value: list))
                            .toList(),
                        onChanged: (String? value) async {
                          ref.read(selectedValueProvider.notifier).state =
                              value;
                          setState(() {
                            selectedValue = value!;
                          });
                        }),
                    Text('フィルター'),
                    _searchTextField(ref)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextField _searchTextField(WidgetRef ref) {
    final searchIndexListNotifier = ref.watch(serchIndexListProvider.notifier);
    final List<int> searchIndexList = ref.watch(serchIndexListProvider);
    final booksList = ref.watch(booksProvider);

    List<Map<String, dynamic>> filteredBooks = [];

    return TextField(
      onChanged: (String text) {
        ref.read(keywordProvider.notifier).state = text;
        setState(() {
          keyword = text;
        });
        searchIndexListNotifier.state = [];
        booksList.when(
          data: (books) {
            filteredBooks = books
                .where((element) => element['content'].contains(text))
                .toList();
          },
          loading: () => CircularProgressIndicator(),
          error: (error, stackTrace) => Text('Error: $error'),
        );
      },
      decoration: InputDecoration(
        hintText: 'キーワード',
        border: OutlineInputBorder(),
      ),
    );
  }
}
