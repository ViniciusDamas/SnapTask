import 'package:flutter/material.dart';

class AppSearchController extends ChangeNotifier {
  String _query = '';

  String get query => _query;

  void setQuery(String value) {
    if (value == _query) return;
    _query = value;
    notifyListeners();
  }

  void clear() {
    if (_query.isEmpty) return;
    _query = '';
    notifyListeners();
  }
}

class AppSearchScope extends InheritedNotifier<AppSearchController> {
  const AppSearchScope({
    super.key,
    required AppSearchController controller,
    required super.child,
  }) : super(notifier: controller);

  static AppSearchController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppSearchScope>();
    assert(scope != null, 'AppSearchScope não encontrado no widget tree.');
    return scope!.notifier!;
  }
}
