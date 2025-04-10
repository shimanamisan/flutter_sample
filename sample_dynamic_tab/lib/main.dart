import 'package:flutter/material.dart';
import 'package:sample_dynamic_tab/tab_model.dart';
import 'tab_view_model.dart';
import 'tab_view_model_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '動的タブアプリ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TabScreen(),
    );
  }
}

class TabScreen extends StatefulWidget {
  const TabScreen({Key? key}) : super(key: key);

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  final TabViewModel _viewModel = TabViewModel();

  @override
  void initState() {
    super.initState();
    // 初期タブを追加
    _viewModel.addTab(title: 'ホーム');
  }

  @override
  Widget build(BuildContext context) {
    return TabViewModelProvider(
      viewModel: _viewModel,
      child: Builder(
        builder: (context) {
          final viewModel = TabViewModelProvider.of(context);

          return DefaultTabController(
            length: viewModel.tabs.length,
            initialIndex: viewModel.currentIndex,
            animationDuration: const Duration(milliseconds: 300),
            child: Builder(
              builder: (context) {
                // DefaultTabControllerの変更を監視
                final tabController = DefaultTabController.of(context);
                tabController.addListener(() {
                  // タブが切り替わったら、ViewModelを更新
                  if (tabController.indexIsChanging == false && tabController.index != viewModel.currentIndex) {
                    viewModel.setCurrentIndex(tabController.index);
                  }
                });

                return Scaffold(
                  appBar: AppBar(
                    title: const Text('動的タブアプリ'),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => _showAddTabDialog(context),
                      ),
                    ],
                    bottom: TabBar(
                      // タブを左寄せに配置する
                      tabAlignment: TabAlignment.start,
                      // タブをスクロール可能にする
                      isScrollable: true,
                      tabs: viewModel.tabs.map((tab) {
                        return Tab(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(tab.title),
                              const SizedBox(width: 8),
                              InkWell(
                                onTap: () {
                                  viewModel.removeTab(tab.id);
                                },
                                child: const Icon(
                                  Icons.close,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  body: TabBarView(
                    children: viewModel.tabs.map((tab) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tab.title,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => _showEditTabDialog(context, tab),
                              child: const Text('このタブを編集'),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showAddTabDialog(BuildContext context) {
    final titleController = TextEditingController();
    final viewModel = TabViewModelProvider.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('新しいタブを追加'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'タイトル'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () {
                final previousLength = viewModel.tabs.length;
                viewModel.addTab(
                  title: titleController.text.isNotEmpty ? titleController.text : 'New Tab',
                );
                Navigator.pop(context);

                // 追加されたタブに切り替える
                if (viewModel.tabs.length > previousLength) {
                  // ビルド後にタブコントローラーを更新
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    final tabController = DefaultTabController.of(context);
                    tabController.animateTo(viewModel.tabs.length - 1);
                  });
                }
              },
              child: const Text('追加'),
            ),
          ],
        );
      },
    );
  }

  void _showEditTabDialog(BuildContext context, TabModel tab) {
    final titleController = TextEditingController(text: tab.title);
    final viewModel = TabViewModelProvider.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('タブを編集'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'タイトル'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () {
                viewModel.updateTab(
                  tab.copyWith(
                    title: titleController.text,
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text('保存'),
            ),
          ],
        );
      },
    );
  }
}
