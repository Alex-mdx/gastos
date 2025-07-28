import 'package:gastos/models/bidones_model.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart' as sql;

class BidonesController {
  static String nombreDB = "bidones";
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE $nombreDB(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
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
        inhabilitado INTEGER,
        gastos INTEGER
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
        where: "identificador = ? AND id = ?",
        whereArgs: [cate.identificador, cate.id],
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }
  
  static Future<List<BidonesModel>> getItemsByAbierto() async {
    final db = await database();
    List<BidonesModel> categoriaModelo = [];
    List<Map<String, dynamic>> categoria =
        await db.query(nombreDB, where: "cerrado = 0", orderBy: "nombre ASC");
    for (var element in categoria) {
      categoriaModelo.add(BidonesModel.fromJson(element));
    }
    return categoriaModelo;
  }

  static Future<List<BidonesModel>> getItemsByPersonalizado(
      {required String query, required List<String> args}) async {
    final db = await database();
    List<BidonesModel> categoriaModelo = [];
    List<Map<String, dynamic>> categoria =
        await db.query(nombreDB, where: query, whereArgs: args);
    for (var element in categoria) {
      categoriaModelo.add(BidonesModel.fromJson(element));
    }
    return categoriaModelo;
  }

  static Future<List<BidonesModel>> getItems() async {
    final db = await database();
    List<BidonesModel> categoriaModelo = [];
    List<Map<String, dynamic>> categoria =
        await db.query(nombreDB, orderBy: "nombre ASC");
    for (var element in categoria) {
      categoriaModelo.add(BidonesModel.fromJson(element));
    }
    return categoriaModelo;
  }

  static Future<BidonesModel?> getItem({required int id}) async {
    final db = await database();
    final categoria = (await db.query(nombreDB,
            where: "id = ?", whereArgs: [id], orderBy: "nombre ASC", limit: 1))
        .firstOrNull;
    return categoria == null ? null : BidonesModel.fromJson(categoria);
  }

  static Future<BidonesModel?> getItemByGasto({required int gastoid}) async {
    final db = await database();
    final categoria = (await db.query(nombreDB,
        where: "gastos LIKE ? ",
        whereArgs: ['%$gastoid%'],
        orderBy: "nombre ASC"));
    List<BidonesModel> bidonNew = [];
    for (var element in categoria) {
      bidonNew.add(BidonesModel.fromJson(element));
    }
    var newBdion = bidonNew.firstWhereOrNull((element) =>
        element.gastos.firstWhereOrNull((gId) => gId == gastoid) != null);
    return newBdion;
  }

  static Future<List<BidonesModel>> buscarCoincidencia(
      int metodoPagoId, int categoriaId) async {
    final db = await database();
    List<BidonesModel> modelado = [];
    List<Map<String, dynamic>> data = await db.query(nombreDB,
        where: "(metodo_pago LIKE ? OR categoria LIKE ?) AND cerrado = 0",
        whereArgs: ['%$metodoPagoId%', '%$categoriaId%']);
    for (var element in data) {
      modelado.add(BidonesModel.fromJson(element));
    }
    return modelado
        .where((element) =>
            element.metodoPago
                    .firstWhereOrNull((mpId) => mpId == metodoPagoId) !=
                null ||
            element.categoria
                    .firstWhereOrNull((catId) => catId == categoriaId) !=
                null)
        .toList();
  }

  static Future<void> deleteId(int id) async {
    final db = await database();
    await db.delete(nombreDB, where: 'id = ?', whereArgs: [id]);
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
