import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamereview_app/home.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // App Check の設定
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
  );

  // ProviderScopeを追加してアプリ全体でRiverpodを使用可能にする
  runApp(
    const ProviderScope(
      // ProviderScopeでラップ
      child: MaterialApp(
        home: MainApp(), // MainAppウィジェットをホームに設定
      ),
    ),
  );
}
