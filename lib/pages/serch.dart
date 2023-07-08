import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_serch/pages/home.dart';

final selectedValueProvider = StateProvider<String?>((ref) {
  return '指定なし';
});

final keywordProvider = StateProvider<String?>((ref) {
  return '';
});

final booksProvider = FutureProvider<List>((ref) async {
  final keyword = ref.watch(keywordProvider.notifier).state;
  final selectedValue = ref.watch(selectedValueProvider.notifier).state;

  if (selectedValue != '指定なし' && keyword != '') {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('book')
        .where('genre', isEqualTo: selectedValue)
        .where('content', arrayContains: keyword)
        .get();
    List<Map<String, dynamic>> data = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
    return data;
  } else if (selectedValue != '指定なし' && keyword == '') {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('book')
        .where('genre', isEqualTo: selectedValue)
        .get();
    List<Map<String, dynamic>> data = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
    return data;
  } else if (selectedValue == '指定なし' && keyword != '') {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('book')
        .where('content', arrayContains: keyword)
        .get();
    List<Map<String, dynamic>> data = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
    return data;
  } else {
    // selectedValueが'指定なし'かつkeywordが空の場合はデフォルトの処理を行う
    // ここでは全ての書籍を取得する
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('book').get();
    List<Map<String, dynamic>> data = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
    return data;
  }
});

// final bookskeywordProvider = FutureProvider<List>((ref) async {
//   final keyword = ref.watch(keywordProvider.notifier).state;

//   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//       .collection('book')
//       .where('content', arrayContains: keyword)
//       .get();
//   List<Map<String, dynamic>> data = querySnapshot.docs
//       .map((doc) => doc.data() as Map<String, dynamic>)
//       .toList();
//   return data;
// });

// final booksgenreProvider = FutureProvider<List>((ref) async {
//   final selectedValue = ref.watch(selectedValueProvider.notifier).state;
//   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//       .collection('book')
//       .where('genre', isEqualTo: selectedValue)
//       .get();
//   List<Map<String, dynamic>> data = querySnapshot.docs
//       .map((doc) => doc.data() as Map<String, dynamic>)
//       .toList();
//   return data;
// });

// final booksbothProvider = FutureProvider<List>((ref) async {
//   final keyword = ref.watch(keywordProvider.notifier).state;
//   final selectedValue = ref.watch(selectedValueProvider.notifier).state;

//   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//       .collection('book')
//       .where('genre', isEqualTo: selectedValue)
//       .where('content', arrayContains: keyword)
//       .get();
//   List<Map<String, dynamic>> data = querySnapshot.docs
//       .map((doc) => doc.data() as Map<String, dynamic>)
//       .toList();
//   return data;
// });

class SerchPage extends ConsumerStatefulWidget {
  const SerchPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SerchPageState();
}

class _SerchPageState extends ConsumerState<SerchPage> {
  TextEditingController keywordController = TextEditingController();
  String selectedValue = '指定なし';
  final genre = <String>['指定なし', '人文・思想', '歴史・地理', '科学・工学', '文学・評論', 'アート・建築'];

  @override
  Widget build(BuildContext context) {
    var keyword = ref.watch(keywordProvider.notifier).state;
    var selectedValue = ref.watch(selectedValueProvider.notifier).state;
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
                    TextField(
                      controller: keywordController,
                      onChanged: (String? value) async {
                        ref.read(keywordProvider.notifier).state = value;
                        setState(() {
                          keyword = value!;
                        });
                      },
                      decoration: InputDecoration(
                          hintText: 'キーワード', border: OutlineInputBorder()),
                    )
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
