import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gastos/utilities/detection_mime.dart';
import 'package:gastos/utilities/theme/theme_app.dart';
import 'package:gastos/utilities/theme/theme_color.dart';
import 'package:line_icons/line_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:path/path.dart' as pt;

class DialogGaleria extends StatefulWidget {
  const DialogGaleria({super.key});

  @override
  State<DialogGaleria> createState() => _DialogGaleriaState();
}

class _DialogGaleriaState extends State<DialogGaleria> {
  Future<List<File>> archivos() async {
    List<File> datas = [];
    final direccion = await getDownloadsDirectory();
    if (direccion != null && await direccion.exists()) {
      // Listar todos los archivos en la carpeta
      final archivos = direccion.listSync();
      for (var archivo in archivos) {
        if (archivo is File) {
          datas.add(archivo);
        }
      }
    }
    return datas;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      Text("Galeria de evidencias",
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
      FutureBuilder(
          future: archivos(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                  constraints: BoxConstraints(maxHeight: 80.h),
                  child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        File tipo = snapshot.data![index];
                        return GestureDetector(
                          onTap: () => print(tipo),
                          child: Card(
                              child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(borderRadius),
                                  child: DetectionMime.tipo(tipo) == "jpeg"
                                      ? Image.file(tipo,
                                          fit: BoxFit.cover,
                                          filterQuality: FilterQuality.low)
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                              Text(pt.basename(tipo.path),
                                                  maxLines: 2,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 14.sp)),
                                              DetectionMime.tipo(tipo) == "xlsx"
                                                  ? Icon(LineIcons.excelFileAlt,
                                                      size: 24.sp,
                                                      color: ThemaMain
                                                          .green)
                                                  : DetectionMime.tipo(tipo) ==
                                                          "zip"
                                                      ? Icon(Icons.compress,
                                                          size: 24.sp,
                                                          color:
                                                              ThemaMain
                                                                  .yellow)
                                                      : Icon(
                                                          Icons.not_interested,
                                                          size: 24.sp)
                                            ]))),
                        );
                      }));
            } else if (snapshot.hasError) {
              return Text("Error: \n${snapshot.error}");
            } else {
              return CircularProgressIndicator();
            }
          }),
    ]));
  }
}
