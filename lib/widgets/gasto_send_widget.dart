import 'package:flutter/material.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:gastos/utilities/operacion_bidon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:vibration/vibration.dart';
import '../controllers/gastos_controller.dart';
import '../models/gasto_model.dart';
import '../models/periodo_model.dart';
import '../utilities/services/dialog_services.dart';
import '../utilities/theme/theme_color.dart';
import 'mod/zo_collection_source.dart';

class GastoSendWidget extends StatefulWidget {
  final GlobalKey gastoKey;
  const GastoSendWidget({super.key, required this.gastoKey});

  @override
  State<GastoSendWidget> createState() => _GastoSendWidgetState();
}

class _GastoSendWidgetState extends State<GastoSendWidget> {
  final GlobalKey<ZoCollectionSourceState> _zoCollectionKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GastoProvider>(context);

    return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
            style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                    (provider.gastoActual.monto != null &&
                            provider.gastoActual.monto! > 0.0)
                        ? ThemaMain.green
                        : ThemaMain.darkGrey)),
            onPressed: () async {
              if (provider.gastoActual.categoriaId != null) {
                if (provider.gastoActual.monto != null &&
                    provider.gastoActual.monto! > 0.0) {
                  await Dialogs.showMorph(
                      title: "Ingresar gasto",
                      description: "¿Desea ingresar esta tarjeta de gasto?",
                      loadingTitle: "Ingresando...",
                      onAcceptPressed: (context) async {
                        await OperacionGasto.gasto(
                            gasto: provider.gastoActual,
                            metodoPago: provider.metodoSelect!.id,
                            newTime: provider.selectFecha,
                            evidencia: provider.imagenesActual,
                            notas: provider.notas.text);
                        //Limpia de variables locales
                        provider.listaGastos =
                            await GastosController.getConfigurado();

                        provider.gastoActual = GastoModelo(
                            id: null,
                            monto: null,
                            categoriaId: provider.gastoActual.categoriaId,
                            metodoPagoId: provider.gastoActual.metodoPagoId,
                            fecha: null,
                            dia: null,
                            mes: null,
                            peridico: null,
                            ultimaFecha: null,
                            periodo: PeriodoModelo(
                                year: null,
                                mes: null,
                                dia: null,
                                modificable: null),
                            gasto: null,
                            evidencia: [],
                            nota: null);
                        provider.imagenesActual = [];
                        provider.notas.text = "";
                        provider.notas.selection =
                            TextSelection.collapsed(offset: 0);
                        provider.selectFecha = null;
                      });
                  if (provider.gastoActual.monto == null) {
                    _zoCollectionKey.currentState?.simulateTap();
                  }
                } else {
                  showToast("ingrese un monto mayor a 0");
                }
              } else {
                showToast("Ingrese una categoria de gasto");
              }
            },
            icon: Stack(children: [
              ZoCollectionSource(
                  key: _zoCollectionKey,
                  destinationKey: widget.gastoKey,
                  animationDuration: (provider.gastoActual.monto ?? 0) >= 10000
                      ? Duration(seconds: 1, milliseconds: 350)
                      : (provider.gastoActual.monto ?? 0) >= 1000
                          ? Duration(seconds: 1, milliseconds: 500)
                          : (provider.gastoActual.monto ?? 0) >= 100
                              ? Durations.extralong3
                              : (provider.gastoActual.monto ?? 0) >= 10
                                  ? Durations.long4
                                  : Durations.medium3,
                  onAnimationComplete: () async {
                    setState(() {
                      provider.vibrarDia = true;
                    });

                    (provider.gastoActual.monto ?? 0) >= 10000
                        ? await Vibration.vibrate(duration: 50, amplitude: 5)
                        : (provider.gastoActual.monto ?? 0) >= 1000
                            ? await Vibration.vibrate(
                                duration: 40, amplitude: 5)
                            : (provider.gastoActual.monto ?? 0) >= 100
                                ? await Vibration.vibrate(
                                    duration: 30, amplitude: 5)
                                : (provider.gastoActual.monto ?? 0) >= 10
                                    ? await Vibration.vibrate(
                                        duration: 20, amplitude: 5)
                                    : await Vibration.vibrate(
                                        duration: 15, amplitude: 5);
                    setState(() {
                      provider.vibrarDia = false;
                    });
                  },
                  onTap: null,
                  collectionWidget: (provider.gastoActual.monto ?? 0) >= 10000
                      ? Icon(LineIcons.fileInvoiceWithUsDollar, size: 23.sp)
                      : (provider.gastoActual.monto ?? 0) >= 1000
                          ? Icon(LineIcons.wavyMoneyBill, size: 22.sp)
                          : (provider.gastoActual.monto ?? 0) >= 100
                              ? Icon(LineIcons.moneyBill, size: 20.sp)
                              : (provider.gastoActual.monto ?? 0) >= 10
                                  ? Icon(LineIcons.coins, size: 18.sp)
                                  : Icon(Icons.monetization_on, size: 16.sp),
                  count: int.tryParse(
                      provider.gastoActual.monto.toString().substring(0, 1)),
                  child:
                      Icon(LineIcons.wallet, size: 24.sp, color: Colors.white)),
              InkWell(
                  onTap: () => debugPrint("press"),
                  child: SizedBox(height: 24.sp, width: 24.sp))
            ]),
            label: Text("Guardar Gasto",
                style: TextStyle(
                    fontSize: 18.sp,
                    color: ThemaMain.white,
                    fontWeight: FontWeight.bold))));
  }
}
