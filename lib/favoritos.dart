import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'utilitarios.dart';
//import 'usuarios.dart';
import 'login.dart';
import 'cadastro.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'detalhamento.dart';

class Favoritos extends StatefulWidget {
  @override
  _Favoritos createState() => _Favoritos();
}

class _Favoritos extends State<Favoritos> {

  @override
  Widget build(BuildContext context){
    var snapshots = FirebaseFirestore.instance.collection('ideias').where('favorito', isEqualTo: true).orderBy('titulo').snapshots();

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
                child: Text('Você ainda não possui ideias favoritas!')
            );
          }
          return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder:(BuildContext context, int i){
                var doc = snapshot.data.docs[i];
                var item = Map.of(doc.data());
                var fav = item['favorito'] ? true : false;
                print(item['nome']);
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)
                  ),
                  margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                  child: ListTile(
                    leading: IconButton(
                        icon: Icon(fav ? Icons.favorite : Icons.favorite_border),
                        onPressed: () => {
                          setState((){
                            fav = !fav;
                          }),
                          doc.reference.update({'favorito': fav})
                        }
                    ),
                    title: Text(item['titulo']),
                    subtitle: Text(DateFormat("dd/MM/yyyy hh:mm").format(DateTime.fromMillisecondsSinceEpoch(item['data'].seconds * 1000))),
                    trailing: Wrap(
                      //spacing: 2,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.navigate_next),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Detalhamento(id: item['id'])),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
          );
        },
      ),
    );
  }
}