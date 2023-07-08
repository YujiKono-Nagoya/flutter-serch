import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_serch/pages/home.dart';

final selectedValueProvider = StateProvider<String?>((ref) {
  return '指定なし';
});

class AddPage extends ConsumerStatefulWidget {
  const AddPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddPageState();
}

class _AddPageState extends ConsumerState<AddPage> {
  TextEditingController titleEditingController = TextEditingController();
  TextEditingController authorEditingController = TextEditingController();
  TextEditingController contentEditingController = TextEditingController();

  String? selectedValue = '指定なし';
  final genre = <String>['指定なし', '人文・思想', '歴史・地理', '科学・工学', '文学・評論', 'アート・建築'];

  void addBook() async {
    await FirebaseFirestore.instance.collection('book').add({
      'genre': selectedValue,
      'title': titleEditingController.text,
      'author': authorEditingController.text,
      'content': contentEditingController.text,
    });
  }

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
                        onChanged: (String? value) {
                          ref.read(selectedValueProvider.notifier).state =
                              value;

                          setState(() {
                            selectedValue = value!;
                          });
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: titleEditingController,
                        decoration: const InputDecoration(
                            labelText: 'タイトル', border: OutlineInputBorder()),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: authorEditingController,
                        decoration: const InputDecoration(
                            labelText: '著者', border: OutlineInputBorder()),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: contentEditingController,
                        decoration: const InputDecoration(
                            labelText: '内容', border: OutlineInputBorder()),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(20)),
                        onPressed: addBook,
                        child: Text('登録'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
