import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'utilitarios.dart';
import 'package:intl/intl.dart';
import 'login.dart';
import 'cadastro.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class Detalhamento extends StatefulWidget {
  final int id;
  Detalhamento({Key key, @required this.id}) : super(key: key);
  @override
  _Detalhamento createState() => _Detalhamento(id: id);
}

class _Detalhamento extends State<Detalhamento> {
  var doc;
  var item;
  final int id;
  _Detalhamento({Key key, @required this.id});

  File _image1;
  File _image2;
  File _image3;
  _recuperaCep(String CEP) async{
    String cep = CEP;
    String url = "https://viacep.com.br/ws/${cep}/json/";
    http.Response response;
    response = await http.get(Uri.parse(url));
    print("Resposta: " + response.body);
  }

  Future _getImage(idImagem) async{
    print("ENTREI");
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      switch(idImagem){
        case 0:
          _image1 = image;
          break;
        case 1:
          _image2 = image;
          break;
        case 2:
          _image3 = image;
          break;
      }

      print('_image: $_image1');
    });
  }

  @override
  Widget build(BuildContext context){
    var snapshots = FirebaseFirestore.instance.collection('ideias').where('id', isEqualTo: id).snapshots();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.red[800]),
        actions: <Widget>[
          PopupMenuButton(
              onSelected: (result){
                if (result == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => null),
                  );
                }
                else if(result == 1){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TelaCadastro()),
                  );
                }
                else if(result == 2){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TelaLogin()),
                  );
                }
              },
              itemBuilder: (BuildContext context){
                return [
                  PopupMenuItem(
                    child: Text('Usuários'),
                    value: 0,
                  ),
                  PopupMenuItem(
                    child: Text('Cadastro'),
                    value: 1,
                  ),
                  PopupMenuItem(
                    child: Text('Login'),
                    value: 2,
                  ),
                  //PopupMenuItem(child: Text('Android')),
                ];
              }
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: StreamBuilder(
        stream: snapshots,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if (snapshot.hasError){
            return Center(
                child: Text('Error: ${snapshot.error}')
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting){
            return Center(
                child: CircularProgressIndicator()
            );
          }
          if (snapshot.data.docs.length == 0){
            return Center(
                child: Text('Parece que não temos mais informações sobre a sua ideia genial...')
            );
          }
          return Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5)
            ),
            margin: const EdgeInsets.fromLTRB(20, 80, 20, 0),
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Row(
                children: <Widget>[
                  Icon(Icons.camera_alt_outlined),
                  Text(' Imagens'),
                ]),
                //Divider(),
                GridView.count(
                  shrinkWrap: true,
                  primary: false,
                  padding: const EdgeInsets.all(10),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 3,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => _getImage(0),
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black12,
                          ),
                          child: _image1 == null ? Icon(Icons.add) : Image.file(_image1)
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _getImage(1),
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black12,
                          ),
                          child: _image2 == null ? Icon(Icons.add) : Image.file(_image2)
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _getImage(2),
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black12,
                          ),
                          child: _image3 == null ? Icon(Icons.add) : Image.file(_image3)
                      ),
                    ),
                  ]
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: SizedBox(
                        height: 260.0,
                        child: ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder:(BuildContext context, int i){
                              doc = snapshot.data.docs[i];
                              item = Map.of(doc.data());
                              print(item['titulo']);
                              return ListTile(
                                title: Text(item['titulo']),
                                subtitle: Text("${item['descricao']}\n Criação: ${DateFormat("dd/MM/yyyy hh:mm").format(DateTime.fromMillisecondsSinceEpoch(item['data'].seconds * 1000))}"),
                              );
                            },
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                        onPressed: () => modalCreate(context, 'edit', doc),
                        style: TextButton.styleFrom(
                          primary: Colors.red[800],
                        ),
                        child: Text('Editar')
                    ),
                    TextButton(
                        onPressed: () => {
                          doc.reference.update({'status': 'excluido'}),

                        },
                        style: TextButton.styleFrom(
                          primary: Colors.red[800],
                        ),
                        child: Text('Excluir')
                    ),
                  ]
                ),
              ],
            ),
          );
        },
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () => modalCreateCalendar(context, 'add', null),
        tooltip: 'Adicionar novo',
        child: Icon(Icons.event_available),
        backgroundColor: Colors.red[800],
      ),*/
    );
  }
}