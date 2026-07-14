import 'dart:io';

abstract class Contato {
  String nome;
  int telefone;
  String email;

  Contato({required this.nome, required this.telefone, required this.email});
  
  void imprimirContato() {
    stdout.writeln('Nome: $nome');
    stdout.writeln('Telefone: $telefone');
    stdout.writeln('Email: $email');
  }
}

class ContatoPessoal extends Contato {
    String? apelido;

  ContatoPessoal({
     required String nomePessoal,
     required int telefonePessoal,
     required String emailPessoal,
      this.apelido,
  }) : super(nome: nomePessoal, telefone: telefonePessoal, email: emailPessoal);

  @override
  void imprimirContato() {
    super.imprimirContato();
    stdout.writeln('Apelido: ${apelido ?? 'Não informado'}');

  }
}


class ContatoEmpresarial extends Contato {
  String? empresa;

  ContatoEmpresarial({
     required String nomeEmpresa,
     required int telefoneEmpresarial,
     required String emailEmpresarial,
     this.empresa,
  }) : super(nome: nomeEmpresa, telefone: telefoneEmpresarial, email: emailEmpresarial);

  @override
  void imprimirContato() {
    super.imprimirContato();
    stdout.writeln('Empresa: ${empresa ?? 'Não informada'}');

  }
}


