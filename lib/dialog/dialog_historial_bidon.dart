import 'package:flutter/material.dart';
import 'package:gastos/controllers/bidones_controller.dart';
import 'package:gastos/models/bidones_model.dart';
import 'package:gastos/utilities/services/navigation_services.dart';
import 'package:sizer/sizer.dart';

import '../widgets/list_bidones_widget.dart';

class DialogHistorialBidon extends StatefulWidget {
  final List<BidonesModel> bidones;
  const DialogHistorialBidon({super.key, required this.bidones});

  @override
  State<DialogHistorialBidon> createState() => _DialogHistorialBidonState();
}

class _DialogHistorialBidonState extends State<DialogHistorialBidon> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      Text("Historial de bidones cerrados",
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
      Divider(),
      widget.bidones.isEmpty
          ? Padding(
              padding: EdgeInsets.all(12.sp),
              child: Text("Lista de bidones vacios",
                  style: TextStyle(fontSize: 15.sp)))
          : ListView.builder(
              shrinkWrap: true,
              itemCount: widget.bidones.length,
              itemBuilder: (context, index) {
                final bidon = widget.bidones[index];
                return ListBidonesWidget(
                    bidon: bidon,
                    delete: (p0) async {
                      await BidonesController.deleteId(p0);
                      Navigation.pop();
                    });
              })
    ]));
  }
}
