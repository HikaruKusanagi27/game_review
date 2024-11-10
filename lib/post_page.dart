import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:table_calendar/table_calendar.dart';

const List<String> platformList = <String>['Switch', 'PS5', 'Steam'];

const List<String> makerList = <String>['ソニー', 'ニンテンドー', 'セガ'];

const List<String> genreList = <String>['アクション', 'RPG', 'シュミレーション'];

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  DateTime? _selectedDate;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String _displayedTitleText = 'タイトルが入力されていません';
  String _displayedDateText = '日付が入力されていません';
  File? _selectedImage;

  // 新たにプラットフォーム、メーカー、ジャンルの選択状態を保存する変数を追加
  String _selectedPlatform = platformList.first;
  String _selectedMaker = makerList.first;
  String _selectedGenre = genreList.first;

  @override
  void initState() {
    super.initState();

    _titleController.addListener(() {
      setState(() {
        _displayedTitleText = _titleController.text.isNotEmpty
            ? _titleController.text
            : "タイトルが入力されていません";
      });
    });

    _dateController.addListener(() {
      setState(() {
        _displayedDateText = _dateController.text.isNotEmpty
            ? _dateController.text
            : "日付が入力されていません";
      });
    });
  }

  // Firebaseにデータを保存するメソッド
  Future<void> _saveDataToFirebase(String imageUrl) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      await firestore.collection('dataList').add({
        'name': _titleController.text,
        'release': _selectedDate != null ? _dateController.text : '',
        'platform': _selectedPlatform, // 固定値を設定（実際のアプリではDropdownの値を使用）
        'maker': _selectedMaker, // 固定値を設定（実際のアプリではDropdownの値を使用）
        'genre': _selectedGenre, // 固定値を設定（実際のアプリではDropdownの値を使用）
        'imageURL': imageUrl, // Firebase StorageにアップロードするならそのURLを設定
      });
      Navigator.pop(context); // 投稿後に前の画面に戻る
    } catch (e) {
      print('Error saving data to Firebase: $e');
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _clearDate() {
    setState(() {
      _dateController.clear(); // TextFieldの内容をクリア
      _selectedDate = null; // 日付の選択をクリア
      _displayedDateText = "日付が入力されていません"; // 表示テキストをクリア
    });
  }

  void _clearTitle() {
    setState(() {
      _titleController.clear(); // TextFieldの内容をクリア
      _displayedTitleText = "タイトルが入力されていません"; // 表示テキストをクリア
    });
  }

  // 画像を取得するメソッド
  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      // pickedFileがnullでない場合のみセット
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      } else {
        // nullの場合の処理（エラーメッセージの表示など）
        print("画像が選択されませんでした");
      }
    } catch (e) {
      // エラー処理
      print("画像の選択に失敗しました: $e");
    }
  }

  // 画像ファイルのアップロードとFireStoreへの保存
  Future<void> _uploadImageAndSaveData() async {
    if (_selectedImage == null) {
      print("画像を選択してください");
      return;
    }

    try {
      // Firebase Storageに画像をアップロード
      final storage = FirebaseStorage.instance;
      final storageRef = storage
          .ref()
          .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await storageRef.putFile(_selectedImage!);

      // アップロードした画像のURLを取得
      final imageUrl = await storageRef.getDownloadURL();

      // Firestoreにデータを保存
      await _saveDataToFirebase(imageUrl);
      print("データが正常に保存されました");
    } catch (e) {
      print("画像のアップロードまたはデータ保存に失敗しました: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan[50],
      ),
      body: Container(
        color: Colors.cyan[400],
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: SizedBox(
                      height: 300,
                      width: 300,
                      child: Card(
                          color: Colors.grey,
                          child: Center(
                              child: _selectedImage == null
                                  ? const Text('         タップして\n画像選択してください')
                                  : Image.file(
                                      _selectedImage!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Text('画像の読み込みに失敗しました');
                                      },
                                    ))),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'タイトル',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: _clearTitle, // クリアボタン
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _dateController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '発売日',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: _clearDate, // クリアボタン
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text('タイトル:'),
                    SizedBox(width: 10),
                    Text(
                      _displayedTitleText,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text('発売日:'),
                    SizedBox(width: 10),
                    Text(
                      _displayedDateText,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                TableCalendar(
                  firstDay: DateTime.utc(2010, 1, 1),
                  lastDay: DateTime.utc(2030, 1, 1),
                  focusedDay: DateTime.now(),
                  selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDate = selectedDay;
                      _dateController.text =
                          "${selectedDay.year}-${selectedDay.month}-${selectedDay.day}";
                    });
                  },
                  onFormatChanged: (format) {},
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('プラットフォーム:'),
                    PlatformListDropdownButton(),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('メーカー:'),
                    MakerListDropdownButton(),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('ジャンル:'),
                    GenreListDropdownButton(),
                  ],
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      await _uploadImageAndSaveData();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan[50],
                    ),
                    child: Text(
                      '投稿',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PlatformListDropdownButton extends StatefulWidget {
  const PlatformListDropdownButton({super.key});

  @override
  State<PlatformListDropdownButton> createState() =>
      _PlatformListDropdownButtonState();
}

class _PlatformListDropdownButtonState
    extends State<PlatformListDropdownButton> {
  String dropdownValue = platformList.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
      style: const TextStyle(color: Colors.black),
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value!;
        });
      },
      items: platformList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: SizedBox(
            width: 100,
            child: Row(
              children: [
                const Spacer(),
                Text(value),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class MakerListDropdownButton extends StatefulWidget {
  const MakerListDropdownButton({super.key});

  @override
  State<MakerListDropdownButton> createState() =>
      _MakerListDropdownButtonState();
}

class _MakerListDropdownButtonState extends State<MakerListDropdownButton> {
  String dropdownValue = makerList.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
      style: const TextStyle(color: Colors.black),
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value!;
        });
      },
      items: makerList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: SizedBox(
            width: 100,
            child: Row(
              children: [
                const Spacer(),
                Text(value),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class GenreListDropdownButton extends StatefulWidget {
  const GenreListDropdownButton({super.key});

  @override
  State<GenreListDropdownButton> createState() =>
      _GenreListDropdownButtonState();
}

class _GenreListDropdownButtonState extends State<GenreListDropdownButton> {
  String dropdownValue = genreList.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
      style: const TextStyle(color: Colors.black),
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value!;
        });
      },
      items: genreList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: SizedBox(
            width: 115,
            child: Row(
              children: [
                const Spacer(),
                Text(value),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
