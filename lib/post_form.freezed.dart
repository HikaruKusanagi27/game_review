// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_form.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PostFormState {
  String get title => throw _privateConstructorUsedError;
  String get releaseDate => throw _privateConstructorUsedError;
  String get platform => throw _privateConstructorUsedError;
  String get genre => throw _privateConstructorUsedError;
  File? get selectedImage => throw _privateConstructorUsedError;
  DateTime? get selectedDate => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;

  /// Create a copy of PostFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostFormStateCopyWith<PostFormState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostFormStateCopyWith<$Res> {
  factory $PostFormStateCopyWith(
          PostFormState value, $Res Function(PostFormState) then) =
      _$PostFormStateCopyWithImpl<$Res, PostFormState>;
  @useResult
  $Res call(
      {String title,
      String releaseDate,
      String platform,
      String genre,
      File? selectedImage,
      DateTime? selectedDate,
      bool isLoading});
}

/// @nodoc
class _$PostFormStateCopyWithImpl<$Res, $Val extends PostFormState>
    implements $PostFormStateCopyWith<$Res> {
  _$PostFormStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PostFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? releaseDate = null,
    Object? platform = null,
    Object? genre = null,
    Object? selectedImage = freezed,
    Object? selectedDate = freezed,
    Object? isLoading = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      releaseDate: null == releaseDate
          ? _value.releaseDate
          : releaseDate // ignore: cast_nullable_to_non_nullable
              as String,
      platform: null == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as String,
      genre: null == genre
          ? _value.genre
          : genre // ignore: cast_nullable_to_non_nullable
              as String,
      selectedImage: freezed == selectedImage
          ? _value.selectedImage
          : selectedImage // ignore: cast_nullable_to_non_nullable
              as File?,
      selectedDate: freezed == selectedDate
          ? _value.selectedDate
          : selectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PostFormStateImplCopyWith<$Res>
    implements $PostFormStateCopyWith<$Res> {
  factory _$$PostFormStateImplCopyWith(
          _$PostFormStateImpl value, $Res Function(_$PostFormStateImpl) then) =
      __$$PostFormStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      String releaseDate,
      String platform,
      String genre,
      File? selectedImage,
      DateTime? selectedDate,
      bool isLoading});
}

/// @nodoc
class __$$PostFormStateImplCopyWithImpl<$Res>
    extends _$PostFormStateCopyWithImpl<$Res, _$PostFormStateImpl>
    implements _$$PostFormStateImplCopyWith<$Res> {
  __$$PostFormStateImplCopyWithImpl(
      _$PostFormStateImpl _value, $Res Function(_$PostFormStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of PostFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? releaseDate = null,
    Object? platform = null,
    Object? genre = null,
    Object? selectedImage = freezed,
    Object? selectedDate = freezed,
    Object? isLoading = null,
  }) {
    return _then(_$PostFormStateImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      releaseDate: null == releaseDate
          ? _value.releaseDate
          : releaseDate // ignore: cast_nullable_to_non_nullable
              as String,
      platform: null == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as String,
      genre: null == genre
          ? _value.genre
          : genre // ignore: cast_nullable_to_non_nullable
              as String,
      selectedImage: freezed == selectedImage
          ? _value.selectedImage
          : selectedImage // ignore: cast_nullable_to_non_nullable
              as File?,
      selectedDate: freezed == selectedDate
          ? _value.selectedDate
          : selectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$PostFormStateImpl implements _PostFormState {
  const _$PostFormStateImpl(
      {required this.title,
      required this.releaseDate,
      required this.platform,
      required this.genre,
      this.selectedImage,
      this.selectedDate,
      this.isLoading = false});

  @override
  final String title;
  @override
  final String releaseDate;
  @override
  final String platform;
  @override
  final String genre;
  @override
  final File? selectedImage;
  @override
  final DateTime? selectedDate;
  @override
  @JsonKey()
  final bool isLoading;

  @override
  String toString() {
    return 'PostFormState(title: $title, releaseDate: $releaseDate, platform: $platform, genre: $genre, selectedImage: $selectedImage, selectedDate: $selectedDate, isLoading: $isLoading)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostFormStateImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.releaseDate, releaseDate) ||
                other.releaseDate == releaseDate) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.genre, genre) || other.genre == genre) &&
            (identical(other.selectedImage, selectedImage) ||
                other.selectedImage == selectedImage) &&
            (identical(other.selectedDate, selectedDate) ||
                other.selectedDate == selectedDate) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading));
  }

  @override
  int get hashCode => Object.hash(runtimeType, title, releaseDate, platform,
      genre, selectedImage, selectedDate, isLoading);

  /// Create a copy of PostFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostFormStateImplCopyWith<_$PostFormStateImpl> get copyWith =>
      __$$PostFormStateImplCopyWithImpl<_$PostFormStateImpl>(this, _$identity);
}

abstract class _PostFormState implements PostFormState {
  const factory _PostFormState(
      {required final String title,
      required final String releaseDate,
      required final String platform,
      required final String genre,
      final File? selectedImage,
      final DateTime? selectedDate,
      final bool isLoading}) = _$PostFormStateImpl;

  @override
  String get title;
  @override
  String get releaseDate;
  @override
  String get platform;
  @override
  String get genre;
  @override
  File? get selectedImage;
  @override
  DateTime? get selectedDate;
  @override
  bool get isLoading;

  /// Create a copy of PostFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostFormStateImplCopyWith<_$PostFormStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
