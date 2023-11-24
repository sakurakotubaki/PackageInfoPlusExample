import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PackageInfoPlus Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0x9f4376f8),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends HookWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // useMemoizedでキャッシュすると、再描画時にキャッシュした値を返す
    final memo = useMemoized(() => _getAppVersion(), []);
    // useFutureで非同期処理を実行する
    final snapshot = useFuture(memo);
    return Scaffold(
      appBar: AppBar(
        title: const Text('PackageInfoPlus Demo Hooks'),
      ),
      // FutureBuilderと同じようにsnapshotを使う
      body: snapshot.connectionState == ConnectionState.done
          ? Center(
              child: Text(
                'アプリのバージョン: ${snapshot.data.toString()}',
                style: const TextStyle(fontSize: 24),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Future<String> _getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
}
