import 'dart:io';

import 'contato.dart';

class Agenda {
  List<Contato> _listaContatos = [];
  List<String> _listaHistorico = [];



  // ==========================================================
  //                         MENU
  // ==========================================================

  void menu() {
    while (true) {
      print('======================== AGENDA =========================');
      stdout.writeln('Escolha uma dessas opções abaixo: ');
      stdout.writeln(
        '1 - Adicionar  2 - Listar 3 - Editar 4 - Remover 5 - Listar histórico 6 - Sair',
      );
      String opcao = stdin.readLineSync()!;

      switch (opcao) {
        case '1':
        case 'Adicionar':
          criarContato();
          break;

        case '2':
        case 'Listar':
          consultarContatos();
          break;

        case '3':
        case 'Editar':
          editarContato();
          break;

        case '4':
        case 'Remover':
          removerContato();
          break;

        case '5':
        case 'Listar histórico':
          historico();
          break;

        case '6':
        case 'Sair':
          print('Volte logo!');
          salvarArquivo();
          return;
      }
    }
  }
 // ==========================================================
  //                          CRUD
  // ==========================================================
  //Listagem
  //// READ
  void consultarContatos() {
 
      stdout.writeln(
        'Deseja fazer a consulta de todos os contatos? Digite "S" para Sim e "N" para não',
      );
    String desejaConsultarTodos = stdin.readLineSync()!;

    if (desejaConsultarTodos == 'S') {
      carregarArquivo();

      _listaContatos.forEach((contato) {
        contato.imprimirContato();  
      });

      if (_listaContatos.isEmpty) {
        print('Nenhum registro encontrado');
      }
    } else if (desejaConsultarTodos == 'N') {
      stdout.writeln('Digite o que vc deseja consultar: ');
      String consultaUsuario = stdin.readLineSync()!;

      List<Contato> listaFiltrada = _listaContatos.where((item) {
        return item.nome.contains(consultaUsuario) ||
            item.telefone.toString().contains(consultaUsuario) ||
            item.email.contains(consultaUsuario);
      }).toList();

      if (listaFiltrada.isNotEmpty) {
        stdout.writeln(listaFiltrada.join('\n'));
      } else {
        print('Nenhum contato encontrado.');
      }
    }
  }

  // CREATE
  void criarContato() {
      print('Quantos contatos você quer adicionar?');
      String entrada = stdin.readLineSync()!;
      int? contatosAdicionar = int.tryParse(entrada);

      if (contatosAdicionar == 0 || contatosAdicionar == null) {
        print('Número de contatos inválido, tente novamente.');
        return;
      }

      for (int i = 0; i < contatosAdicionar; i++) {
        stdout.writeln('Digite o nome do contato: ');
        String nome = stdin.readLineSync()!;
        if (nome.isEmpty) {
          stdout.writeln('Nome do contato requerido!');
          continue;
        }

        if (existe(nome)) {
          print('Nome já existe, tente outro.');
          continue;
        }

        stdout.writeln('Digite o telefone para contato');
        int telefone = int.parse(stdin.readLineSync()!);

        validaTelefone(telefone);

        stdout.writeln('Digite o email para contato');
        String email = stdin.readLineSync()!;

        validaEmail(email);

        stdout.writeln('Digite o tipo de contato: "P" = Pessoal e "E" = Empresarial');
        String tipoContato = stdin.readLineSync()!;

        

        if (tipoContato == 'P') {

            stdout.writeln('Deseja colocar um apelido no contato? (opcional): ');
            String? apelido = stdin.readLineSync();

          _listaContatos.add(
            ContatoPessoal(
              nomePessoal: nome,
              telefonePessoal: telefone,
              emailPessoal: email,
              apelido: apelido ?? '',
            ),


          );
        } else if (tipoContato == 'E') {

          stdout.writeln("Deseja colocar uma empresa no contato? (opcional): ");
          String? empresa = stdin.readLineSync();

          _listaContatos.add(
            ContatoEmpresarial(
              nomeEmpresa: nome,
              telefoneEmpresarial: telefone,
              emailEmpresarial: email,
              empresa: empresa ??'',
            ),
          );
        } else {
          print('Tipo de contato inválido.');
          continue;
        }

        print('Contato criado com sucesso! ');
        salvarArquivo();
        continue;
      }
    }

   // UPDATE
   void editarContato() {
        stdout.writeln('Digite o nome do contato que você quer editar');
        String nomeContatoEditar = stdin.readLineSync()!;

        List<Contato> listaFiltrada = _listaContatos.where((item) {
          return item.nome.contains(nomeContatoEditar) ||
              item.telefone.toString().contains(nomeContatoEditar) ||
              item.email.contains(nomeContatoEditar);
        }).toList();

        if (listaFiltrada.isEmpty) {
          print('Nenhum contato encontrado.');
          return;
        }

        stdout.writeln('Qual campo deseja alterar?');
        stdout.writeln('1 - "Nome", 2 - "Telefone", 3 - "Email", 4 - "Apelido", 5 - "Empresa"');
        String campoAlterar = stdin.readLineSync()!;

        if (listaFiltrada.first is ContatoPessoal &&
          !['1', '2', '3', '4', 'Nome', 'Telefone','Email','Apelido'].contains(campoAlterar)) {
            if (campoAlterar == '5' || campoAlterar == 'Empresa') {
              print('Opção inválida. Contato pessoal não possui empresa.');
              return;
            }

          print('Opção inválida.');
          return;
        }

        else if (listaFiltrada.first is ContatoEmpresarial &&
          !['1', '2', '3', '5', 'Nome', 'Telefone','Email','Empresa'].contains(campoAlterar)) {
            if (campoAlterar == '4' || campoAlterar == 'Apelido') {
              print('Opção inválida. Contato empresarial não possui apelido.');
              return;
            }
          print('Opção inválida.');
          return;
        
        } 

        switch (campoAlterar) {
          case 'Nome':
          case '1':
            print(listaFiltrada);
            print('Digite o novo nome: ');
            String nomeAlterar = stdin.readLineSync()!;

            listaFiltrada.first.nome = nomeAlterar;
            for (var contato in listaFiltrada) {
              contato.nome = nomeAlterar;
            }

            break;

          case 'Telefone':
          case '2':
            print(listaFiltrada);
            print('Digite o novo telefone: ');
            int telefoneAlterar = int.tryParse(stdin.readLineSync()!)!;

            validaTelefone(telefoneAlterar);

            listaFiltrada.first.telefone = telefoneAlterar;
            for (var contato in listaFiltrada) {
              contato.telefone = telefoneAlterar;
            }

            break;

          case 'Email':
          case '3':
            print(listaFiltrada);
            print('Digite o novo email: ');
            String emailAlterar = stdin.readLineSync()!;
            validaEmail(emailAlterar);

            listaFiltrada.first.email = emailAlterar;
            for (var contato in listaFiltrada) {
              contato.email = emailAlterar;
            }

            break;

            case 'Apelido':
            case '4':
            print(listaFiltrada);
            print('Digite o novo apelido: ');
            String apelidoAlterar = stdin.readLineSync()!;

             (listaFiltrada.first as ContatoPessoal).apelido = apelidoAlterar;
            for (var contato in listaFiltrada) {
              if (contato is ContatoPessoal) {
                contato.apelido = apelidoAlterar;
              }
            }

          case 'Empresa':
          case '5':
            print(listaFiltrada);
            print('Digite o novo nome da empresa: ');
            String empresaAlterar = stdin.readLineSync()!;
        
        (listaFiltrada.first as ContatoEmpresarial).empresa = empresaAlterar;
            for (var contato in listaFiltrada) {
              if (contato is ContatoEmpresarial) {
                contato.empresa = empresaAlterar;
              }
            }
        }
      }

// DELETE
      void removerContato() {
        stdout.writeln('Digite o nome do contato que você deseja remover:');
        String nomeContatoRemover = stdin.readLineSync()!;

        if (!existe(nomeContatoRemover)) {
          print('Esse contato não existe.');
        } else {
          stdout.writeln('Deseja MESMO remover? "S" = Sim e "N" = Não');
          String decisao = stdin.readLineSync()!;

          if (decisao == 'S') {
            _listaContatos.removeWhere((item) {
              return item.nome.contains(nomeContatoRemover) ||
                  item.telefone.toString().contains(nomeContatoRemover) ||
                  item.email.contains(nomeContatoRemover);
            });
            print('Contato removido com sucesso!');
          }
        }
      }

  // ==========================================================
  //                      HISTÓRICO
  // ==========================================================
  void historico() {
    if (_listaContatos.isEmpty) {
      print('Não pussui contatos a ser listados.');
      return menu();
    }
    for (int i = 0; i < _listaContatos.length; ++i) {
      _listaContatos[i].imprimirContato();
      print('-----------------------------------');
    }
    return menu();
  }

  // ==========================================================
  //                      ARQUIVOS
  // ==========================================================

void carregarArquivo() {
        final List<String> linhas = File('file.txt').readAsLinesSync();
        for (int i = 0; i < linhas.length; i++) {
          final List<String> campos = linhas[i].split('|');
          if (campos.length == 3) {
            if (_listaContatos is List<ContatoPessoal>) {
              _listaContatos.add(
                ContatoPessoal(
                  nomePessoal: campos[0].trim(),
                  telefonePessoal: int.parse(campos[1].trim()),
                  emailPessoal: campos[2].trim(),
                  apelido: campos.length > 3 ? campos[3].trim() : null
                ),
              );
            } else if (_listaContatos is List<ContatoEmpresarial>) {
              _listaContatos.add(
                ContatoEmpresarial(
                  nomeEmpresa: campos[0].trim(),
                  telefoneEmpresarial: int.parse(campos[1].trim()),
                  emailEmpresarial: campos[2].trim(),
                  empresa: campos.length > 3 ? campos[3].trim() : null,
                ),
              );
            }
          }
        }
      }

    void salvarArquivo() {
    final List<String> linhas = [];
    for (int i = 0; i < _listaContatos.length; i++) {
      linhas.add(
        '${_listaContatos[i].nome} |'
        '${_listaContatos[i].telefone} |'
        '${_listaContatos[i].email} |',
      );
    }
    File('file.txt').writeAsStringSync(linhas.join('\n'));
    print('Arquivo salvo com sucesso!');
  }

  // ==========================================================
  //                    AUXILIARES
  // ==========================================================

  String validaEmail(String email) {
  while (true) {
    if (RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email)) {
      return email;
    }

    print('E-mail inválido. Digite novamente:');
    email = stdin.readLineSync()!;
  }
}

  int validaTelefone(int telefone) {
    var telefoneTexto = telefone.toString();

    while (true) {
      if (RegExp(r'^\d{10,11}$').hasMatch(telefoneTexto)) {
          return int.parse(telefoneTexto);  
      }
        print('Telefone inválido. Digite novamente:');
        telefoneTexto = stdin.readLineSync()!; 
    }
  }

  bool existe(String nome) {
    return _listaContatos.any((item) => item.nome == nome);
  }
}

