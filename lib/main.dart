// ignore_for_file: prefer_const_constructors

import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

import 'view/cadastrar_view.dart';
import 'view/login_view.dart';
import 'view/principal_view.dart';
import 'view/1produto_view.dart';
import 'view/2cliente_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  List<Produto> produtos = [];
  List<Cliente> clientes = [];

  void _atualizarProduto(Produto produto, int index) {
    setState(() {
      produtos[index] = produto;
    });
  }

  void _deletarProduto(int index) {
    setState(() {
      produtos.removeAt(index);
    });
  }

  void _adicionarProduto(Produto produto) {
    setState(() {
      produtos.add(produto);
    });
  }

  void _atualizarCliente(Cliente cliente, int index) {
    setState(() {
      clientes[index] = cliente;
    });
  }

  void _deletarCliente(int index) {
    setState(() {
      clientes.removeAt(index);
    });
  }

  void _adicionarCliente(Cliente cliente) {
    setState(() {
      clientes.add(cliente);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inventário',
      initialRoute: 'login',
      routes: {
        'login': (context) => LoginView(),
        'cadastrar': (context) => CadastrarView(),
        'principal': (context) => PrincipalView(),
        'cliente': (context) => ListaClientesView(
              clientes: clientes,
              onUpdate: _atualizarCliente,
              onDelete: _deletarCliente,
            ),
        'produto': (context) => ListaProdutosView(
              produtos: produtos,
              onUpdate: _atualizarProduto,
              onDelete: _deletarProduto,
            ),
        'cadastrarProduto': (context) => CadastrarProdutoView(
              onProdutoCadastrado: _adicionarProduto,
            ),
        'cadastrarCliente': (context) => CadastrarClienteView(
              onClienteCadastrado: _adicionarCliente,
            ),
      },
    );
  }
}
