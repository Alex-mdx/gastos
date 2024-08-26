import 'package:flutter/material.dart';
import 'package:gastos/widgets/grafico_view.dart';

import '../views/gastos_view.dart';
import '../views/historial_view.dart';

class NavigationProvider extends ChangeNotifier {
  NavigationProvider() : _pageControlller = PageController(initialPage: 1);
  late final PageController _pageControlller;
  int _index = 1;
  int get index => _index;
  set index(int index) {
    _index = index;
    notifyListeners();
  }

  Future<void> animateToPage(int index) async {
    _index = index;
    await _pageControlller.animateToPage(index,
        duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    notifyListeners();
  }

  Future<void> jumpToPage(int index) async {
    _index = index;
    _pageControlller.jumpToPage(index);
    notifyListeners();
  }

  final List<Widget> _pages = [
    const HistorialView(),
    const GastosView(),
    const GraficoView()
  ];
  List<Widget> get pages => _pages;

  PageController get pageController => _pageControlller;
}
