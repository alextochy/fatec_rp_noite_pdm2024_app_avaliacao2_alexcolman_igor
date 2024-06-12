// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controller/login_controller.dart';
import '../controller/usuario_controller.dart'; // Importe o UsuarioController aqui

class EditarPerfilView extends StatefulWidget {
  const EditarPerfilView({Key? key}) : super(key: key);

  @override
  _EditarPerfilViewState createState() => _EditarPerfilViewState();
}

class _EditarPerfilViewState extends State<EditarPerfilView> {
  final TextEditingController _nomeUsuarioController = TextEditingController();
  final TextEditingController _nomeEmpresaController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();

  String _funcaoSelecionada = 'Dono'; // Valor padrão

  @override
  void initState() {
    super.initState();
    _carregarDadosUsuario();
  }

  void _carregarDadosUsuario() {
    UsuarioController()
        .obterDadosUsuario(LoginController().idUsuario())
        .then((dadosUsuario) {
      if (dadosUsuario != null) {
        setState(() {
          _nomeUsuarioController.text = dadosUsuario['nome'];
          _nomeEmpresaController.text = dadosUsuario['nomeEmpresa'];
          _enderecoController.text = dadosUsuario['enderecoEmpresa'];
          _funcaoSelecionada = dadosUsuario['funcaoEmpresa'];
          _telefoneController.text = dadosUsuario['telefone'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Editar Perfil', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Nome do Usuário', _nomeUsuarioController,
                  'Digite o nome do usuário'),
              SizedBox(height: 20),
              _buildTextField('Nome da Empresa', _nomeEmpresaController,
                  'Digite o nome da empresa'),
              SizedBox(height: 20),
              _buildTextField('Endereço da Empresa', _enderecoController,
                  'Digite o endereço da empresa'),
              SizedBox(height: 20),
              Text(
                'Função na Empresa',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField(
                value: _funcaoSelecionada,
                items: ['Dono', 'Gerente', 'Funcionario'].map((funcao) {
                  return DropdownMenuItem(
                    value: funcao,
                    child: Text(funcao),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _funcaoSelecionada = newValue!;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              _buildTextField('Telefone', _telefoneController,
                  'Digite o telefone da empresa'),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Sair sem Alterações'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      UsuarioController().atualizar(
                        context,
                        LoginController().idUsuario(),
                        {
                          'nome': _nomeUsuarioController.text,
                          'nomeEmpresa': _nomeEmpresaController.text,
                          'enderecoEmpresa': _enderecoController.text,
                          'funcaoEmpresa': _funcaoSelecionada,
                          'telefone': _telefoneController.text,
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      'Salvar Alterações',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, String hintText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ],
    );
  }
}
