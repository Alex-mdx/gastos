import 'dart:developer';

import 'package:gastos/models/presupuesto_model.dart';
import 'package:sqflite/sqflite.dart' as sql;

String nombreDB = "presupuesto";

class PresupuestoController {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE $nombreDB(
      activo INTEGER,
      presupuesto INTEGER,
      lunes INTEGER,
      martes INTEGER,
      miercoles INTEGER,
      jueves INTEGER,
      viernes INTEGER,
      sabado INTEGER,
      domingo INTEGER,
      periodo TEXT
      )""");
  }

  static Future<sql.Database> database() async {
    return sql.openDatabase('app_$nombreDB.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  static Future<void> insert(PresupuestoModel gasto) async {
    final db = await database();
    var data = await getItem();
    if (data == null) {
      log("Nuevo");
      await db.insert(nombreDB, gasto.toJson(),
          conflictAlgorithm: sql.ConflictAlgorithm.replace);
    } else {
      log("update");
      await updateItem(gasto);
    }
  }

  static Future<PresupuestoModel?> getItem() async {
    final db = await database();
    final data = (await db.query(nombreDB)).firstOrNull;
    PresupuestoModel? modelo =
        data == null ? null : PresupuestoModel.fromJson(data);
    return modelo;
  }

  static Future<void> updateItem(PresupuestoModel gasto) async {
    final db = await database();
    await db.update(nombreDB, gasto.toJson());
  }

  static Future<void> deleteAll() async {
    final db = await database();
    await db.delete(nombreDB);
  }
}
