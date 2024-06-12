import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../controller/login_controller.dart';
import '../controller/produto_controller.dart';
import '../model/produto.dart';

class ProdutoView extends StatefulWidget {
  const ProdutoView({super.key});

  @override
  State<ProdutoView> createState() => _ProdutoViewState();
}

class _ProdutoViewState extends State<ProdutoView> {
  var txtNomeProduto = TextEditingController();
  var txtDescricaoProduto = TextEditingController();
  var txtQuantidadeProduto = TextEditingController();
  var txtPrecoProduto = TextEditingController();
  var txtCategoriaProduto = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'Lista de produtos',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.blueAccent,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
            child: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                salvarProduto(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 10, 0),
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.pushNamed(context, 'produtoSearch');
              },
            ),
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      // BODY
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: ProdutoController().listar().snapshots(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Center(
                  child: Text("Falha na conexão."),
                );
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
              default:
                final dados = snapshot.requireData;
                if (dados.size > 0) {
                  return ListView.builder(
                    itemCount: dados.size,
                    itemBuilder: (context, index) {
                      String id = dados.docs[index].id;
                      dynamic item = dados.docs[index].data();

                      return Card(
                        child: ListTile(
                          title: Text('${item['nomeProduto']}',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                              'Descrição: ${item['descricaoProduto']}\n'
                              'Quantidade: ${item['quantidadeProduto']}\n'
                              'Preço: ${item['precoProduto']}\n'
                              'Categoria: ${item['categoriaProduto']}\n'
                              'Data de Criação: ${_formatDate(item['createdAt'])}'),
                          trailing: SizedBox(
                            width: 80,
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    txtNomeProduto.text = item['nomeProduto'];
                                    txtDescricaoProduto.text =
                                        item['descricaoProduto'];
                                    txtQuantidadeProduto.text =
                                        item['quantidadeProduto'].toString();
                                    txtPrecoProduto.text =
                                        item['precoProduto'].toString();
                                    txtCategoriaProduto.text =
                                        item['categoriaProduto'];
                                    salvarProduto(context, docId: id);
                                  },
                                  icon: Icon(Icons.edit_rounded),
                                ),
                                IconButton(
                                  onPressed: () {
                                    ProdutoController().excluir(context, id);
                                  },
                                  icon: Icon(Icons.delete_rounded),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text("Nenhum produto encontrado."),
                  );
                }
            }
          },
        ),
      ),
    );
  }

  String _formatDate(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(dateTime);
  }

  void salvarProduto(context, {docId}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text((docId == null) ? "Adicionar Produto" : "Editar Produto"),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: txtNomeProduto,
                    decoration: InputDecoration(
                      labelText: 'Nome',
                      hintText: 'Digite o nome do produto',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, digite o nome do produto';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: txtDescricaoProduto,
                    decoration: InputDecoration(
                      labelText: 'Descrição',
                      hintText: 'Digite a descrição do produto',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira a descrição do produto';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: txtQuantidadeProduto,
                    decoration: InputDecoration(
                      labelText: 'Quantidade',
                      hintText: 'Digite a quantidade do produto',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          int.tryParse(value) == null) {
                        return 'Por favor, insira uma quantidade válida';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: txtPrecoProduto,
                    decoration: InputDecoration(
                      labelText: 'Preço',
                      hintText: 'Digite o preço do produto',
                    ),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          double.tryParse(value) == null) {
                        return 'Por favor, insira um preço válido';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: txtCategoriaProduto,
                    decoration: InputDecoration(
                      labelText: 'Categoria',
                      hintText: 'Digite a categoria do produto',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira a categoria do produto';
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
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
                _clearForm();
              },
            ),
            TextButton(
              child: Text('Salvar'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  var p = Produto(
                    LoginController().idUsuario(),
                    txtNomeProduto.text,
                    txtDescricaoProduto.text,
                    int.parse(txtQuantidadeProduto.text),
                    double.parse(txtPrecoProduto.text),
                    txtCategoriaProduto.text,
                    Timestamp.now(),
                  );

                  if (docId == null) {
                    ProdutoController().adicionar(context, p);
                  } else {
                    ProdutoController().atualizar(context, docId, p);
                  }
                  _clearForm();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _clearForm() {
    txtNomeProduto.clear();
    txtDescricaoProduto.clear();
    txtQuantidadeProduto.clear();
    txtPrecoProduto.clear();
    txtCategoriaProduto.clear();
  }
}
