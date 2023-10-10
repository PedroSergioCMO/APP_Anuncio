import 'dart:io';
import 'package:app_anuncio/model/anuncio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class cadastro_anuncio extends StatefulWidget {
  Anuncio? nuncio;
  cadastro_anuncio({this.nuncio});

  State<cadastro_anuncio> createState() => _cadastro_anuncioState();
}

class _cadastro_anuncioState extends State<cadastro_anuncio> {
  GlobalKey<FormState> _formkey = GlobalKey();
  TextEditingController _tituloController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();
  TextEditingController _precoController = TextEditingController();
  ImagePicker _picker = ImagePicker();
  File? _image;

  @override
  void initState() {
    super.initState();
    if (widget.nuncio != null) {
      _image = widget.nuncio!.image;
      _tituloController.text = widget.nuncio!.titulo;
      _descricaoController.text = widget.nuncio!.descricao;
      _precoController.text = widget.nuncio!.preco.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cadastro Anuncio",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue[500],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 20.0),
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(),
                  shape: BoxShape.circle,
                ),
                child: _image == null
                    ? Icon(
                        Icons.add_a_photo,
                        size: 30,
                      )
                    : ClipOval(
                        child: Image.file(_image!),
                      ),
              ),
              onTap: () async {
                XFile? image =
                    await _picker.pickImage(source: ImageSource.camera);
                if (image != null) {
                  setState(() {
                    _image = File(image.path);
                  });
                }
              },
            ),
            Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: _tituloController,
                      decoration: InputDecoration(
                        label: Text("Titulo: "),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Preenchimento Obrigatorio";
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: _descricaoController,
                      decoration: InputDecoration(
                        label: Text("Descrição: "),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Preenchimento Obrigatorio";
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    height: 100,
                    width: 150,
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: _precoController,
                      decoration: InputDecoration(
                        label: Text("Preço: "),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Preenchimento Obrigatorio";
                        }
                        return null;
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formkey.currentState!.validate()) {
                                Anuncio newAnuncio = Anuncio(
                                  _tituloController.text,
                                  _descricaoController.text,
                                  double.parse(_precoController.text),
                                  File(_image!.path),
                                );
                                Navigator.pop(context, newAnuncio);
                              }
                            },
                            child: Text(
                              "Confirmar",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[400]),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text(
                              "Cancelar",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[400]),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
