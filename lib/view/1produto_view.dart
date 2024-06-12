import 'package:flutter/material.dart';

class Produto {
  String nome;
  String descricao;
  int quantidade;
  double preco;
  String categoria;

  Produto({
    required this.nome,
    required this.descricao,
    required this.quantidade,
    required this.preco,
    required this.categoria,
  });
}

class ListaProdutosView extends StatelessWidget {
  final List<Produto> produtos;
  final Function(Produto, int) onUpdate;
  final Function(int) onDelete;

  const ListaProdutosView({Key? key, required this.produtos, required this.onUpdate, required this.onDelete}) : super(key: key);

  void _editarProduto(BuildContext context, Produto produto, int index) {
    final nomeController = TextEditingController(text: produto.nome);
    final descricaoController = TextEditingController(text: produto.descricao);
    final quantidadeController = TextEditingController(text: produto.quantidade.toString());
    final precoController = TextEditingController(text: produto.preco.toString());
    final categoriaController = TextEditingController(text: produto.categoria);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Editar Produto'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: nomeController,
                decoration: InputDecoration(labelText: 'Nome do Produto'),
              ),
              TextFormField(
                controller: descricaoController,
                decoration: InputDecoration(labelText: 'Descrição'),
              ),
              TextFormField(
                controller: quantidadeController,
                decoration: InputDecoration(labelText: 'Quantidade'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: precoController,
                decoration: InputDecoration(labelText: 'Preço'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: categoriaController,
                decoration: InputDecoration(labelText: 'Categoria'),
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
              Produto produtoAtualizado = Produto(
                nome: nomeController.text,
                descricao: descricaoController.text,
                quantidade: int.parse(quantidadeController.text),
                preco: double.parse(precoController.text),
                categoria: categoriaController.text,
              );
              onUpdate(produtoAtualizado, index);
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
        title: Text('Lista de Produtos'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProdutoSearchDelegate(
                  produtos: produtos,
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
                'cadastrarProduto',
              );
            },
          ),
        ],
      ),
      body: produtos.isEmpty
          ? Center(child: Text('Não existem produtos cadastrados'))
          : ListView.builder(
              itemCount: produtos.length,
              itemBuilder: (context, index) {
                final produto = produtos[index];
                return ListTile(
                        title: Text(produto.nome),
                        subtitle: Text(produto.descricao),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                _editarProduto(context, produto, index);
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
                          _editarProduto(context, produto, index);
                        },
                      );

              },
            ),
    );
  }
}

class CadastrarProdutoView extends StatefulWidget {
  final Function(Produto) onProdutoCadastrado;

  const CadastrarProdutoView({Key? key, required this.onProdutoCadastrado}) : super(key: key);

  @override
  State<CadastrarProdutoView> createState() => _CadastrarProdutoViewState();
}

class _CadastrarProdutoViewState extends State<CadastrarProdutoView> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _quantidadeController = TextEditingController();
  final _precoController = TextEditingController();
  final _categoriaController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _quantidadeController.dispose();
    _precoController.dispose();
    _categoriaController.dispose();
    super.dispose();
  }

  void _cadastrarProduto() {
    if (_formKey.currentState!.validate()) {
      Produto novoProduto = Produto(
        nome: _nomeController.text,
        descricao: _descricaoController.text,
        quantidade: int.parse(_quantidadeController.text),
        preco: double.parse(_precoController.text),
        categoria: _categoriaController.text,
      );
      widget.onProdutoCadastrado(novoProduto);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Produto cadastrado com sucesso!')),
      );
      _limparCampos();
      Navigator.pop(context); // Retorna à lista de produtos após o cadastro
    }
  }

  void _limparCampos() {
    _nomeController.clear();
    _descricaoController.clear();
    _quantidadeController.clear();
    _precoController.clear();
    _categoriaController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Produto'),
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
                decoration: InputDecoration(labelText: 'Nome do Produto'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do produto';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descricaoController,
                decoration: InputDecoration(labelText: 'Descrição'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a descrição';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantidadeController,
                decoration: InputDecoration(labelText: 'Quantidade'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a quantidade';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _precoController,
                decoration: InputDecoration(labelText: 'Preço'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o preço';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _categoriaController,
                decoration: InputDecoration(labelText: 'Categoria'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a categoria';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _cadastrarProduto,
                child: Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProdutoSearchDelegate extends SearchDelegate<String> {
  final List<Produto> produtos;
  final Function(Produto, int) onUpdate;
  final Function(int) onDelete;

  ProdutoSearchDelegate({required this.produtos, required this.onUpdate, required this.onDelete});

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
    final resultados = produtos
        .where((produto) =>
            produto.nome.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListaProdutosView(produtos: resultados, onUpdate: onUpdate, onDelete: onDelete);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final resultados = produtos
        .where((produto) =>
            produto.nome.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: resultados.length,
      itemBuilder: (context, index) {
        final produto = resultados[index];
        return ListTile(
          title: Text(produto.nome),
          subtitle: Text(produto.descricao),
          onTap: () {
            query = produto.nome;
            showResults(context);
          },
        );
      },
    );
  }
}
