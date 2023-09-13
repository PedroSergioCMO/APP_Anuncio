import 'package:flutter/material.dart';
import 'package:app_anuncio/model/anuncio.dart';

import 'cadastro_anuncio.dart';

class home_page extends StatefulWidget {
  const home_page({super.key});

  @override
  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {
  List<Anuncio> _anuncio = List.empty(growable: true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            child: Image.asset("assets/imgs/logo.webp"),
            height: 300,
            width: 30,
            padding: EdgeInsets.symmetric(vertical: 120, horizontal: 0),
          ),
          Text(
            "  Magalu 2.0",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ]),
        backgroundColor: Colors.blue[500],
      ),
      body: Container(
        child: ListView.builder(
          itemCount: _anuncio.length,
          itemBuilder: (context, index) {
            Anuncio anuncio = _anuncio[index];

            return Dismissible(
              key: UniqueKey(),
              background: Container(
                color: Colors.red,
                child: Align(
                  alignment: Alignment(-0.9, 0.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ),
              secondaryBackground: Container(
                color: Colors.green,
                child: Align(
                  alignment: Alignment(0.9, 0.0),
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                ),
              ),
              onDismissed: (direction) {
                if (direction == DismissDirection.startToEnd) {
                  setState(() {
                    _anuncio.removeAt(index);
                  });
                }
              },
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.endToStart) {
                  Anuncio? editedAnuncio = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              cadastro_anuncio(nuncio: anuncio)));
                  if (editedAnuncio != null) {
                    setState(() {
                      _anuncio.removeAt(index);
                      _anuncio.insert(index, editedAnuncio);
                    });
                  }
                  return false;
                } else {
                  return true;
                }
              },
              child: ListTile(
                title: Text(
                  "Titulo: " +
                      anuncio.titulo +
                      "\n" +
                      "Preço: " +
                      "R\$" +
                      anuncio.preco.toString(),
                  style: TextStyle(),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Anuncio? newAnuncio = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => cadastro_anuncio(),
            ),
          );
          if (newAnuncio != null) {
            setState(() {
              _anuncio.add(newAnuncio);
            });
          }
        },
        child: Icon(Icons.add),
        mini: false,
      ),
    );
  }
}
