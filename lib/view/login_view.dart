// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, prefer_final_fields

import 'package:flutter/material.dart';

import '../controller/login_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  static const String _title = 'Alexcolman & Igor Henrique';

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtSenha = TextEditingController();
  TextEditingController txtEmailEsqueceuSenha = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(LoginView._title),
          automaticallyImplyLeading: false,
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
                        'Login',
                        style: TextStyle(fontSize: 20),
                      )),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: txtEmail,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.login),
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
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: TextFormField(
                      obscureText: _obscurePassword,
                      controller: txtSenha,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.lock),
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
                  SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Row(
                      children: [
                        Checkbox(
                          value: !_obscurePassword,
                          onChanged: (bool? newValue) {
                            setState(() {
                              _obscurePassword = !newValue!;
                            });
                          },
                          activeColor: Colors.blue,
                        ),
                        Text(
                          "Mostrar senha",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Align(
                    child: TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Esqueceu a senha?"),
                              content: Container(
                                height: 150,
                                child: Column(
                                  children: [
                                    Text(
                                      "Identifique-se para receber um e-mail com as instruções e o link para criar uma nova senha.",
                                    ),
                                    SizedBox(height: 25),
                                    TextField(
                                      controller: txtEmailEsqueceuSenha,
                                      decoration: InputDecoration(
                                        labelText: 'Email',
                                        prefixIcon: Icon(Icons.email),
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              actionsPadding: EdgeInsets.all(20),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('cancelar'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    LoginController().esqueceuSenha(
                                      context,
                                      txtEmailEsqueceuSenha.text,
                                    );

                                    Navigator.pop(context);
                                  },
                                  child: Text('enviar'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text('Esqueci minha senha'),
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                      child: ElevatedButton(
                        child: const Text('Login'),
                        onPressed: () {
                          _formKey.currentState!.validate();
                          LoginController().login(
                            context,
                            txtEmail.text,
                            txtSenha.text,
                          );
                        },
                      )),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text('Não possui uma conta?'),
                      TextButton(
                        child: const Text(
                          'Cadastrar',
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, 'cadastrar');
                        },
                      )
                    ],
                  ),
                ],
              ),
            )));
  }
}
