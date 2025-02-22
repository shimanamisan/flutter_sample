import 'package:flutter/material.dart';

/// アプリケーションのエントリーポイント
void main() {
  runApp(const MyApp());
}

/// アプリケーションのルートウィジェット
///
/// アプリケーションの全体的なテーマや設定を定義します。
class MyApp extends StatelessWidget {
  final Color appBaseColor = const Color(0xFF1D5C96);
  final Color appBaseTitle = const Color(0xFFFFFFFF);
  final Color baseBackgroundColor = const Color(0xFFFFFFFF);

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ThemeData Demo',
      theme: ThemeData(
        useMaterial3: true,

        // AppBarの背景色とテキストの色、サイズなど
        appBarTheme: AppBarTheme(
          backgroundColor: appBaseColor,
          foregroundColor: appBaseTitle,
          titleTextStyle: TextStyle(
            color: appBaseTitle,
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),

        // 背景を白色
        scaffoldBackgroundColor: baseBackgroundColor,

        // ダイアログ
        dialogTheme: DialogTheme(
          // ダイアログボックス全体の背景色を指定
          backgroundColor: baseBackgroundColor,
          // ダイアログの形状を定義
          shape: RoundedRectangleBorder(
            // 角の丸みを無くす
            borderRadius: BorderRadius.circular(0.0),
          ),
        ),

        // テキストボタン
        textButtonTheme: TextButtonThemeData(
          // デフォルトの色を指定
          style: TextButton.styleFrom(foregroundColor: Colors.black),
        ),

        // floatingActionButton
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: appBaseColor,
          foregroundColor: baseBackgroundColor,
          shape: const CircleBorder(),
        ),

        // ボタンのテーマ
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: appBaseColor,
            foregroundColor: Colors.white,
          ),
        ),

        // カーソル関連の設定
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: appBaseColor, // カーソルの色
          selectionColor: appBaseColor.withOpacity(0.3), // テキスト選択時の背景色
          selectionHandleColor: appBaseColor, // 選択ハンドルの色
        ),

        // TextFieldなどでonFocusの時の枠線のstyle
        inputDecorationTheme: InputDecorationTheme(
          // 通常時の下線
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 1.0,
            ),
          ),
          // フォーカス時の下線
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: appBaseColor,
              width: 2.0,
            ),
          ),

          // // エラー時の下線
          // errorBorder: const UnderlineInputBorder(
          //   borderSide: BorderSide(
          //     color: Colors.red,
          //     width: 1.0,
          //   ),
          // ),
          // フォーカス時のラベルの色
          floatingLabelStyle: TextStyle(color: appBaseColor),
        ),
      ),
      home: const MyHomePage(title: 'ThemeData Demo Home Page'),
    );
  }
}

/// ホーム画面のウィジェット
///
/// テキスト入力ダイアログを表示し、入力されたテキストを画面に表示する
/// StatefulWidgetです。
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  /// アプリバーに表示されるタイトル
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

/// MyHomePageの状態を管理するStateクラス
class _MyHomePageState extends State<MyHomePage> {
  /// 画面に表示されるテキスト
  ///
  /// ダイアログで入力されたテキストがここに保存される
  String _inputText = "最初の文字です。";

  /// テキスト入力フィールドのコントローラー
  final TextEditingController _textController = TextEditingController();

  /// テキスト入力ダイアログを表示するメソッド
  ///
  /// OKボタンが押された場合、入力されたテキストが画面に反映される
  void _showTextFieldDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('確認'),
        content: TextField(
          controller: _textController,
          decoration: const InputDecoration(
            labelText: 'メモを入力してください',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // キャンセルボタン：false を返す
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true), // OKボタン：true を返す
            child: const Text('OK'),
          )
        ],
      ),
    );

    // nullチェックと非同期処理時のcontext.mountedのチェック
    if ((result ?? false) && context.mounted) {
      setState(() {
        _inputText = _textController.text;
        _textController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _inputText,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showTextFieldDialog,
        tooltip: 'showTextFieldDialog',
        child: const Icon(Icons.add),
      ),
    );
  }
}
