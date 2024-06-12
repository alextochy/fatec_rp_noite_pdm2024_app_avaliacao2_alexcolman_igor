import 'package:fatec_rp_noite_pdm2024_app_avaliacao2_alexcolman_igor/view/util.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../controller/saida_controller.dart';
import '../controller/login_controller.dart';
import '../model/saida.dart';

class SaidaView extends StatefulWidget {
  const SaidaView({super.key});

  @override
  State<SaidaView> createState() => _SaidaViewState();
}

class _SaidaViewState extends State<SaidaView> {
  var txtQuantidadeProduto = TextEditingController();
  var txtObservacoes = TextEditingController();
  DateTime _dataSaida = DateTime.now();
  final _formKey = GlobalKey<FormState>();

  String? _selectedProduto;
  String? _selectedCliente;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'Saída de Produtos',
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
                salvarSaida(context);
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
          stream: SaidaController().listar().snapshots(),
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
                          subtitle: Text('Cliente: ${item['nomeCliente']}\n'
                              'Quantidade: ${item['quantidadeProduto']}\n'
                              'Faturamento: R\$ ${item['faturamento']}\n'
                              'Data de Saída: ${_formatDate(item['dataSaida'])}\n'
                              'Observações: ${item['observacoes']}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  editarSaida(context, id, item);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  excluirSaida(context, id);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text("Nenhuma saída encontrada."),
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

  void salvarSaida(BuildContext context, {String? docId}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text((docId == null) ? "Registrar Saída" : "Editar Saída"),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('produtos')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return CircularProgressIndicator();
                      var produtos = snapshot.data!.docs
                          .map((doc) => doc['nomeProduto'])
                          .toList();
                      return DropdownButtonFormField<String>(
                        value: _selectedProduto,
                        decoration:
                            InputDecoration(labelText: 'Nome do Produto'),
                        items: produtos.map((produto) {
                          return DropdownMenuItem<String>(
                            value: produto,
                            child: Text(produto),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedProduto = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, selecione o nome do produto';
                          }
                          return null;
                        },
                      );
                    },
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('clientes')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return CircularProgressIndicator();
                      var clientes = snapshot.data!.docs
                          .map((doc) => doc['nomeCliente'])
                          .toList();
                      return DropdownButtonFormField<String>(
                        value: _selectedCliente,
                        decoration:
                            InputDecoration(labelText: 'Nome do Cliente'),
                        items: clientes.map((cliente) {
                          return DropdownMenuItem<String>(
                            value: cliente,
                            child: Text(cliente),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCliente = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, selecione o nome do cliente';
                          }
                          return null;
                        },
                      );
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
                    controller: txtObservacoes,
                    decoration: InputDecoration(
                      labelText: 'Observações',
                      hintText: 'Digite observações (opcional)',
                    ),
                    maxLines:
                        3, // Increase the height of the observations field
                  ),
                  ListTile(
                    title: Text('Data de Saída'),
                    subtitle: Text(
                      DateFormat('dd/MM/yyyy').format(_dataSaida),
                    ),
                    trailing: Icon(Icons.calendar_today),
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _dataSaida,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != _dataSaida) {
                        setState(() {
                          _dataSaida = picked;
                        });
                      }
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
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    double precoProduto = await SaidaController()
                        .getPrecoProduto(_selectedProduto!);
                    double faturamento =
                        precoProduto * int.parse(txtQuantidadeProduto.text);

                    var s = Saida(
                      uid: LoginController().idUsuario(),
                      nomeProduto: _selectedProduto!,
                      nomeCliente: _selectedCliente!,
                      quantidadeProduto: int.parse(txtQuantidadeProduto.text),
                      faturamento: faturamento,
                      dataSaida: Timestamp.fromDate(_dataSaida),
                      observacoes: txtObservacoes.text,
                    );

                    if (docId == null) {
                      SaidaController().adicionar(context, s);
                    } else {
                      SaidaController().atualizar(context, docId, s);
                    }
                    _clearForm();
                  } catch (e) {
                    erro(context, 'Erro ao registrar saída: ${e.toString()}');
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  void editarSaida(BuildContext context, String id, dynamic item) {
    _selectedProduto = item['nomeProduto'];
    _selectedCliente = item['nomeCliente'];
    txtQuantidadeProduto.text = item['quantidadeProduto'].toString();
    txtObservacoes.text = item['observacoes'];
    _dataSaida = item['dataSaida'].toDate();
    salvarSaida(context, docId: id);
  }

  void excluirSaida(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Excluir Saída'),
          content: Text('Tem certeza que deseja excluir esta saída?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Excluir'),
              onPressed: () {
                SaidaController().excluir(context, id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _clearForm() {
    setState(() {
      _selectedProduto = null;
      _selectedCliente = null;
      txtQuantidadeProduto.clear();
      txtObservacoes.clear();
      _dataSaida = DateTime.now();
    });
  }
}
