
import 'package:sqflite/sqflite.dart' as sql;

import '../models/gasto_model.dart';

String nombreDB = "gasto";

class GastosController {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE $nombreDB(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      categoria_id INTEGER,
      monto TEXT,
      fecha TEXT,
      dia TEXT,
      mes TEXT,
      peridico INTEGER,
      periodo TEXT,
      gasto INTEGER,
      evidencia TEXT
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
    await db.insert(nombreDB, gasto.toJson(),
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<GastoModelo>> getItems() async {
    final db = await database();
    List<GastoModelo> modelo = [];
    List<Map<String, dynamic>> data =
        await db.query(nombreDB, orderBy: "id");
    for (var element in data) {
      modelo.add(GastoModelo.fromJson(element));
    }
    return modelo;
  }

  static Future<void> deleteItem(int id) async {
    final db = await database();
    await db.delete(nombreDB, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> deleteAll() async {
    final db = await database();
    await db.delete(nombreDB);
  }
}
