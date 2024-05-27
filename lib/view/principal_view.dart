// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import '../controller/login_controller.dart';

class PrincipalView extends StatefulWidget {
  const PrincipalView({super.key});

  @override
  State<PrincipalView> createState() => _PrincipalViewState();
}

class _PrincipalViewState extends State<PrincipalView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        title: Row(
          children: [
            Expanded(
                child: Text('Inventário de Estoque',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 20))),
            FutureBuilder<String>(
              future: LoginController().usuarioLogado(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        textStyle: TextStyle(fontSize: 12),
                      ),
                      onPressed: () {
                        LoginController().logout();
                        Navigator.pushReplacementNamed(context, 'login');
                      },
                      icon: Icon(Icons.exit_to_app, size: 14),
                      label: Text(snapshot.data.toString()),
                    ),
                  );
                }
                return Text('');
              },
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
              ),
              child: Text('Perfil', style: TextStyle(color: Colors.white)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: ListTile(
                leading: Icon(Icons.info_outline),
                title: const Text('Sobre'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Sobre o App"),
                        content: Container(
                          height: 150,
                          child: Column(
                            children: [
                              const Text(
                                  'Este é um Aplicativo de Inventário de Estoque desenvolvido pelos alunos Alexcolman Apunike e Igor Henrique Lopes para a 2ª Avaliação da Disciplina: "Programação de Dispositivos Móveis" - 1ª Semestre 2024 da Fatec de Ribeirão Preto.'),
                            ],
                          ),
                        ),
                        actionsPadding: EdgeInsets.all(20),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Fechar'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: ListTile(
                leading: Icon(Icons.logout),
                title: const Text('Sair'),
                onTap: () {
                  LoginController().logout();
                  Navigator.pushReplacementNamed(context, 'login');
                  ;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
