import 'package:gastos/models/metodo_pago_model.dart';
import 'package:gastos/utilities/sql_generator.dart';
import 'package:sqflite/sqflite.dart' as sql;

String nombreDB = "metodo_pago";

class MetodoGastoController {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE $nombreDB(
      id INTEGER,
      nombre TEXT,
      cambio INTEGER,
      denominacion TEXT,
      status INTEGER,
      defecto INTEGER
      )""");
  }

  static Future<sql.Database> database() async {
    return sql.openDatabase('app_$nombreDB.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  static Future<void> generarObtencion() async {
    MetodoPagoModel metodo = MetodoPagoModel(
        id: 1,
        nombre: "Efectivo",
        cambio: 1.0,
        denominacion: "MXN",
        status: 0,
        defecto: 1);
    final result = await find(metodo);
    if (result == null) {
      await insert(metodo);
    }
  }

  static Future<void> insert(MetodoPagoModel metodo) async {
    final db = await database();
    await SqlGenerator.existColumna(
        add: "defecto", database: database, nombreDB: nombreDB);
    await db.insert(nombreDB, metodo.toJson());
  }

  static Future<void> update(MetodoPagoModel metodo) async {
    final db = await database();
    await SqlGenerator.existColumna(
        add: "defecto", database: database, nombreDB: nombreDB);
    await db.update(nombreDB, metodo.toJson(),
        where: "id = ?", whereArgs: [metodo.id]);
  }

  static Future<void> delete(MetodoPagoModel metodo) async {
    final db = await database();
    await SqlGenerator.existColumna(
        add: "defecto", database: database, nombreDB: nombreDB);
    await db.delete(nombreDB, where: "id = ?", whereArgs: [metodo.id]);
  }

  static Future<int> lastId() async {
    final db = await database();
    final data =
        (await db.query(nombreDB, orderBy: "id DESC", limit: 1)).firstOrNull;
    return data == null ? 1 : ((MetodoPagoModel.fromJson(data)).id) + 1;
  }

  static Future<void> deleteAll() async {
    final db = await database();
    await SqlGenerator.existColumna(
        add: "defecto", database: database, nombreDB: nombreDB);
    await db.delete(nombreDB);
  }

  static Future<MetodoPagoModel?> find(MetodoPagoModel metodo) async {
    final db = await database();
    await SqlGenerator.existColumna(
        add: "defecto", database: database, nombreDB: nombreDB);

    final data = (await db.query(nombreDB,
            where: "id = ?", whereArgs: [metodo.id], limit: 1))
        .firstOrNull;
    return data == null ? null : MetodoPagoModel.fromJson(data);
  }

  static Future<List<MetodoPagoModel>> getItems() async {
    final db = await database();

    List<MetodoPagoModel> metodo = [];
    final data = await db.query(nombreDB);
    for (var element in data) {
      metodo.add(MetodoPagoModel.fromJson(element));
    }
    return metodo;
  }
}
