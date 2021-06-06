//import 'package:agenda_contatos/usuarios.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'usuarios.dart';
import 'cadastro.dart';
import 'package:http/http.dart' as http;

class TelaLogin extends StatefulWidget {
  @override
  _TelaLogin createState() => _TelaLogin();
}

class _TelaLogin extends State<TelaLogin> {
  @override
  Widget build(BuildContext context) {
    var form = GlobalKey<FormState>();

    var email = TextEditingController();
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
                          image: AssetImage('assets/images/login.png'),
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
                                          controller: email,
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.email, color: Colors.red[800], size: 22),
                                            hintText: 'E-mail',
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
                                          controller: senha,
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.lock, color: Colors.red[800], size: 22),
                                            hintText: 'Senha',
                                            border: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.red[800]
                                                )
                                            ),
                                          ),
                                          obscureText: true,
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
                                    child: Text('Entrar'),
                                    onPressed: () async{
                                      if(form.currentState.validate()) {
                                        try {
                                          UserCredential user = await FirebaseAuth
                                              .instance
                                              .signInWithEmailAndPassword(
                                              email: email.text,
                                              password: senha.text);
                                          print(user.toString());
                                        }
                                        catch(e){
                                          print('Foi encontrado um erro: $e');
                                        }
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