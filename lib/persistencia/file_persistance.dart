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
    List<Map<String, dynamic>> data = [];

    anuncios.forEach((anuncio) {
      data.add(anuncio.topMap());
    });

    String json = jsonEncode(data);

    return localFile.writeAsStringSync(json);
  }

  Future readData() async {
    try {
      File localData = await _getDirectory();
      String json = localData.readAsStringSync();

      List<dynamic> data = jsonDecode(json);
      List<Anuncio> anuncios = List.empty(growable: true);

      data.forEach((element) {
        anuncios.add(Anuncio.fromJson(element));
      });

      return anuncios;
    } catch (error) {
      print(error);
      return null;
    }
  }
}
