// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../controller/login_controller.dart';

class CadastrarView extends StatefulWidget {
  const CadastrarView({super.key});

  static const String _title = 'Alexcolman & Igor Henrique';

  @override
  State<CadastrarView> createState() => _CadastrarViewState();
}

class _CadastrarViewState extends State<CadastrarView> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtSenha = TextEditingController();
  TextEditingController txtConfirmarSenha = TextEditingController();
  TextEditingController txtNome = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(CadastrarView._title),
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        'App de Inventário de Estoque',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                            fontSize: 24),
                      )),
                  Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        'Cadastro',
                        style: TextStyle(fontSize: 20),
                      )),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextFormField(
                      controller: txtNome,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                        labelText: 'Nome',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira seu nome';
                        }
                        if (value.length < 3) {
                          return 'O nome deve ter pelo menos 3 caracteres.';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextFormField(
                      controller: txtEmail,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira seu email';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextFormField(
                      obscureText: true,
                      controller: txtSenha,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.password),
                        border: OutlineInputBorder(),
                        labelText: 'Senha',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira sua senha';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextFormField(
                      obscureText: true,
                      controller: txtConfirmarSenha,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.password),
                        border: OutlineInputBorder(),
                        labelText: 'Confirmar Senha',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, confirme sua senha.';
                        }
                        if (value != txtSenha.text) {
                          return 'As senhas não coincidem.';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('voltar'),
                      ),
                      ElevatedButton(
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(140, 40),
                        ),
                        onPressed: () {
                          _formKey.currentState!.validate();
                          LoginController().criarConta(
                            context,
                            txtNome.text,
                            txtEmail.text,
                            txtSenha.text,
                          );
                        },
                        child: Text('cadastrar'),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                ],
              ))),
    );
  }
}
