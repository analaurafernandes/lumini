import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import 'login.dart';
import 'package:http/http.dart' as http;
class TelaCadastro extends StatefulWidget {
  @override
  _TelaCadastro createState() => _TelaCadastro();
}

class _TelaCadastro extends State<TelaCadastro> {
  @override
  Widget build(BuildContext context) {
    var form = GlobalKey<FormState>();

    var email = TextEditingController();
    var login = TextEditingController();
    var senha = TextEditingController();

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
                      MaterialPageRoute(builder: (context) => TelaLogin()),
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
        body: new Stack(
            children: <Widget>[
              new Container(
                  decoration: new BoxDecoration(
                      image: new DecorationImage(
                          image: AssetImage('assets/images/cadastro.png'),
                          fit: BoxFit.cover))
              ),
              new Center(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(64, 40, 64, 0),
                      child: Container(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Form(
                                  key: form,
                                  child: Container(
                                    height: MediaQuery.of(context).size.height/3,
                                    child: Column(
                                      children: <Widget>[
                                        TextFormField(
                                          style: TextStyle(color: Colors.white),
                                          controller: email,
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.email, color: Colors.red[800], size: 22),
                                            hintText: 'E-mail',
                                            hintStyle: TextStyle(color: Colors.white),
                                            border: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.red[800]
                                                )
                                            ),
                                          ),
                                          validator: (value){
                                            if(value.isEmpty){
                                              return 'Campo de preenchimento obrigatório';
                                            }
                                            return null;
                                          },
                                        ),
                                        TextFormField(
                                          style: TextStyle(color: Colors.white),
                                          controller: login,
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.person, color: Colors.red[800], size: 22),
                                            hintText: 'Login',
                                            hintStyle: TextStyle(color: Colors.white),
                                            border: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.red[800]
                                                )
                                            ),
                                          ),
                                          validator: (value){
                                            if(value.isEmpty){
                                              return 'Campo de preenchimento obrigatório';
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(height: 10),
                                        TextFormField(
                                          style: TextStyle(color: Colors.white),
                                          controller: senha,
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.lock, color: Colors.red[800], size: 22),
                                            hintText: 'Senha',
                                            hintStyle: TextStyle(color: Colors.white),
                                            border: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.red[800]
                                                )
                                            ),
                                          ),
                                          validator: (value){
                                            if(value.isEmpty){
                                              return 'Campo de preenchimento obrigatório';
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: new RoundedRectangleBorder(
                                          borderRadius: new BorderRadius.circular(30.0),
                                        ),
                                        minimumSize: Size(150, 5),
                                        primary: Colors.red[800],
                                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                        textStyle: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black54
                                        )),
                                    child: Text('Cadastrar'),
                                    onPressed: () async{
                                      if(form.currentState.validate()) {
                                        var random = new Random();
                                        await FirebaseFirestore.instance.collection('usuarios')
                                            .add({
                                          'login': login.text,
                                          'senha': senha.text,
                                          'email': email.text,
                                          'status': 'ativo',
                                          'id_usuario': random.nextInt(1500000) + 1
                                        });
                                        UserCredential user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.text, password: senha.text);
                                      }
                                      Navigator.pushNamed(context, '/login');
                                    }
                                ),
                              ]
                          )
                      )
                  )
              )
            ]
        )
    );
  }
}