import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../utilities/navegacion_provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    final navigator = Provider.of<NavigationProvider>(context);
    return PopScope(
        canPop: true,
        child: Scaffold(
            body: PageView(
                controller: navigator.pageController,
                children: navigator.pages,
                onPageChanged: (index) => navigator.index = index),
            bottomNavigationBar: BottomNavigationBar(
                showUnselectedLabels: false,
                currentIndex: navigator.index,
                onTap: (index) async {
                  navigator.index = index;
                  await navigator.animateToPage(index);
                },
                items: [
                  _buildBottomNavigationBarItem(
                      Icons.request_quote, 'Historial'),
                  _buildBottomNavigationBarItem(Icons.payments, 'Gastos'),
                  _buildBottomNavigationBarItem(Icons.auto_graph, 'Graficos')
                ])));
  }
}

BottomNavigationBarItem _buildBottomNavigationBarItem(
    IconData icon, String label) {
  return BottomNavigationBarItem(icon: Icon(icon, size: 8.w), label: label);
}