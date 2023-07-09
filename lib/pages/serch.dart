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
        title: Text('検索'),
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
                    _serchTextField(ref)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextField _serchTextField(WidgetRef ref) {
    final serchIndexListNotifier = ref.watch(serchIndexListProvider.notifier);
    final List<int> serchIndexList = ref.watch(serchIndexListProvider);
    final booksList = ref.watch(booksProvider);
    return TextField(
      onChanged: (String text) {
        ref.read(keywordProvider.notifier).state = text;
        setState(() {
          keyword = text;
        });
        serchIndexListNotifier.state = [];
        booksList.when(
          data: (books) {
            // データが正常に取得された場合の処理
            for (int i = 0; i < books.length; i++) {
              if (books[i].containsKey(text)) {
                serchIndexListNotifier.state.add(i);
              }
            }
          },
          loading: () => CircularProgressIndicator(),
          error: (error, stackTrace) => Text('Error: $error'),
        );
      },
      decoration:
          InputDecoration(hintText: 'キーワード', border: OutlineInputBorder()),
    );
  }
}
