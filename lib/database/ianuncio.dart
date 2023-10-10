import 'package:app_anuncio/model/anuncio.dart';

abstract class IAnuncio {
  Future<Anuncio?> save(Anuncio anuncio);
  Future<List<Anuncio>> getAll();
  Future<Anuncio?> getById(int id);
  Future<int?> edit(Anuncio anuncio);
  Future<int?> delete(Anuncio anuncio);
}
