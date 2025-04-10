import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'tab_model.dart';

class TabViewModel extends ChangeNotifier {
  final List<TabModel> _tabs = [];
  List<TabModel> get tabs => _tabs;

  /// 現在のタブのID
  String? _currentTabId;

  // 現在のタブのインデックスを取得（DefaultTabControllerとの連携用）
  int get currentIndex => _currentTabId != null ? _tabs.indexWhere((tab) => tab.id == _currentTabId) : 0;

  // 新しいタブを追加
  void addTab({String? title}) {
    final newTab = TabModel(
      id: const Uuid().v4(),
      title: title ?? 'タブ ${_tabs.length + 1}',
    );

    _tabs.add(newTab);
    _currentTabId = newTab.id; // 新しいタブのIDを設定
    notifyListeners();
  }

  // タブを削除
  void removeTab(String id) {
    final index = _tabs.indexWhere((tab) => tab.id == id);
    // タブが見つからない場合は何もしない
    if (index == -1) return;

    // タブを削除し、削除したタブの情報を取得
    final removedTab = _tabs.removeAt(index);

    // 削除したタブが現在選択中のタブではない場合は何もしない
    if (_currentTabId != removedTab.id) {
      notifyListeners();
      return;
    }

    // タブが残っていなければnullに設定
    if (_tabs.isEmpty) {
      _currentTabId = null;
      notifyListeners();
      return;
    }

    // 削除位置に別のタブがあれば、その位置のタブを選択
    if (index < _tabs.length) {
      _currentTabId = _tabs[index].id;
      notifyListeners();
      return;
    }

    // 削除位置が最後だった場合、新しい最後のタブを選択
    _currentTabId = _tabs.last.id;
    notifyListeners();
  }

  // タブを更新
  void updateTab(TabModel updatedTab) {
    final index = _tabs.indexWhere((tab) => tab.id == updatedTab.id);
    if (index == -1) return;

    _tabs[index] = updatedTab;
    notifyListeners();
  }

  // スワイプ時に現在のタブを変更（インデックスで）
  void setCurrentIndex(int index) {
    // インデックスが範囲外の場合は何もしない
    if (index < 0 || index >= _tabs.length) return;

    final newTabId = _tabs[index].id;
    // 既に選択中のタブの場合は何もしない
    if (_currentTabId == newTabId) return;

    _currentTabId = newTabId;
    notifyListeners();
  }
}
