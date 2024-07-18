import 'package:gastos/utilities/gasto_provider.dart';
import 'package:gastos/widgets/historial_semanal_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'card_gasto_widget.dart';

class GastosView extends StatelessWidget {
  const GastosView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GastoProvider>(context);
    return Scaffold(
        appBar: AppBar(title: const Text('Gastos')),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
                child: Column(children: [
              HistorialSemanalWidget(provider: provider),
              const Divider(),
              const Center(child: CardGastoWidget())
            ]))),
        floatingActionButton: FloatingActionButton(
            onPressed: () {}, child: const Icon(Icons.savings_rounded)),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
