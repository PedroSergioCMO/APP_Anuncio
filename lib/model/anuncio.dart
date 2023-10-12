import 'dart:io';
import 'package:app_anuncio/database/anuncio_helper.dart';

class Anuncio {
  int? id;
  late String titulo;
  late String descricao;
  late double preco;
  late bool ativo = true;
  File? image;

  Anuncio(this.titulo, this.descricao, this.preco, {this.image, this.id});

  Anuncio.fromMap(Map map) {
    this.id = map[AnuncioHelper.idColumn];
    this.titulo = map[AnuncioHelper.tituloColumn];
    this.descricao = map[AnuncioHelper.descricaoColumn];

    // Verifique se o valor é uma string antes de tentar convertê-lo em double
    if (map[AnuncioHelper.precoColumn] is String) {
      this.preco = double.tryParse(map[AnuncioHelper.precoColumn]) ?? 0.0;
    } else {
      this.preco = map[AnuncioHelper.precoColumn] as double;
    }

    this.ativo = map[AnuncioHelper.ativoColumn] == 1 ? true : false;
    this.image = map[AnuncioHelper.imageColumn] != null
        ? File(map[AnuncioHelper.imageColumn])
        : null;
  }

  Map<String, dynamic> topMap() {
    Map<String, dynamic> map = {
      AnuncioHelper.idColumn: this.id,
      AnuncioHelper.tituloColumn: this.titulo,
      AnuncioHelper.descricaoColumn: this.descricao,
      AnuncioHelper.precoColumn: this.preco,
      AnuncioHelper.ativoColumn: this.ativo ? 1 : 0,
      AnuncioHelper.idColumn: this.id,
      AnuncioHelper.imageColumn: this.image != null ? this.image!.path : null
    };
    return map;
  }
}
