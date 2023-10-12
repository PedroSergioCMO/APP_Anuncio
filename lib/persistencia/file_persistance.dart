import 'dart:convert';

import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../model/anuncio.dart';

class FilePersistance {
  Future<File> _getDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    String path = directory.path;
    return File('$path/anuncioList.json');
  }

  Future saveData(List<Anuncio> anuncios) async {
    File localFile = await _getDirectory();
    List mapAnuncios = List.empty(growable: true);

    anuncios.forEach((anuncio) {
      mapAnuncios.add(anuncio.topMap());
    });

    String data = json.encode(mapAnuncios);
    if (localFile.writeAsString(data) != null) return true;
    return false;
  }

  Future getData() async {
    final localFile = await _getDirectory();
    List mapAnuncios = List.empty(growable: true);
    List anuncios = List<Anuncio>.empty(growable: true);
    String data = await localFile.readAsString();

    mapAnuncios = json.decode(data);

    mapAnuncios.forEach((mapAnuncio) {
      anuncios.add(Anuncio.fromMap(mapAnuncio));
    });

    return anuncios;
  }
}
