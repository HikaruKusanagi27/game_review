import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gamereview_app/post_form.dart';
import 'package:image_picker/image_picker.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostFormNotifier extends StateNotifier<PostFormState> {
  PostFormNotifier() : super(PostFormState.initial());

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void deleteTitle(String? title) {
    state = state.copyWith(title: title ?? '');
  }

  void deleteReleaseDate(String? releaseDate) {
    state = state.copyWith(releaseDate: releaseDate ?? '');
  }

  void updateReleaseDate(String releaseDate) {
    state = state.copyWith(releaseDate: releaseDate);
  }

  void updatePlatform(String? platform) {
    state = state.copyWith(platform: platform ?? '');
  }

  void updateGenre(String? genre) {
    state = state.copyWith(genre: genre ?? '');
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

const List<String> platformList = <String>['Switch', 'PS5', 'Steam', 'その他'];

const List<String> genreList = <String>['アクション', 'RPG', 'シュミレーション', 'その他'];

class PostPage extends ConsumerWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(postFormProvider);
    final postFormNotifier = ref.read(postFormProvider.notifier);

    Future<void> pickImage() async {
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

    Future<void> uploadImageAndSaveData() async {
      if (formState.selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('画像が選択されていません'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      postFormNotifier.setLoading(true);
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
          'genre': formState.genre,
          'imageURL': imageUrl,
        });

        Navigator.pop(context); // 投稿後に前の画面に戻る
        print("データが正常に保存されました");
      } catch (e) {
        print("画像のアップロードまたはデータ保存に失敗しました: $e");
      } finally {
        postFormNotifier.setLoading(false);
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan[50],
      ),
      body: Stack(children: [
        Container(
          color: Colors.cyan[400],
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: pickImage,
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
                                      errorBuilder:
                                          (context, error, stackTrace) {
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
                            border: const OutlineInputBorder(),
                            labelText: 'タイトル',
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                postFormNotifier.deleteTitle('');
                              },
                            ),
                          ),
                          onChanged: postFormNotifier.deleteTitle,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: TextEditingController(
                              text: formState.releaseDate),
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: '発売日',
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                postFormNotifier.deleteReleaseDate('');
                              },
                            ),
                          ),
                          onChanged: postFormNotifier.deleteReleaseDate,
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
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
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
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
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
                      const Text('プラットフォーム:'),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('ジャンル:'),
                      DropdownButton<String>(
                        value: formState.genre,
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.black),
                        onChanged: postFormNotifier.updateGenre,
                        items: genreList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: SizedBox(
                                width: 150,
                                child: Text(value, textAlign: TextAlign.right)),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: uploadImageAndSaveData,
                    child: const Text('投稿'),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (formState.isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ]),
    );
  }
}
