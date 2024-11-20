import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Riverpodの状態管理
//フォームの状態を管理するためのStateNotifierを作成。
class PostFormState {
  final String title;
  final String releaseDate;
  final String platform;
  final String maker;
  final String genre;
  final File? selectedImage;
  final DateTime? selectedDate;

  PostFormState({
    required this.title,
    required this.releaseDate,
    required this.platform,
    required this.maker,
    required this.genre,
    this.selectedImage,
    this.selectedDate,
  });

  PostFormState copyWith({
    String? title,
    String? releaseDate,
    String? platform,
    String? maker,
    String? genre,
    File? selectedImage,
    DateTime? selectedDate,
  }) {
    return PostFormState(
      title: title ?? this.title,
      releaseDate: releaseDate ?? this.releaseDate,
      platform: platform ?? this.platform,
      maker: maker ?? this.maker,
      genre: genre ?? this.genre,
      selectedImage: selectedImage ?? this.selectedImage,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }
}

class PostFormNotifier extends StateNotifier<PostFormState> {
  PostFormNotifier()
      : super(PostFormState(
          title: '',
          releaseDate: '',
          platform: platformList.first,
          maker: makerList.first,
          genre: genreList.first,
        ));

  void updateTitle(String? title) {
    state = state.copyWith(title: title ?? ''); // title が null の場合は空文字をセット
  }

  void updateReleaseDate(String releaseDate) {
    state = state.copyWith(releaseDate: releaseDate);
  }

  void updatePlatform(String? platform) {
    state = state.copyWith(platform: platform);
  }

  void updateMaker(String? maker) {
    state = state.copyWith(maker: maker);
  }

  void updateGenre(String? genre) {
    state = state.copyWith(genre: genre);
  }

  void updateSelectedImage(File? image) {
    state = state.copyWith(selectedImage: image);
  }

  void updateSelectedDate(DateTime? date) {
    state = state.copyWith(selectedDate: date);
  }
}

final postFormProvider = StateNotifierProvider<PostFormNotifier, PostFormState>(
  (ref) => PostFormNotifier(),
);

const List<String> platformList = <String>['Switch', 'PS5', 'Steam'];

const List<String> makerList = <String>['ソニー', 'ニンテンドー', 'セガ'];

const List<String> genreList = <String>['アクション', 'RPG', 'シュミレーション'];

class PostPage extends ConsumerWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(postFormProvider);
    final postFormNotifier = ref.read(postFormProvider.notifier);

    Future<void> _pickImage() async {
      try {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);

        if (pickedFile != null) {
          postFormNotifier.updateSelectedImage(File(pickedFile.path));
        }
      } catch (e) {
        print("画像の選択に失敗しました: $e");
      }
    }

    Future<void> _uploadImageAndSaveData() async {
      if (formState.selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('画像が選択されていません'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      try {
        final storage = FirebaseStorage.instance;
        final storageRef = storage
            .ref()
            .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');
        await storageRef.putFile(formState.selectedImage!);

        final imageUrl = await storageRef.getDownloadURL();

        final firestore = FirebaseFirestore.instance;
        await firestore.collection('dataList').add({
          'name': formState.title,
          'release': formState.releaseDate,
          'platform': formState.platform,
          'maker': formState.maker,
          'genre': formState.genre,
          'imageURL': imageUrl,
        });

        Navigator.pop(context); // 投稿後に前の画面に戻る
        print("データが正常に保存されました");
      } catch (e) {
        print("画像のアップロードまたはデータ保存に失敗しました: $e");
      }
    }

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
                GestureDetector(
                  onTap: _pickImage,
                  child: SizedBox(
                    height: 300,
                    width: 300,
                    child: Card(
                        color: Colors.grey,
                        child: Center(
                            child: formState.selectedImage == null
                                ? const Text('         タップして\n画像選択してください')
                                : Image.file(
                                    formState.selectedImage!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Text('画像の読み込みに失敗しました');
                                    },
                                  ))),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller:
                            TextEditingController(text: formState.title),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'タイトル',
                        ),
                        onChanged: postFormNotifier.updateTitle,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller:
                            TextEditingController(text: formState.releaseDate),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '発売日',
                        ),
                        onChanged: postFormNotifier.updateReleaseDate,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text('タイトル:'),
                    SizedBox(width: 10),
                    Text(
                      formState.title.isNotEmpty
                          ? formState.title
                          : 'タイトルが入力されていません',
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
                      formState.releaseDate.isNotEmpty
                          ? formState.releaseDate
                          : '日付が入力されていません',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                TableCalendar(
                  firstDay: DateTime.utc(2010, 1, 1),
                  lastDay: DateTime.utc(2030, 1, 1),
                  focusedDay: DateTime.now(),
                  selectedDayPredicate: (day) =>
                      formState.selectedDate != null &&
                      isSameDay(formState.selectedDate, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    postFormNotifier.updateSelectedDate(selectedDay);
                    // 選択された日付を文字列形式にして releaseDate に保存
                    final formattedDate =
                        '${selectedDay.year}-${selectedDay.month.toString().padLeft(2, '0')}-${selectedDay.day.toString().padLeft(2, '0')}';
                    postFormNotifier.updateReleaseDate(formattedDate);
                  },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('プラットフォーム:'),
                    DropdownButton<String>(
                      value: formState.platform,
                      icon: const Icon(Icons.arrow_drop_down,
                          color: Colors.black),
                      onChanged: postFormNotifier.updatePlatform,
                      items: platformList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('メーカー:'),
                    DropdownButton<String>(
                      value: formState.maker,
                      icon: const Icon(Icons.arrow_drop_down,
                          color: Colors.black),
                      onChanged: postFormNotifier.updateMaker,
                      items: makerList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('ジャンル:'),
                    DropdownButton<String>(
                      value: formState.genre,
                      icon: const Icon(Icons.arrow_drop_down,
                          color: Colors.black),
                      onChanged: postFormNotifier.updateGenre,
                      items: genreList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _uploadImageAndSaveData,
                  child: const Text('投稿'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
