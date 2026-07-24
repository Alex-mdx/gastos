import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../models/metodo_pago_model.dart';
import '../../utilities/theme/theme_color.dart';

class MultiselectGeneric extends StatefulWidget {
  const MultiselectGeneric({super.key, required this.provider});
  final GastoProvider provider;
  @override
  State<MultiselectGeneric> createState() => _MultiselectGenericState();
}

class _MultiselectGenericState extends State<MultiselectGeneric> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GastoProvider>(context);
    return provider.metodoSelect == null
        ? Center(child: CircularProgressIndicator(color: ThemaMain.primary))
        : AnimatedToggleSwitch<MetodoPagoModel>.rolling(
            current: widget.provider.metodoSelect!,
            allowUnlistedValues: true,
            values: widget.provider.metodo,
            height: 7.h,
            onChanged: (i) => setState(() => widget.provider.metodoSelect = i),
            iconBuilder: (value, foreground) => Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AutoSizeText(value.nombre,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight:
                                  value.id == widget.provider.metodoSelect?.id
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                              overflow: TextOverflow.ellipsis),
                          minFontSize: 9,
                          maxLines: 1),
                      Icon(value.icon ?? Icons.payment,
                          color: value.id == widget.provider.metodoSelect?.id
                              ? ThemaMain.green
                              : ThemaMain.primary,
                          size: 20.sp)
                    ]),
            iconOpacity: 0.2,
            indicatorSize: Size.fromWidth(14.w),
            borderWidth: 4.0,
            styleAnimationType: AnimationType.onHover,
            styleBuilder: (i) => ToggleStyle(indicatorColor: i.color),
            style: ToggleStyle(
                borderColor: Colors.transparent,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 1.5))
                ]));
  }
}
