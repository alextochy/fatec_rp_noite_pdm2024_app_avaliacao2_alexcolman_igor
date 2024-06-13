// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import '../controller/login_controller.dart';

class PrincipalView extends StatefulWidget {
  const PrincipalView({Key? key}) : super(key: key);

  @override
  State<PrincipalView> createState() => _PrincipalViewState();
}

class _PrincipalViewState extends State<PrincipalView> {
  late Future<String> _futureUsuario;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() {
    setState(() {
      _futureUsuario = LoginController().usuarioLogado();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
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
                      fontSize: 20)),
            ),
            FutureBuilder<String>(
              future: _futureUsuario,
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
            FutureBuilder<String>(
              future: _futureUsuario,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                    ),
                    accountName: Text(snapshot.data.toString(),
                        style: TextStyle(color: Colors.white)),
                    accountEmail: Text(''),
                  );
                }
                return DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                  ),
                  child: Text('Carregando...',
                      style: TextStyle(color: Colors.white)),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: ListTile(
                leading: Icon(Icons.account_circle_outlined),
                title: const Text('Editar Perfil'),
                onTap: () {
                  Navigator.pushNamed(context, 'editarPerfil').then((_) {
                    _loadUser();
                  });
                },
              ),
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
                },
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          children: [
            IconButtonWidget(
              icon: Icons.category,
              label: 'Produtos',
              onTap: () {
                Navigator.pushNamed(context, 'produto');
              },
            ),
            IconButtonWidget(
              icon: Icons.face,
              label: 'Clientes',
              onTap: () {
                Navigator.pushNamed(context, 'cliente');
              },
            ),
            IconButtonWidget(
              icon: Icons.local_shipping_outlined,
              label: 'Saída',
              onTap: () {
                Navigator.pushNamed(context, 'saida');
              },
            ),
            IconButtonWidget(
              icon: Icons.calendar_today,
              label: 'Agenda',
              onTap: () {
                Navigator.pushNamed(context, 'agenda');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class IconButtonWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const IconButtonWidget({
    required this.icon,
    required this.label,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50.0, color: Colors.blueAccent),
            SizedBox(height: 10),
            Text(label,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
