import 'package:flutter/material.dart';
import 'package:gastos/utilities/theme/theme_color.dart';
import 'package:gastos/widgets/addMobile/banner.dart';
import 'package:rive_animated_icon/rive_animated_icon.dart';
import 'package:sizer/sizer.dart';

class GraficosView extends StatelessWidget {
  const GraficosView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: Text("Graficos", style: TextStyle(fontSize: 20.sp))),
        body: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              BannerExample(tipo: 1),
              RiveAnimatedIcon(
                  riveIcon: RiveIcon.warning,
                  color: LightThemeColors.yellow,
                  loopAnimation: true,
                  height: 40.w,
                  width: 40.w),
              Text("Pagina en contruccion ඞ",
                  style: TextStyle(fontSize: 16.sp)),
              BannerExample(tipo: 1)
            ])));
  }
}
