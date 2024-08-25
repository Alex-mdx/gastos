import 'package:sqflite/sqflite.dart' as sql;
import '../models/categoria_model.dart';

String nombreDB = "categoria";

class CategoriaController {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE $nombreDB(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nombre TEXT,
          descripcion TEXT
      )""");
  }

  static Future<sql.Database> database() async {
    return sql.openDatabase('app_categoria.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  static Future<void> insert(CategoriaModel cate) async {
    final db = await database();
    await db.insert(nombreDB, cate.toJson(),
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<CategoriaModel>> getItems() async {
    final db = await database();
    List<CategoriaModel> categoriaModelo = [];
    List<Map<String, dynamic>> categoria =
        await db.query(nombreDB, orderBy: "nombre");
    for (var element in categoria) {
      categoriaModelo.add(CategoriaModel.fromJson(element));
    }
    return categoriaModelo;
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
