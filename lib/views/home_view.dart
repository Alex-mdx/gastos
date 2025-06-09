import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:gastos/utilities/services/dialog_services.dart';
import 'package:gastos/utilities/theme/theme_color.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
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
        canPop: false,
        onPopInvokedWithResult: (didPop, result) => Dialogs.showMorph(
            title: "Salir",
            description: "¿Desea salir de la app?",
            loadingTitle: "Saliendo",
            onAcceptPressed: (context) async =>
                SystemNavigator.pop(animated: true)),
        child: Scaffold(
            body: Consumer<GastoProvider>(
                builder: (context, provider, child) =>
                    Paginado(provider: provider)),
            bottomNavigationBar: BottomNavigationBar(
                showUnselectedLabels: false,
                currentIndex: navigator.index,
                unselectedItemColor: ThemaMain.darkBlue,
                selectedItemColor: ThemaMain.second,
                backgroundColor: ThemaMain.primary,
                selectedLabelStyle:
                    TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
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

class Paginado extends StatefulWidget {
  final GastoProvider provider;
  const Paginado({super.key, required this.provider});

  @override
  State<Paginado> createState() => PaginadoState();
}

class PaginadoState extends State<Paginado> {
  @override
  void initState() {
    super.initState();
    widget.provider.obtenerDato();
    InternetConnection().onStatusChange.listen((InternetStatus status) {
      switch (status) {
        case InternetStatus.connected:
          widget.provider.internet = true;
          break;
        case InternetStatus.disconnected:
          widget.provider.internet = false;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final navigator = Provider.of<NavigationProvider>(context);
    return PageView(
        controller: navigator.pageController,
        children: navigator.pages,
        onPageChanged: (index) => navigator.index = index);
  }
}

BottomNavigationBarItem _buildBottomNavigationBarItem(
    IconData icon, String label) {
  return BottomNavigationBarItem(icon: Icon(icon, size: 22.sp), label: label);
}
