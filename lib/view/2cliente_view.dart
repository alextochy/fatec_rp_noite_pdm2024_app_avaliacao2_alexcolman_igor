import 'package:flutter/material.dart';

class Cliente {
  String nome;
  DateTime dataNascimento;
  String cpf;
  String sexo;
  String telefone;

  Cliente({
    required this.nome,
    required this.dataNascimento,
    required this.cpf,
    required this.sexo,
    required this.telefone,
  });
}

class ListaClientesView extends StatelessWidget {
  final List<Cliente> clientes;
  final Function(Cliente, int) onUpdate;
  final Function(int) onDelete;

  const ListaClientesView({Key? key, required this.clientes, required this.onUpdate, required this.onDelete}) : super(key: key);

  void _editarCliente(BuildContext context, Cliente cliente, int index) {
    final nomeController = TextEditingController(text: cliente.nome);
    final dataNascimentoController = TextEditingController(text: cliente.dataNascimento.toIso8601String());
    final cpfController = TextEditingController(text: cliente.cpf);
    final sexoController = TextEditingController(text: cliente.sexo);
    final telefoneController = TextEditingController(text: cliente.telefone);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Editar Cliente'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: nomeController,
                decoration: InputDecoration(labelText: 'Nome do Cliente'),
              ),
              TextFormField(
                controller: dataNascimentoController,
                decoration: InputDecoration(labelText: 'Data de Nascimento'),
                keyboardType: TextInputType.datetime,
              ),
              TextFormField(
                controller: cpfController,
                decoration: InputDecoration(labelText: 'Número do CPF'),
              ),
              TextFormField(
                controller: sexoController,
                decoration: InputDecoration(labelText: 'Sexo'),
              ),
              TextFormField(
                controller: telefoneController,
                decoration: InputDecoration(labelText: 'Telefone'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Cliente clienteAtualizado = Cliente(
                nome: nomeController.text,
                dataNascimento: DateTime.parse(dataNascimentoController.text),
                cpf: cpfController.text,
                sexo: sexoController.text,
                telefone: telefoneController.text,
              );
              onUpdate(clienteAtualizado, index);
              Navigator.of(context).pop();
            },
            child: Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Clientes'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ClienteSearchDelegate(
                  clientes: clientes,
                  onUpdate: onUpdate,
                  onDelete: onDelete,
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(
                context,
                'cadastrarCliente',
              );
            },
          ),
        ],
      ),
      body: clientes.isEmpty
          ? Center(child: Text('Não existem clientes cadastrados'))
          : ListView.builder(
              itemCount: clientes.length,
              itemBuilder: (context, index) {
                final cliente = clientes[index];
                return ListTile(
                        title: Text(cliente.nome),
                        subtitle: Text(cliente.cpf),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                _editarCliente(context, cliente, index);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                onDelete(index);
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          _editarCliente(context, cliente, index);
                        },
                      );

              },
            ),
    );
  }
}

class CadastrarClienteView extends StatefulWidget {
  final Function(Cliente) onClienteCadastrado;

  const CadastrarClienteView({Key? key, required this.onClienteCadastrado}) : super(key: key);

  @override
  State<CadastrarClienteView> createState() => _CadastrarClienteViewState();
}

class _CadastrarClienteViewState extends State<CadastrarClienteView> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _dataNascimentoController = TextEditingController();
  final _cpfController = TextEditingController();
  final _sexoController = TextEditingController();
  final _telefoneController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _dataNascimentoController.dispose();
    _cpfController.dispose();
    _sexoController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  void _cadastrarCliente() {
    if (_formKey.currentState!.validate()) {
      Cliente novoCliente = Cliente(
        nome: _nomeController.text,
        dataNascimento: DateTime.parse(_dataNascimentoController.text),
        cpf: _cpfController.text,
        sexo: _sexoController.text,
        telefone: _telefoneController.text,
      );
      widget.onClienteCadastrado(novoCliente);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cliente cadastrado com sucesso!')),
      );
      _limparCampos();
      Navigator.pop(context); // Retorna à lista de clientes após o cadastro
    }
  }

  void _limparCampos() {
    _nomeController.clear();
    _dataNascimentoController.clear();
    _cpfController.clear();
    _sexoController.clear();
    _telefoneController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Cliente'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome do Cliente'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do cliente';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dataNascimentoController,
                decoration: InputDecoration(labelText: 'Data de Nascimento'),
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a data de nascimento';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cpfController,
                decoration: InputDecoration(labelText: 'Número do CPF'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o número do CPF';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _sexoController,
                decoration: InputDecoration(labelText: 'Sexo'),
                validator: (value) {
                  if (value == null || value.isEmpty || (value != 'M' && value != 'F')) {
                    return 'Por favor, insira o sexo (M ou F)';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _telefoneController,
                decoration: InputDecoration(labelText: 'Telefone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o telefone';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _cadastrarCliente,
                child: Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ClienteSearchDelegate extends SearchDelegate<String> {
  final List<Cliente> clientes;
  final Function(Cliente, int) onUpdate;
  final Function(int) onDelete;

  ClienteSearchDelegate({required this.clientes, required this.onUpdate, required this.onDelete});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final resultados = clientes
        .where((cliente) =>
            cliente.nome.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListaClientesView(clientes: resultados, onUpdate: onUpdate, onDelete: onDelete);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final resultados = clientes
        .where((cliente) =>
            cliente.nome.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: resultados.length,
      itemBuilder: (context, index) {
        final cliente = resultados[index];
        return ListTile(
          title: Text(cliente.nome),
          subtitle: Text(cliente.cpf),
          onTap: () {
            query = cliente.nome;
            showResults(context);
          },
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MyApp(),
    routes: {
      'cadastrarCliente': (context) => CadastrarClienteView(
            onClienteCadastrado: (cliente) {
              // Adicione o cliente à lista de clientes
            },
          ),
    },
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Cliente> _clientes = [];

  void _adicionarCliente(Cliente cliente) {
    setState(() {
      _clientes.add(cliente);
    });
  }

  void _atualizarCliente(Cliente cliente, int index) {
    setState(() {
      _clientes[index] = cliente;
    });
  }

  void _removerCliente(int index) {
    setState(() {
      _clientes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListaClientesView(
      clientes: _clientes,
      onUpdate: _atualizarCliente,
      onDelete: _removerCliente,
    );
  }
}
