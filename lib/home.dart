import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lumini/favoritos.dart';
import 'utilitarios.dart';
import 'favoritos.dart';
import 'login.dart';
import 'package:intl/intl.dart';
import 'detalhamento.dart';
import 'lugares.dart';

class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {

  @override
  Widget build(BuildContext context){
    var snapshots = FirebaseFirestore.instance.collection('ideias').where('status', isEqualTo: 'ativo').orderBy('titulo').snapshots();

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
                    MaterialPageRoute(builder: (context) => Favoritos()),
                  );
                }
                else if(result == 1){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Lugares()),
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
                    child: Text('Favoritos'),
                    value: 0,
                  ),
                  PopupMenuItem(
                    child: Text('Lugares'),
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
      body: new Stack(
          children: <Widget>[
      new Container(
      decoration: new BoxDecoration(
      image: new DecorationImage(
      image: AssetImage('assets/images/ideias.png'),
        fit: BoxFit.cover))
    ),
    StreamBuilder(
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
                child: Text('Você ainda não postou as suas ideias!')
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
      ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => modalCreate(context, 'add', null),
        tooltip: 'Adicionar novo',
        child: Icon(Icons.add),
        backgroundColor: Colors.red[800],
      ),
    );
  }
}