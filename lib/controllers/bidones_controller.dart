import 'package:gastos/models/bidones_model.dart';
import 'package:sqflite/sqflite.dart' as sql;

String nombreDB = "bidones";

class BidonesController {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE $nombreDB(
        id INTEGER,
        identificador INTEGER,
        nombre TEXT,
        monto_inicial INTEGER,
        monto_final INTEGER,
        metodo_pago INTEGER,
        dias_efecto INTEGER,
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
}
