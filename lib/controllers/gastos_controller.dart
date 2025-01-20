import 'package:gastos/utilities/preferences.dart';
import 'package:sqflite/sqflite.dart' as sql;

import '../models/gasto_model.dart';
import '../utilities/sql_generator.dart';

String nombreDB = "gasto";

class GastosController {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE $nombreDB(
      id INTEGER,
      categoria_id INTEGER,
      monto TEXT,
      fecha TEXT,
      dia TEXT,
      mes TEXT,
      peridico INTEGER,
      ultima_fecha TEXT,
      periodo TEXT,
      gasto INTEGER,
      evidencia TEXT,
      nota TEXT
      )""");
  }

  static Future<sql.Database> database() async {
    return sql.openDatabase('app_gasto.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  static Future<void> insert(GastoModelo gasto) async {
    final db = await database();
    await SqlGenerator.existColumna(
        add: "metodo_pago_id", database: database, nombreDB: nombreDB);
    await db.insert(nombreDB, gasto.toJson(),
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  /* static Future<List<GastoModelo>> getItems() async {
    final db = await database();
    List<GastoModelo> modelo = [];
    final data = (await db.query(nombreDB));
    for (var element in data) {
      modelo.add(GastoModelo.fromJson(element));
    }
    return modelo;
  } */

  static Future<List<GastoModelo>> getConfigurado() async {
    final db = await database();

    int tipo = 0;

    List<GastoModelo> modelo = [];
    switch (Preferences.calculo) {
      case "Mensual":
        tipo = 31;
        break;
      case "Bimestral":
        tipo = 61;
        break;
      case "Trimestral":
        tipo = 92;
        break;
      case "Semestral":
        tipo = 182;
        break;
      case "Anual":
        tipo = 365;
        break;
      default:
        tipo = 31;
    }
    await SqlGenerator.existColumna(
        add: "metodo_pago_id", database: database, nombreDB: nombreDB);
    final resultados =
        await db.query(nombreDB, where: 'fecha BETWEEN ? AND ?', whereArgs: [
      (DateTime.now().subtract(Duration(days: tipo))).toString(),
      (DateTime.now()).toString(),
    ]);
    for (var element in resultados) {
      modelo.add(GastoModelo.fromJson(element));
    }
    return modelo;
  }

  static Future<List<GastoModelo>> obtenerFechasEnRangoMes(
      DateTime fechaInicio, DateTime fechaFinal) async {
    final db = await database();
    List<GastoModelo> modelo = [];
    await SqlGenerator.existColumna(
        add: "metodo_pago_id", database: database, nombreDB: nombreDB);
    final resultados = await db.query(nombreDB,
        where: 'fecha BETWEEN ? AND ?',
        whereArgs: [fechaInicio.toString(), fechaFinal.toString()]);
    for (var element in resultados) {
      modelo.add(GastoModelo.fromJson(element));
    }
    return modelo;
  }

  static Future<GastoModelo?> find(int id) async {
    final db = await database();
    await SqlGenerator.existColumna(
        add: "metodo_pago_id", database: database, nombreDB: nombreDB);
    final data = (await db.query(nombreDB, where: "id = ?", whereArgs: [id]))
        .firstOrNull;
    GastoModelo? modelo = data == null ? null : GastoModelo.fromJson(data);
    return modelo;
  }

  static Future<void> updateItem(GastoModelo gasto) async {
    final db = await database();
    await SqlGenerator.existColumna(
        add: "metodo_pago_id", database: database, nombreDB: nombreDB);
    await db.update(nombreDB, gasto.toJson(),
        where: "id = ?", whereArgs: [gasto.id]);
  }

  static Future<int?> getLastId() async {
    final db = await database();
    await SqlGenerator.existColumna(
        add: "metodo_pago_id", database: database, nombreDB: nombreDB);
    final data =
        (await db.query(nombreDB, limit: 1, orderBy: 'id DESC')).firstOrNull;
    GastoModelo? modelo = data == null ? null : GastoModelo.fromJson(data);

    return modelo?.id;
  }

  static Future<void> deleteItem(int id) async {
    final db = await database();
    await SqlGenerator.existColumna(
        add: "metodo_pago_id", database: database, nombreDB: nombreDB);
    await db.delete(nombreDB, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> deleteAll() async {
    final db = await database();
    await SqlGenerator.existColumna(
        add: "metodo_pago_id", database: database, nombreDB: nombreDB);
    await db.delete(nombreDB);
  }
}
