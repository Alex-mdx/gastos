import 'package:sqflite/sqflite.dart' as sql;

import '../models/gasto_model.dart';

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
    await db.insert(nombreDB, gasto.toJson(),
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<GastoModelo>> getItems() async {
    final db = await database();
    List<GastoModelo> modelo = [];
    final data = (await db.query(nombreDB));
    for (var element in data) {
      modelo.add(GastoModelo.fromJson(element));
    }
    return modelo;
  }

  static Future<GastoModelo?> find(int id) async {
    final db = await database();

    final data = (await db.query(nombreDB, where: "id = ?", whereArgs: [id]))
        .firstOrNull;
    GastoModelo? modelo = data == null ? null : GastoModelo.fromJson(data);
    return modelo;
  }

  static Future<void> updateItem(GastoModelo gasto) async {
    final db = await database();
    await db.update(nombreDB, gasto.toJson(), where: "id = ?", whereArgs: [gasto.id]);
  }

  static Future<int?> getLastId() async {
    final db = await database();
    final data = (await db.query(nombreDB,limit: 1,orderBy: 'id DESC'))
        .firstOrNull;
    GastoModelo? modelo = data == null ? null : GastoModelo.fromJson(data);
    
    return modelo?.id;
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
