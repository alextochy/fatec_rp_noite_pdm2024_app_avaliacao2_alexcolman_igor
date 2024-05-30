class Usuario {
  final String uid;
  final String nome;
  final String email;
  final String senha;
  final String nomeEmpresa;
  final String enderecoEmpresa;
  final String funcaoEmpresa;
  final String telefone;

  Usuario(
    this.uid,
    this.nome,
    this.email,
    this.senha,
    this.nomeEmpresa,
    this.enderecoEmpresa,
    this.funcaoEmpresa,
    this.telefone,
  );

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uid': uid,
      'nome': nome,
      'email': email,
      'senha': senha,
      'nomeEmpresa': nomeEmpresa,
      'enderecoEmpresa': enderecoEmpresa,
      'funcaoEmpresa': funcaoEmpresa,
      'telefone': telefone,
    };
  }

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      json['uid'],
      json['nome'],
      json['email'],
      json['senha'],
      json['nomeEmpresa'],
      json['enderecoEmpresa'],
      json['funcaoEmpresa'],
      json['telefone'],
    );
  }
}
