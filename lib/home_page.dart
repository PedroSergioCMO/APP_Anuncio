import 'package:app_anuncio/persistencia/file_persistance.dart';
import 'package:flutter/material.dart';
import 'package:app_anuncio/model/anuncio.dart';
import 'package:url_launcher/url_launcher.dart';

import 'cadastro_anuncio.dart';

class home_page extends StatefulWidget {
  const home_page({super.key});

  @override
  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {
  FilePersistance persistence = FilePersistance();
  List<Anuncio> _anuncio = List.empty(growable: true);

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    persistence.readData().then((data) {
      setState(() {
        if (data != null) {
          _anuncio = data;
        }
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
                    persistence.saveData(_anuncio);
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
                      persistence.saveData(_anuncio);
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
                  
                onLongPress: async (){
                  showBottomSheet(context: context, 
                  builder: (context){
                    return Container(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: Icon(Icons.email),
                            title: Text("Enviar por email"),
                            onTap:  () async {
                              final Uri params = Uri (
                                scheme: 'mailto',
                                path: "pedro.sergio@estudante.ifgoiano.edu.br",
                                queryParameters: {
                                  "subject": "Fale conosco",
                                  "body": "Digite sua mensagem..."
                                }
                              );
                              final url = params.toString();
                              if(!await.launch(url)){
                                  throw 'Não pode rodar $url';
                                }
                              Navigator.pop(context);
                            },
                            
                          )
                        ],
                      ),
                      );
                  });
                }
              ),
            );
          },
          separatorBuilder: (context, index) => Divider(),
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
              persistence.saveData(_anuncio);
            });
          }
        },
        child: Icon(Icons.add),
        mini: false,
      ),
    );
  }
}
