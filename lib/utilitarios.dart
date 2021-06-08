import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import "package:googleapis_auth/auth_io.dart";
import 'package:googleapis/calendar/v3.dart' hide Colors;
//import 'calendar.dart';

_recuperaCep(String cep) async{
  String url = "https://viacep.com.br/ws/${cep}/json/";
  http.Response response;
  response = await http.get(Uri.parse(url));
  return response;
}


botaoGenerico(texto, BuildContext context, rota){
  return ElevatedButton(
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
      child: Text(texto),
      onPressed: (){
        Navigator.pushNamed(context, rota);
      }
  );
}

modalCreate(BuildContext context, String op, QueryDocumentSnapshot<Object> doc){
  var form = GlobalKey<FormState>();
  var descricao = TextEditingController();
  var titulo = TextEditingController();

  return showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Novo Contato'),
          content: Form(
            key: form,
            child: Container(
              height: MediaQuery.of(context).size.height/2,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: titulo,
                    decoration: InputDecoration(
                      hintText: 'Título',
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
                    controller: descricao,
                    decoration: InputDecoration(
                      hintText: 'Descrição',
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
          actions: <Widget>[
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  primary: Colors.red[800],
                ),
                child: Text('Cancelar')
            ),
            TextButton(
                onPressed: () async{
                  /*var endereco = await _recuperaCep(cep.text);
                  Map<String, dynamic> jsonEndereco = jsonDecode(endereco.body);
                  endereco = "Logradouro: ${jsonEndereco['logradouro']} \n Bairro: ${jsonEndereco['bairro']} \n Localidade: ${jsonEndereco['localidade']}";
                  print(jsonEndereco);*/
                  if(op == 'edit'){
                    if(form.currentState.validate())
                      doc.reference.update({
                        'titulo': titulo.text,
                        'descricao': descricao.text,
                        'favorito': false,
                        'status': 'ativo'
                      });
                  }
                  else{
                    var random = new Random();
                    if(form.currentState.validate()) {
                      await FirebaseFirestore.instance.collection('ideias').add({
                        'titulo': titulo.text,
                        'descricao': descricao.text,
                        'favorito': false,
                        'status': 'ativo',
                        'data': Timestamp.now(),
                        'id': random.nextInt(1500000) + 1
                      });
                      print("PASSEI AQUI");
                      print({
                        'titulo': titulo.text,
                        'descricao': descricao.text,
                        'favorito': false,
                        'status': 'ativo',
                        'data': Timestamp.now()
                      });
                    }
                  }
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  primary: Colors.red[800],
                ),
                child: Text('Salvar')
            )
          ],
        );
      }
  );
}

modalCreateLocal(BuildContext context, String op, QueryDocumentSnapshot<Object> doc){
  var form = GlobalKey<FormState>();
  var apelido = TextEditingController();
  var cep = TextEditingController();
  var rua = TextEditingController();
  var bairro = TextEditingController();

  return showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Adicionar Local'),
          content: Form(
            key: form,
            child: Container(
              height: MediaQuery.of(context).size.height/2,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: apelido,
                    decoration: InputDecoration(
                      hintText: 'Apelido',
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
                    controller: rua,
                    decoration: InputDecoration(
                      hintText: 'Rua',
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
                    controller: bairro,
                    decoration: InputDecoration(
                      hintText: 'Bairro',
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
                    controller: cep,
                    decoration: InputDecoration(
                      hintText: 'Cep',
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
          actions: <Widget>[
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  primary: Colors.red[800],
                ),
                child: Text('Cancelar')
            ),
            TextButton(
                onPressed: () async{
                  var endereco = await _recuperaCep(cep.text);
                  Map<String, dynamic> jsonEndereco = jsonDecode(endereco.body);
                  endereco = "Rua: ${jsonEndereco['logradouro']} \n Bairro: ${jsonEndereco['bairro']} \n Localidade: ${jsonEndereco['localidade']}";
                  print(jsonEndereco);
                  if(op == 'edit'){
                    if(form.currentState.validate())
                      doc.reference.update({
                        'apelido': apelido.text,
                        'endereco': endereco,
                      });
                  }
                  else{
                    var random = new Random();
                    if(form.currentState.validate()) {
                      await FirebaseFirestore.instance.collection('lugares').add({
                        'apelido': apelido.text,
                        'endereco': endereco,
                        'status': 'ativo',
                        'favorito': false,
                        'id': random.nextInt(1500000) + 1
                      });
                      print("PASSEI AQUI");
                      print({
                        'apelido': apelido.text,
                        'endereco': endereco
                      });
                    }
                  }
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  primary: Colors.red[800],
                ),
                child: Text('Salvar')
            )
          ],
        );
      }
  );
}

createUser(BuildContext context, String op, QueryDocumentSnapshot<Object> doc){
  var form = GlobalKey<FormState>();

  var email = TextEditingController();
  var login = TextEditingController();
  var senha = TextEditingController();

  return showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Novo Usuário'),
          content: Form(
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
                  TextFormField(
                    controller: login,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person, color: Colors.red[800], size: 22),
                      hintText: 'Login',
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
          actions: <Widget>[
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  primary: Colors.red[800],
                ),
                child: Text('Cancelar')
            ),
            TextButton(
                onPressed: () async{
                  if(op == 'edit'){
                    if(form.currentState.validate())
                      doc.reference.update({
                        'email': email.text,
                        'login': login.text,
                        'senha': senha.text,
                        'status': 'ativo'
                      });
                  }
                  else {
                    var random = new Random();
                    if (form.currentState.validate()) {
                      await FirebaseFirestore.instance.collection('usuarios')
                          .add({
                        'email': email.text,
                        'login': login.text,
                        'senha': senha.text,
                        'status': 'ativo',
                        'id': random.nextInt(1500000) + 1
                      });
                    }
                  }
                  UserCredential user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.text, password: senha.text);
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  primary: Colors.red[800],
                ),
                child: Text('Criar')
            )
          ],
        );
      }
  );
}

/*modalCreateCalendar(BuildContext context, String op, QueryDocumentSnapshot<Object> doc){
  var form = GlobalKey<FormState>();
  DateTime dataInicio = DateTime.now();
  DateTime dataFim = DateTime.now().add(Duration(days: 1));
  CalendarClient calendarClient = CalendarClient();

  TextEditingController _nomeEvento = TextEditingController();
  return showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Novo Evento'),
          content: Form(
            key: form,
            child: Container(
              height: MediaQuery.of(context).size.height/3,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      TextButton(
                          onPressed: () {
                            DatePicker.showDateTimePicker(context,
                                showTitleActions: true,
                                minTime: DateTime(2021, 1, 1),
                                maxTime: DateTime(2021, 12, 31), onChanged: (date) {
                                  print('change $date');
                                }, onConfirm: (date) {
                                  dataInicio = date;

                                  print(dataInicio);
                                }, currentTime: DateTime.now(), locale: LocaleType.en);
                          },
                          child: Text(
                            'Início',
                            style: TextStyle(color: Colors.blue),
                          )
                      ),
                      Text('${DateFormat("dd/MM/yyyy hh:mm").format(dataInicio)}'),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      TextButton(
                          onPressed: () {
                            DatePicker.showDateTimePicker(context,
                                showTitleActions: true,
                                minTime: DateTime(2021, 1, 1),
                                maxTime: DateTime(2030, 12, 31), onChanged: (date) {
                                  print('change $date');
                                }, onConfirm: (date) {

                                  dataFim = date;
                                  print(dataFim);
                                }, currentTime: DateTime.now(), locale: LocaleType.en);
                          },
                          child: Text(
                            'Fim',
                            style: TextStyle(color: Colors.blue),
                          )
                      ),
                      Text('${DateFormat("dd/MM/yyyy hh:mm").format(dataInicio)}'),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: TextField(
                      controller: _nomeEvento,
                      decoration: InputDecoration(hintText: 'Insira o nome do evento'),
                    ),
                  ),
                  /*TextFormField(
                    controller: dataInicio,
                    decoration: InputDecoration(
                      hintText: 'Início',
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
                    controller: dataFim,
                    decoration: InputDecoration(
                      hintText: 'Fim',
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
                  ),*/
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  primary: Colors.red[800],
                ),
                child: Text('Cancelar')
            ),
            TextButton(
                onPressed: (){
                  calendarClient.insert(
                    _nomeEvento.text,
                    dataInicio,
                    dataFim,
                  );
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  primary: Colors.red[800],
                ),
                child: Text('Salvar')
            )
          ],
        );
      }
  );
}*/