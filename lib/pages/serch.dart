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
    final selectedValue = ref.watch(selectedValueProvider);
    final keyword = ref.watch(keywordProvider);
    ref.read(keywordProvider.notifier).state = keyword;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('検索条件'),
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
                    const SizedBox(
                      height: 20,
                    ),
                    Text('ジャンル'),
                    DropdownButton(
                        icon: Icon(Icons.arrow_downward),
                        underline: Container(
                          height: 2,
                          color: Colors.green,
                        ),
                        value: selectedValue,
                        items: genre
                            .map((String list) => DropdownMenuItem(
                                child: Text(list), value: list))
                            .toList(),
                        onChanged: (String? value) async {
                          ref.read(selectedValueProvider.notifier).state =
                              value;
                        }),
                    const SizedBox(height: 40),
                    Text(
                      'フィルター',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 30),
                    _searchTextField(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _searchTextField() {
    final searchIndexListNotifier = ref.watch(serchIndexListProvider.notifier);
    final List<int> searchIndexList = ref.watch(serchIndexListProvider);
    final booksList = ref.watch(booksProvider);
    TextEditingController _controller =
        TextEditingController(text: ref.read(keywordProvider.notifier).state);

    List<Map<String, dynamic>> filteredBooks = [];

    return TextFormField(
      controller: _controller,
      onChanged: (String text) async {
        ref.read(keywordProvider.notifier).state = text;
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
