import 'dart:io';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'post_form.freezed.dart';

@freezed
class PostFormState with _$PostFormState {
  const factory PostFormState({
    required String title,
    required String releaseDate,
    required String platform,
    required String genre,
    File? selectedImage,
    DateTime? selectedDate,
    @Default(false) bool isLoading,
  }) = _PostFormState;

  // 初期状態を定義
  factory PostFormState.initial() => PostFormState(
        title: '',
        releaseDate: '',
        platform: platformList.first,
        genre: genreList.first,
      );
}

const List<String> platformList = <String>['Switch', 'PS5', 'Steam', 'その他'];
const List<String> genreList = <String>['アクション', 'RPG', 'シュミレーション', 'その他'];
