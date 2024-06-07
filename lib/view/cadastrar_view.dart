// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../controller/login_controller.dart';

import '../controller/usuario_controller.dart';
import '../model/usuario.dart';

class CadastrarView extends StatefulWidget {
  const CadastrarView({super.key});

  static const String _title = 'Alexcolman & Igor Henrique';

  @override
  State<CadastrarView> createState() => _CadastrarViewState();
}

class _CadastrarViewState extends State<CadastrarView> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController txtNome = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtSenha = TextEditingController();
  TextEditingController txtConfirmarSenha = TextEditingController();
  TextEditingController txtNomeEmpresa = TextEditingController();
  TextEditingController txtEnderecoEmpresa = TextEditingController();
  TextEditingController txtTelefone = TextEditingController();
  String _funcaoEmpresa = 'Dono';

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
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextFormField(
                      controller: txtNomeEmpresa,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.business),
                        border: OutlineInputBorder(),
                        labelText: 'Nome da Empresa',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira o nome da empresa';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextFormField(
                      controller: txtEnderecoEmpresa,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.location_on),
                        border: OutlineInputBorder(),
                        labelText: 'Endereço da Empresa',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira o endereço da empresa';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: DropdownButtonFormField<String>(
                      value: _funcaoEmpresa,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.work),
                        border: OutlineInputBorder(),
                        labelText: 'Função na Empresa',
                      ),
                      items: ['Dono', 'Gerente', 'Funcionario']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _funcaoEmpresa = newValue!;
                        });
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextFormField(
                      controller: txtTelefone,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(),
                        labelText: 'Telefone',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira seu telefone';
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
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            User? user = await LoginController().criarConta(
                              context,
                              txtNome.text.trim(),
                              txtEmail.text.trim(),
                              txtSenha.text.trim(),
                            );
                            if (user != null) {
                              var u = Usuario(
                                user.uid,
                                txtNome.text.trim(),
                                txtEmail.text.trim(),
                                txtSenha.text.trim(),
                                txtNomeEmpresa.text.trim(),
                                txtEnderecoEmpresa.text.trim(),
                                _funcaoEmpresa,
                                txtTelefone.text.trim(),
                              );
                              UsuarioController().adicionar(context, u);
                            }
                          }
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
