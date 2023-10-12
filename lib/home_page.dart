import 'package:app_anuncio/database/anuncio_helper.dart';
import 'package:app_anuncio/persistencia/file_persistance.dart';
import 'package:flutter/material.dart';
import 'package:app_anuncio/model/anuncio.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app_anuncio/database/ianuncio.dart';

import 'cadastro_anuncio.dart';

class home_page extends StatefulWidget {
  const home_page({super.key});

  @override
  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {
  FilePersistance persistence = FilePersistance();
  List<Anuncio> _anuncio = List<Anuncio>.empty(growable: true);
  IAnuncio helper = AnuncioHelper();

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    helper.getAll().then((data) {
      setState(() {
        _anuncio = data;
      });
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  //   persistence.readData().then((data) {
  //     _anuncio = data;
  //   });
  // }

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
        child: ListView.separated(
          itemCount: _anuncio.length,
          itemBuilder: (context, index) {
            Anuncio anuncio = _anuncio[index];

            return Dismissible(
              key: Key(anuncio.id.toString()),
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
              onDismissed: (direction) async {
                if (direction == DismissDirection.startToEnd) {
                  int? result = await helper.delete(anuncio);
                  String deleteText = "Erro ao excluir anuncio";
                  setState(() {
                    if (result != null) {
                      _anuncio.remove(anuncio);
                      deleteText = "Anuncio removido com sucesso";
                    }

                    SnackBar snackBar = SnackBar(
                      content: Text(deleteText),
                      backgroundColor: Colors.red,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                    int? result = await helper.edit(editedAnuncio);
                    String editText = "Erro ao editar o Anuncio";

                    setState(() {
                      if (result != null) {
                        _anuncio.remove(anuncio);
                        _anuncio.insert(index, editedAnuncio);
                        editText = "Anuncio editado com sucesso!";
                      }

                      SnackBar snackBar = SnackBar(
                        content: Text(editText),
                        backgroundColor: Colors.orange,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    });
                  }
                  return false;
                } else {
                  return true;
                }
              },
              child: ListTile(
                  leading: anuncio.image != null
                      ? CircleAvatar(
                          child: ClipOval(
                            child: Image.file(anuncio.image!),
                          ),
                        )
                      : const SizedBox(),
                  title: Text(
                    "Titulo: " + anuncio.titulo,
                    style: TextStyle(),
                  ),
                  subtitle: Text("Preco: " + anuncio.preco.toString(),
                      style: TextStyle()),
                  onLongPress: () async {
                    showBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: Icon(Icons.email),
                                  title: Text("Enviar por e-mail"),
                                  onTap: () {
                                    Navigator.pop(context);
                                    Anuncio anuncio = _anuncio[index];

                                    final Uri emailUri = Uri(
                                        scheme: 'mailto',
                                        path: "pedrosergiocmo@gmail.com",
                                        queryParameters: {
                                          "subject": "Duvidas",
                                          "body":
                                              "Duvida sobre o produto ${anuncio.titulo}"
                                        });
                                    final Url = emailUri.toString();
                                    launch(Url);
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.email),
                                  title: Text("Enviar por SMS"),
                                  onTap: () {
                                    Navigator.pop(context);
                                    Anuncio anuncio = _anuncio[index];

                                    final Uri smslUri = Uri(
                                        scheme: 'sms',
                                        path: "+556599999-3333",
                                        queryParameters: {
                                          "body":
                                              "Você ganhou um ${anuncio.titulo}, Envie um pix para este numero e ganhe mais 200.000 reias"
                                        });
                                    final Url = smslUri.toString();
                                    launch(Url);
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            ),
                          );
                        });
                  }),
            );
          },
          separatorBuilder: (context, index) => Divider(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            Anuncio? anuncio = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => cadastro_anuncio()));
            // Navigator.pushNamed(context, "/cadastro");

            if (anuncio != null) {
              Anuncio? savedAnuncio = await helper.save(anuncio);
              String savedText = "Erro ao salvar tarefa no DB";
              setState(() {
                if (savedAnuncio != null) {
                  _anuncio.add(savedAnuncio);
                  savedText = "Tarefa criada com sucesso";
                }

                SnackBar snackBar = SnackBar(
                  content: Text(savedText),
                  backgroundColor: Colors.green,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              });
            }
          } catch (error) {
            print(error.toString());
          }

          // Anuncio? newAnuncio = await Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => cadastro_anuncio(),
          //   ),
          // );
          // if (newAnuncio != null) {
          //   setState(() {
          //     _anuncio.add(newAnuncio);
          //     persistence.saveData(_anuncio);
          //   });
          // }
        },
        child: Icon(Icons.add),
        mini: false,
      ),
    );
  }
}
