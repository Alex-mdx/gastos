import 'package:sqflite/sqflite.dart' as sql;
import '../models/categoria_model.dart';

String nombreDB = "categoria";

class CategoriaController {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE $nombreDB(
          id INTEGER,
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

  static Future<void> update(CategoriaModel cate) async {
    final db = await database();
    await db.update(nombreDB, cate.toJson(),
        where: 'id = ?', whereArgs: [cate.id]);
  }

  static Future<int> getLastId() async {
    final db = await database();
    final data =
        (await db.query(nombreDB, limit: 1, orderBy: 'id DESC')).firstOrNull;
    CategoriaModel? modelo =
        data == null ? null : CategoriaModel.fromJson(data);

    return ((modelo?.id) ?? 0) + 1;
  }

  static Future<CategoriaModel?> getItem({required int id}) async {
    final db = await database();
    final categoria = (await db.query(nombreDB,
            where: "id = ?", whereArgs: [id], orderBy: "nombre"))
        .firstOrNull;

    return categoria == null ? null : CategoriaModel.fromJson(categoria);
  }

  static Future<List<CategoriaModel>> getItems({String? orderBy}) async {
    final db = await database();

    // Verificamos si existe alguna categoría con uso_total > 0
    final maxUsoResult =
        await db.rawQuery("SELECT MAX(uso_total) as max_uso FROM $nombreDB");
    final int maxUso = (maxUsoResult.first['max_uso'] as int?) ?? 0;

    // Si maxUso es mayor a 0, se ordena por uso_total descendente y luego por nombre.
    // En caso contrario, se utiliza el orderBy por defecto ("nombre").
    final String sortOrder =
        orderBy ?? (maxUso > 0 ? "uso_total DESC, nombre ASC" : "nombre ASC");

    List<CategoriaModel> categoriaModelo = [];
    List<Map<String, dynamic>> categoria =
        await db.query(nombreDB, orderBy: sortOrder);
    for (var element in categoria) {
      categoriaModelo.add(CategoriaModel.fromJson(element));
    }
    return categoriaModelo;
  }

  static Future<List<CategoriaModel>> buscar(String word) async {
    final db = await database();
    List<CategoriaModel> categoriaModelo = [];
    List<Map<String, dynamic>> categoria = await db.query(nombreDB,
        where: "nombre LIKE ?",
        whereArgs: ['%$word%'],
        orderBy: "nombre",
        limit: 5);
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
