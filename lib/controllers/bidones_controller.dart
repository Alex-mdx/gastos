import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:gastos/models/bidones_model.dart';
import 'package:gastos/utilities/fecha_parser.dart';
import 'package:sqflite/sqflite.dart' as sql;

String nombreDB = "bidones";

class CategoriaController {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE $nombreDB(
        id INTEGER,
        identificador INTEGER,
        nombre TEXT,
        monto_inicial INTEGER,
        monto_final INTEGER,
        metodo_pago INTEGER,
        categoria INTEGER,
        fecha_inicio INTEGER,
        fecha_final INTEGER,
        cerrado INTEGER,
        inhabilitado INTEGER
      )""");
  }

  static Future<sql.Database> database() async {
    return sql.openDatabase('app_$nombreDB.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  static Future<void> insert(BidonesModel cate) async {
    final db = await database();
    await db.insert(nombreDB, cate.toJson(),
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<void> update(BidonesModel cate) async {
    final db = await database();
    await db.update(nombreDB, cate.toJson(),
        where: "identificador = ?",
        whereArgs: [cate.identificador],
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<void> cerrar(BidonesModel cate) async {
    final db = await database();
    var cerrar = cate.copyWith(cerrado: 1);
    await db.update(nombreDB, cerrar.toJson(),
        where: "id = ? AND identificador = ?",
        whereArgs: [cerrar.id, cerrar.identificador],
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<int?> getLastId() async {
    final db = await database();
    final data =
        (await db.query(nombreDB, limit: 1, orderBy: 'id DESC')).firstOrNull;
    BidonesModel? modelo = data == null ? null : BidonesModel.fromJson(data);

    return modelo?.id;
  }

  static Future<List<BidonesModel>> getItemsByCerrado() async {
    final db = await database();
    List<BidonesModel> categoriaModelo = [];
    List<Map<String, dynamic>> categoria =
        await db.query(nombreDB, where: "cerrado = 0", orderBy: "nombre");
    for (var element in categoria) {
      categoriaModelo.add(BidonesModel.fromJson(element));
    }
    return categoriaModelo;
  }

  static Future<List<BidonesModel>> buscar(String word) async {
    final db = await database();
    List<BidonesModel> categoriaModelo = [];
    List<Map<String, dynamic>> categoria = await db.query(nombreDB,
        where: "nombre LIKE ?",
        whereArgs: ['%$word%'],
        orderBy: "nombre",
        limit: 10);
    for (var element in categoria) {
      categoriaModelo.add(BidonesModel.fromJson(element));
    }
    return categoriaModelo;
  }

  static Future<void> deleteItem(int identificador) async {
    final db = await database();
    await db.delete(nombreDB,
        where: 'identificador = ?', whereArgs: [identificador]);
  }

  static Future<void> deleteAll() async {
    final db = await database();
    await db.delete(nombreDB);
  }

  static Future<void> vigencias({required int identificador}) async {
    final db = await database();
    final datas = (await db.query(nombreDB,
            where: "identificador = ? AND  cerrado = 0 AND ",
            whereArgs: [identificador],
            orderBy: "id DESC",
            limit: 1))
        .firstOrNull;
    if (datas != null) {
      BidonesModel bidon = BidonesModel.fromJson(datas);
      var ahora = FechaParser.convertirFecha(fecha: DateTime.now());
      //obtengo la diferencia de dias entre la fecha final y la fecha inicial
      var days = bidon.fechaFinal.difference(bidon.fechaInicio).inDays;
      log("Limite: $bidon.fechaFinal - Ahora: $ahora");
      //comparo el dia de hoy si es despues de la fecha final
      if (DateTime.parse(ahora).isAfter(bidon.fechaFinal)) {
        debugPrint("cerrando...");
        await cerrar(bidon);
        final id = await getLastId();
        BidonesModel aperturar = bidon.copyWith(
            id: id,
            montoFinal: bidon.montoInicial,
            fechaInicio: bidon.fechaFinal, //meto la fecha final como inicial
            fechaFinal: bidon.fechaFinal.add(Duration(days: days))

            ///meto la fecha final mas "days" para obtener su patron de dias
            );

        await insert(aperturar);
        await vigencias(identificador: identificador); //vuelvo a verificar
      } else {
        debugPrint("El bidon ${bidon.nombre} aun esta vigente");
      }
    }
  }
}
