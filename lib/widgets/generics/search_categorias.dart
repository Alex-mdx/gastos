import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sizer/sizer.dart';

import '../../controllers/categoria_controller.dart';
import '../../models/categoria_model.dart';
import '../../utilities/services/dialog_services.dart';
import '../../utilities/theme/theme_color.dart';

class SearchCategorias extends StatefulWidget {
  final SingleSelectController<CategoriaModel> controller;
  final List<CategoriaModel> list;
  final Function(CategoriaModel) fun;
  final Function(List<CategoriaModel>)? delete;

  const SearchCategorias(
      {super.key,
      required this.controller,
      required this.list,
      required this.fun,
      this.delete});

  @override
  State<SearchCategorias> createState() => _SearchCategoriasState();
}

class _SearchCategoriasState extends State<SearchCategorias> {
  @override
  Widget build(BuildContext context) {
    return CustomDropdown.searchRequest(
        futureRequest: (p0) async => await CategoriaController.buscar(p0),
        searchHintText: "Nombre categoria de gasto",
        noResultFoundText: "Sin resultados",
        controller: widget.controller,
        closedHeaderPadding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0),
        decoration: CustomDropdownDecoration(
            expandedFillColor: ThemaMain.background,
            closedFillColor: ThemaMain.background,
            prefixIcon: Icon(LineIcons.wavyMoneyBill,
                color: ThemaMain.green, size: 22.sp),
            searchFieldDecoration:
                SearchFieldDecoration(fillColor: ThemaMain.dialogbackground),
            closedSuffixIcon: widget.controller.value != null
                ? IconButton(
                    iconSize: 20.sp,
                    onPressed: () => setState(() {
                          widget.controller.clear();
                        }),
                    icon: Icon(Icons.close_rounded,
                        color: ThemaMain.red, size: 20.sp))
                : Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    child: Icon(Icons.keyboard_double_arrow_down,
                        color: ThemaMain.primary, size: 20.sp))),
        headerBuilder: (context, selectedItem, enabled) => Text(
            selectedItem.nombre,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: ThemaMain.darkGrey,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold)),
        hintText: 'Categoria de Gasto',
        items: widget.list,
        itemsListPadding: EdgeInsets.all(0),
        listItemPadding:
            EdgeInsets.only(top: 1.h, bottom: 0, left: 0, right: 0),
        hideSelectedFieldWhenExpanded: true,
        excludeSelected: true,
        listItemBuilder: (context, item, isSelected, onItemSelect) => ListTile(
            dense: isSelected,
            tileColor: isSelected
                ? ThemaMain.primary.withAlpha(125)
                : ThemaMain.second,
            contentPadding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0),
            title: Text("${item.nombre} |- ${item.descripcion}",
                maxLines: isSelected ? 1 : 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: ThemaMain.darkBlue,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold)),
            trailing: widget.delete != null ?  IconButton(
                onPressed: () => Dialogs.showMorph(
                    title: "Eliminar",
                    description:
                        "¿Desea eliminar la categoria de gasto '${item.nombre}'? una vez eliminado aquellos gastos con esa categoria la perderan",
                    loadingTitle: "Eliminando",
                    onAcceptPressed: (context) async {
                      await CategoriaController.deleteItem(item.id!);
                      final data = await CategoriaController.getItems();
                      setState(() {
                        widget.controller.clear();
                        widget.delete!(data);
                      });
                    }),
                icon: Icon(Icons.delete, size: 16.sp, color: ThemaMain.red)) : null),
        overlayHeight: 35.h,
        autofocusOnSearch: true,
        selectOnItemTap: true,
        onChanged: (p0) {
          log("$p0");
          if (p0 != null) {
            widget.controller.select(p0);
            widget.fun(p0);
          }
        });
  }
}
