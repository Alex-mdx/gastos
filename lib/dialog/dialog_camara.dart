import 'package:flutter/material.dart';
import 'package:gastos/utilities/gasto_provider.dart';
import 'package:gastos/utilities/preferences.dart';
import 'package:gastos/utilities/services/navigation_services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class DialogCamara extends StatefulWidget {
  const DialogCamara({super.key});

  @override
  State<DialogCamara> createState() => _DialogCamaraState();
}

class _DialogCamaraState extends State<DialogCamara> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GastoProvider>(context);
    return Dialog(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text('Ingresar destino de evidencia',
                  style: TextStyle(fontSize: 16.sp)),
              ElevatedButton.icon(
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? photo = await picker.pickImage(
                        maxHeight: 1280,
                        maxWidth: 720,
                        imageQuality: Preferences.calidadFoto.toInt(),
                        source: ImageSource.camera,
                        requestFullMetadata: false);
                    if (photo != null) {
                      final data = await photo.readAsBytes();
                      setState(() {
                        provider.imagenesActual.add(data);
                      });
                      Navigation.pop();
                    }
                    final modelTemp = provider.gastoActual
                        .copyWith(evidencia: provider.imagenesActual);
                    provider.gastoActual = modelTemp;
                  },
                  label: Text('Camara', style: TextStyle(fontSize: 16.sp)),
                  icon: Icon(Icons.camera_alt, size: 20.sp)),
              ElevatedButton.icon(
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final List<XFile> images = await picker.pickMultiImage(
                        imageQuality: Preferences.calidadFoto.toInt(),
                        maxHeight: 1280,
                        maxWidth: 720,
                        limit: 10,
                        requestFullMetadata: false);
                    if (images.isNotEmpty) {
                      for (var element in images) {
                        final data = (await element.readAsBytes());
                        provider.imagenesActual.add(data);
                      }
                      Navigation.pop();
                    }
                    final modelTemp = provider.gastoActual
                        .copyWith(evidencia: provider.imagenesActual);
                    provider.gastoActual = modelTemp;
                  },
                  label: Text('Galeria', style: TextStyle(fontSize: 16.sp)),
                  icon: Icon(Icons.image_search, size: 20.sp))
            ])));
  }
}
