// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../controller/login_controller.dart';
import '../controller/cliente_controller.dart';
import '../model/cliente.dart';

class ClienteSearchView extends StatefulWidget {
  const ClienteSearchView({super.key});

  @override
  State<ClienteSearchView> createState() => _ClienteSearchViewState();
}

class _ClienteSearchViewState extends State<ClienteSearchView> {
  var txtSearchTerm = TextEditingController();
  String _sortField = 'nomeCliente';
  bool _isAscending = true;
  late Stream<QuerySnapshot> _clientesStream;

  @override
  void initState() {
    super.initState();
    _clientesStream = ClienteController().listar().snapshots();
    txtSearchTerm.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    txtSearchTerm.removeListener(_onSearchChanged);
    txtSearchTerm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Pesquisar Clientes',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextFormField(
              controller: txtSearchTerm,
              decoration: InputDecoration(
                labelText: 'Pesquisar Clientes',
                hintText: 'Digite um termo de pesquisa',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: _sortField,
                  items: [
                    DropdownMenuItem(
                      value: 'nomeCliente',
                      child: Text('Nome (Ordem Alfabética)'),
                    ),
                    DropdownMenuItem(
                      value: 'dataNascimentoCliente',
                      child: Text('Data de Nascimento'),
                    ),
                    DropdownMenuItem(
                      value: 'createdAt',
                      child: Text('Data de Criação'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _sortField = value!;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(
                    _isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                  ),
                  onPressed: () {
                    setState(() {
                      _isAscending = !_isAscending;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _clientesStream,
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
                      if (txtSearchTerm.text.isEmpty) {
                        return Center(
                          child: Text(
                              "Nenhum cliente encontrado.\nDigite um termo de pesquisa."),
                        );
                      }

                      final dados = snapshot.requireData;
                      var searchTerm = txtSearchTerm.text.toLowerCase();
                      var filteredDocs = dados.docs.where((doc) {
                        var item = doc.data() as Map<String, dynamic>;
                        var nome =
                            item['nomeCliente']?.toString().toLowerCase() ?? '';
                        var cpf =
                            item['cpfCliente']?.toString().toLowerCase() ?? '';
                        var email =
                            item['emailCliente']?.toString().toLowerCase() ??
                                '';
                        var telefone =
                            item['telefoneCliente']?.toString().toLowerCase() ??
                                '';
                        return nome.startsWith(searchTerm) ||
                            cpf.startsWith(searchTerm) ||
                            email.startsWith(searchTerm) ||
                            telefone.startsWith(searchTerm);
                      }).toList();

                      filteredDocs.sort((a, b) {
                        var aValue =
                            (a.data() as Map<String, dynamic>)[_sortField];
                        var bValue =
                            (b.data() as Map<String, dynamic>)[_sortField];
                        if (aValue is Timestamp) aValue = aValue.toDate();
                        if (bValue is Timestamp) bValue = bValue.toDate();
                        if (aValue is String && bValue is String) {
                          return _isAscending
                              ? aValue.compareTo(bValue)
                              : bValue.compareTo(aValue);
                        }
                        if (aValue is DateTime && bValue is DateTime) {
                          return _isAscending
                              ? aValue.compareTo(bValue)
                              : bValue.compareTo(aValue);
                        }
                        return 0;
                      });

                      if (filteredDocs.isNotEmpty) {
                        return ListView.builder(
                          itemCount: filteredDocs.length,
                          itemBuilder: (context, index) {
                            String id = filteredDocs[index].id;
                            dynamic item = filteredDocs[index].data()
                                as Map<String, dynamic>;
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 3,
                              margin: EdgeInsets.symmetric(vertical: 5.0),
                              child: ListTile(
                                title: Text(
                                  '${item['nomeCliente']}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                                subtitle: Text(
                                  'CPF: ${item['cpfCliente']}\n'
                                  'E-mail: ${item['emailCliente']}\n'
                                  'Telefone: ${item['telefoneCliente']}\n'
                                  'Aniversário: ${_formatDate(item['dataNascimentoCliente'])}',
                                  style: TextStyle(height: 1.5),
                                ),
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
          ],
        ),
      ),
    );
  }

  String _formatDate(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(dateTime);
  }
}
