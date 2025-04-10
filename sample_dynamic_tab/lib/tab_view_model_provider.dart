import 'package:flutter/material.dart';
import 'tab_view_model.dart';

class TabViewModelProvider extends InheritedNotifier<TabViewModel> {
  const TabViewModelProvider({
    Key? key,
    required TabViewModel viewModel,
    required Widget child,
  }) : super(key: key, notifier: viewModel, child: child);

  static TabViewModel of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<TabViewModelProvider>();
    if (provider == null) {
      throw Exception('TabViewModelProvider not found in context');
    }
    return provider.notifier!;
  }
}
