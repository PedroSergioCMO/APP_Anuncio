import 'package:app_anuncio/database/database_helper.dart';
import 'package:app_anuncio/model/anuncio.dart';

class AnuncioHelper implements Anuncio {
  static final String tableName = "Anuncios";
  static final String idColumn = "id";
  static final String tituloColumn = "titulo";
  static final String descricaoColumn = "descricao";
  static final String precoColumn = "preco";
  static final String ativoColumn = "ativo";

  static get createScript {
    return "CREATE TABLE $tableName($idColumn INTEGER PRIMARY KEY AUTOINCREMENT, " +
        "$tituloColumn TEXT NO NULL, $descricaoColumn TEXT NOT NULL, $precoColumn TEXT NOT NULL" +
        "$ativoColumn INTEGER NOT NULL)";
  }

  @override
  Future<Anuncio?> save(Anuncio anuncio) async {
    Database? db = await DatabaseHelper().db;
    if (db != null) {
      anuncio.id = await db.insert(tableName, anuncio.topMap());
      return anuncio;
    }
    return null;
  }

  @override
  Future<int?> delete(Anuncio anuncio) async {
    Database? db = await DatabaseHelper().db;
    if (db != null) {
      return await db.delete(tableName, where: "id=?", whereArgs: [anuncio.id]);
    }
  }

  @override
  Future<int?> edit(Anuncio anuncio) async {
    Database? db = await DatabaseHelper().db;
    if (db != null) {
      return await db.update(tableName, anuncio.topMap(),
          where: "id=?", whereArgs: [anuncio.id]);
    }
  }

  @override
  Future<List<Anuncio>> getAll() async {
    Database? db = await DatabaseHelper().db;
    List<Anuncio> anuncios = List.empty(growable: true);
    if (db != null) {
      List<Map> returnedAnuncios = await db.query(tableName, columns: [
        idColumn,
        tituloColumn,
        descricaoColumn,
        precoColumn,
        ativoColumn
      ]);

      for (Map mAnuncio in returnedAnuncios) {
        anuncios.add(Anuncio.fromJson(mAnuncio));
      }
    }
    return anuncios;
  }

  @override
  Future<Anuncio?> getById(int id) async {
    Database? db = await DatabaseHelper().db;
    if (db != null) {
      List<Map> returnedAnuncio = await db.query(tableName,
          columns: [
            idColumn,
            tituloColumn,
            descricaoColumn,
            precoColumn,
            ativoColumn
          ],
          where: "id=?",
          whereArgs: [id]);

      return Anuncio.fromJson(returnedAnuncio.first);
    }
    return null;
  }
}
