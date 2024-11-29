import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:gastos/controllers/presupuesto_controller.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:gastos/utilities/generate_excel.dart';
import 'package:gastos/utilities/preferences.dart';
import 'package:gastos/widgets/addMobile/banner.dart';
import 'package:gastos/widgets/setting_presupuesto_widget.dart';
import 'package:gastos/widgets/setting_primer_dia_widget.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../widgets/setting_calidad_imagen.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  List<String> rangos = ["Mensual", "Trimestral", "Semestral", "Anual"];
  SingleSelectController<String> controller =
      SingleSelectController(Preferences.calculo);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GastoProvider>(context);
    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) async {
          if (provider.presupuesto?.activo == 1) {
            print("actualizo");
            await PresupuestoController.insert(provider.presupuesto!);
          }
          provider.presupuesto = await PresupuestoController.getItem();
        },
        child: Scaffold(
            appBar: AppBar(title: const Text("Opciones")),
            body: SizedBox(
                height: 80.h,
                child: SafeArea(
                    child: SingleChildScrollView(
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(children: [
                              OverflowBar(
                                alignment: MainAxisAlignment.spaceAround,
                                overflowAlignment: OverflowBarAlignment.center,
                                children: [
                                  ElevatedButton.icon(
                                      onPressed: () {
                                        GenerateExcel.backUp(provider);
                                      },
                                      label: Text("Compartir datos",
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold)),
                                      icon: Icon(LineIcons.fileUpload,
                                          size: 20.sp)),
                                  ElevatedButton.icon(
                                      onPressed: () {
                                        GenerateExcel.backUp(provider);
                                      },
                                      label: Text("Importar datos",
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold)),
                                      icon: Icon(LineIcons.fileImport,
                                          size: 20.sp))
                                ],
                              ),
                              BannerExample(tipo: 0),
                              const SettingCalidadImagen(),
                              const Divider(),
                              const SettingPrimerDiaWidget(),
                              const Divider(),
                              /* Text("Rango de fecha maximo de calculo",
                              style: TextStyle(
                                  fontSize: 18.sp, fontWeight: FontWeight.bold)),
                          CustomDropdown(
                              controller: controller,
                              decoration: CustomDropdownDecoration(
                                  prefixIcon: Icon(LineIcons.calendarPlusAlt,
                                      color: LightThemeColors.green, size: 22.sp),
                                  closedSuffixIcon: controller.value != null
                                      ? IconButton(
                                          iconSize: 22.sp,
                                          onPressed: () => setState(() {
                                                controller.clear();
                                              }),
                                          icon: Icon(Icons.close_rounded,
                                              size: 20.sp))
                                      : null),
                              headerBuilder: (context, selectedItem, enabled) =>
                                  Text(selectedItem,
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.bold)),
                              hintText: 'Seleccione rango de calculo de gasto',
                              items: rangos,
                              listItemBuilder:
                                  (context, item, isSelected, onItemSelect) => Text(
                                      item,
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold)),
                              overlayHeight: 40.h,
                              onChanged: (value) {
                                if (value != null) {
                                  print("$value");
                                }
                  
                                log('changing value to: $value');
                              }), */

                              SettingPresupuestoWidget(provider: provider),
                              BannerExample(tipo: 0)
                            ]))))),
            floatingActionButton: BannerExample(tipo: 1)));
  }
}
