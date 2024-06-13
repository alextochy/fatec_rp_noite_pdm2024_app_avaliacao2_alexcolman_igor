// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../controller/login_controller.dart';
import '../controller/cliente_controller.dart';
import '../model/cliente.dart';

class ClienteView extends StatefulWidget {
  const ClienteView({super.key});

  @override
  State<ClienteView> createState() => _ClienteViewState();
}

class _ClienteViewState extends State<ClienteView> {
  var txtNomeCliente = TextEditingController();
  final _cpfFormatter = MaskTextInputFormatter(mask: '###.###.###-##');
  var txtCpfCliente = TextEditingController();
  var txtEmailCliente = TextEditingController();
  var txtTelefoneCliente = TextEditingController();
  final _dataNascimentoFormatter = MaskTextInputFormatter(mask: '##/##/####');
  var txtDataNascimentoCliente = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _formatDate(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(dateTime);
  }

  DateTime _parseDate(String date) {
    final parts = date.split('/');
    return DateTime(
      int.parse(parts[2]),
      int.parse(parts[1]),
      int.parse(parts[0]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'Lista de Clientes',
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
                salvarCliente(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 10, 0),
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.pushNamed(context, 'clienteSearch');
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
        //
        // LISTAR os(as) cliuentes
        //
        child: StreamBuilder<QuerySnapshot>(
          //fluxo de dados
          stream: ClienteController().listar().snapshots(),
          //exibição dos dados
          builder: (context, snapshot) {
            //verificar a conectividade
            switch (snapshot.connectionState) {
              //sem conexão
              case ConnectionState.none:
                return Center(
                  child: Text("Falha na conexão."),
                );

              //conexão lenta
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );

              //dados recuperados com sucesso
              default:
                final dados = snapshot.requireData;
                if (dados.size > 0) {
                  //exibir a lista de clientes
                  return ListView.builder(
                    itemCount: dados.size,
                    itemBuilder: (context, index) {
                      //ID do documento
                      String id = dados.docs[index].id;

                      //DADOS armazenados no documento
                      dynamic item = dados.docs[index].data();

                      return Card(
                        child: ListTile(
                          title: Text('${item['nomeCliente']}',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('CPF: ${item['cpfCliente']}\n'
                              'E-mail: ${item['emailCliente']}\n'
                              'Telefone: ${item['telefoneCliente']}\n'
                              'Aniversário: ${_formatDate(item['dataNascimentoCliente'])}'),
                          //
                          // Atualizar e Excluir clientes
                          //
                          trailing: SizedBox(
                            width: 80,
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    txtNomeCliente.text = item['nomeCliente'];
                                    txtCpfCliente.text = item['cpfCliente'];
                                    txtEmailCliente.text = item['emailCliente'];
                                    txtTelefoneCliente.text =
                                        item['telefoneCliente'];
                                    txtDataNascimentoCliente.text = _formatDate(
                                        item['dataNascimentoCliente']);
                                    salvarCliente(context, docId: id);
                                  },
                                  icon: Icon(Icons.edit_rounded),
                                ),
                                IconButton(
                                  onPressed: () {
                                    ClienteController().excluir(context, id);
                                  },
                                  icon: Icon(Icons.delete_rounded),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {},
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text("Nenhum(a) cliente encontrado(a)."),
                  );
                }
            }
          },
        ),
      ),
    );
  }

  //
  // ADICIONAR CLIENTE
  //
  void salvarCliente(context, {docId}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: Text((docId == null) ? "Adicionar Cliente" : "Editar Cliente"),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: txtNomeCliente,
                    decoration: InputDecoration(
                      labelText: 'Nome',
                      hintText: 'Digite o nome',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, digite o nome do cliente';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: txtCpfCliente,
                    inputFormatters: [_cpfFormatter],
                    decoration: InputDecoration(labelText: 'Número do CPF'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o número do CPF';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                      controller: txtEmailCliente,
                      decoration: InputDecoration(
                        labelText: 'E-mail',
                        hintText: 'Digite o e-mail',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira um email.';
                        }
                        const pattern = r'^[^@]+@[^@]+\.[^@]+';
                        final regExp = RegExp(pattern);

                        if (!regExp.hasMatch(value)) {
                          return 'Por favor, insira um email válido.';
                        }
                        return null;
                      }),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: txtTelefoneCliente,
                    decoration: InputDecoration(
                      labelText: 'Telefone',
                      hintText: 'Digite numero com DDD sem ()',
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !RegExp('^((1[1-9])|([2-9][0-9]))((3[0-9]{3}[0-9]{4})|(9[0-9]{3}[0-9]{5}))')
                              .hasMatch(value)) {
                        return 'Por favor, digite um telefone válido';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: txtDataNascimentoCliente,
                    inputFormatters: [_dataNascimentoFormatter],
                    decoration:
                        InputDecoration(labelText: 'Data de Nascimento'),
                    keyboardType: TextInputType.datetime,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira a data de nascimento';
                      }
                      final RegExp dateRegExp = RegExp(r'^\d{2}/\d{2}/\d{4}$');

                      if (!dateRegExp.hasMatch(value)) {
                        return 'Por favor, insira uma data válida no formato dd/mm/yyyy';
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
              child: Text("fechar"),
              onPressed: () {
                txtNomeCliente.clear();
                txtCpfCliente.clear();
                txtEmailCliente.clear();
                txtTelefoneCliente.clear();
                txtDataNascimentoCliente.clear();
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text("salvar"),
              onPressed: () {
                //criação do objeto
                if (_formKey.currentState!.validate()) {
                  var c = Cliente(
                    LoginController().idUsuario(),
                    txtNomeCliente.text,
                    txtCpfCliente.text,
                    txtEmailCliente.text,
                    txtTelefoneCliente.text,
                    Timestamp.fromDate(
                        _parseDate(txtDataNascimentoCliente.text)),
                  );

                  if (docId == null) {
                    ClienteController().adicionar(context, c);
                  } else {
                    ClienteController().atualizar(context, docId, c);
                  }

                  txtNomeCliente.clear();
                  txtCpfCliente.clear();
                  txtEmailCliente.clear();
                  txtTelefoneCliente.clear();
                  txtDataNascimentoCliente.clear();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
