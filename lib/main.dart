import 'package:flutter/material.dart';
import 'utilitarios.dart';
import 'login.dart';
import 'cadastro.dart';
import 'home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'usuarios.dart';
import 'package:http/http.dart' as http;
//import 'detalhamento_contato.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget{
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
        routes: {
          "/login":     (context) => TelaLogin(),
          "/cadastrar": (context) => TelaCadastro(),
          "/home": (context) => Home(),
          //"/users": (context) => Users(),
          //"/detalhamento": (context) => Detalhamento()
        },
        theme: ThemeData(primaryColor: Colors.red[800]),
        home: HomePage()
    );
  }
}

class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new Stack(
            children: <Widget>[
              new Container(
                  decoration: new BoxDecoration(
                      image: new DecorationImage(
                          image: AssetImage('assets/images/principal.png'),
                          fit: BoxFit.cover))
              ),
              new Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(0,10,0,10),
                          child: botaoGenerico("Entrar", context, "/login"),
                        ),
                        botaoGenerico("Cadastrar", context, "/cadastrar")
                      ]
                  )
              )
            ]
        ),
        extendBody: true,
        extendBodyBehindAppBar: true
    );
  }
}

