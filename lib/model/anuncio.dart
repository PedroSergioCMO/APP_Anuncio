import 'dart:io';
import 'package:app_anuncio/database/anuncio_helper.dart';

class Anuncio {
  int? id;
  late String titulo;
  late String descricao;
  late double preco;
  late bool ativo = true;
  File? image;

  Anuncio(this.titulo, this.descricao, this.preco, this.image, this.id);

  Anuncio.fromMap(Map map) {
    this.id = map[AnuncioHelper]
    titulo = map['titulo'];
    descricao = map['descricao'];
    preco = map['preco'];
    ativo = map['ativo'];
  }

  Map<String, dynamic> topMap() {
    return {
      "titulo": this.titulo,
      "descricao": this.descricao,
      "preco": this.preco,
      "ativo": this.ativo
    };
  }
}
