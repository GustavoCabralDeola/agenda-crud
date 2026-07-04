import 'dart:io';


List<Map<String, dynamic>> listaContatos = [];



void main() {
  carregarArquivo();
  menu();
}

void menu(){
    while(true){

      print('======================== AGENDA =========================');
      stdout.writeln('Escolha uma dessas opções abaixo: ');
      stdout.writeln('1 - Adicionar  2 - Listar 3 - Editar 4 - Remover 5 - Listar por meio de arquivo 6 - Sair');
      String opcao = stdin.readLineSync()!;

      switch(opcao){
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
        case 'Listar por meio de arquivo':
        carregarArquivo();

        case '6':
        case 'Sair':
        print('Volte logo!');
        salvarArquivo();
        return;
        
      }
    }
}
      //Listagem
      void consultarContatos() {
      
          stdout.writeln('Deseja fazer a consulta de todos os contatos? Digite "S" para Sim e "N" para não');
          String desejaConsultarTodos = stdin.readLineSync()!;

          if(desejaConsultarTodos == 'S'){
            
            carregarArquivo();
            stdout.writeln(listaContatos.join('\n'));
            if(listaContatos.isEmpty){
              print('Nenhum registro encontrado');
            }


          } else if (desejaConsultarTodos == 'N') 
          { 
            stdout.writeln('Digite o que vc deseja consultar: ');
              String consultaUsuario = stdin.readLineSync()!;

             List<Map<String, dynamic>> listaFiltrada = listaContatos.where((item ){

                return item['nome'].toString().contains(consultaUsuario) ||
                       item['telefone'].toString().contains(consultaUsuario) ||
                       item['email'].toString().contains(consultaUsuario);

              }).toList();


              if (listaFiltrada.isNotEmpty){
                 stdout.writeln(listaFiltrada.join('\n'));
              } 
              else {
                print('Nenhum contato encontrado.');
              }
          }
    }
  void criarContato(){
    print('Quantos contatos tu quer adicionar?');
    int contatosAdicionar = int.parse(stdin.readLineSync()!);

    for(int i = 0; i < contatosAdicionar; i++){
        
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

      if(telefone == 0) {
         stdout.writeln('telefone não pode ser 0');
      }

      stdout.writeln('Digite o email para contato');
      String email = stdin.readLineSync()!;

      email = validaEmail(email);
      telefone = validaTelefone(telefone);

      listaContatos.add({
        'nome': nome,
        'telefone': telefone,
        'email': email,
    }); 

     print('Usuário criado com sucesso! ');
     salvarArquivo();
     continue;
    }
  }

  void editarContato() {
    
    stdout.writeln('Digite o nome do contato que você quer editar');
    String nomeContatoEditar = stdin.readLineSync()!;

      List<Map<String, dynamic>> listaFiltrada = listaContatos.where((item ){
                return item['nome'].toString().contains(nomeContatoEditar) ||
                       item['telefone'].toString().contains(nomeContatoEditar) ||
                       item['email'].toString().contains(nomeContatoEditar);
                       }).toList();
            

      stdout.writeln('Qual campo deseja alterar?');
      stdout.writeln('1 - "Nome", 2 - "Telefone", 3 - "Email"');
        String campoAlterar = stdin.readLineSync()!;

        switch(campoAlterar) {
          case 'Nome':
          case '1':
          print(listaFiltrada);
          print('Digite o novo nome: ');
          String nomeAlterar = stdin.readLineSync()!;

          listaFiltrada.first['nome'] = nomeAlterar;
          for(var contato in listaFiltrada){
              contato['nome'] = nomeAlterar;
          }

          break;

          case 'Telefone':
          case '2':
          print(listaFiltrada);
          print('Digite o novo telefone: ');
          String telefoneAlterar = stdin.readLineSync()!;

          listaFiltrada.first['telefone'] = telefoneAlterar;
          for(var contato in listaFiltrada){
              contato['telefone'] = telefoneAlterar;
          }

          break;

          case 'Email':
          case '3':
          print(listaFiltrada);
          print('Digite o novo email: ');
          String emailAlterar = stdin.readLineSync()!;

          listaFiltrada.first['nome'] = emailAlterar;
          for(var contato in listaFiltrada){
              contato['email'] = emailAlterar;
          }
          
          break;
        }
  }

void removerContato() {
  stdout.writeln('Digite o nome do contato que você deseja remover:');
  String nomeContatoRemover = stdin.readLineSync()!;

  if(!existe(nomeContatoRemover)){
    print('Esse contato não existe.');
    
  } else {

  stdout.writeln('Deseja MESMO remover? "S" = Sim e "N" = Não' );
  String decisao = stdin.readLineSync()!;

    if(decisao == 'S'){
      listaContatos.removeWhere((item) {
        return item['nome'].toString().contains(nomeContatoRemover) ||
               item['telefone'].toString().contains(nomeContatoRemover) ||
               item['email'].toString().contains(nomeContatoRemover);
        });
      print('Contato removido com sucesso!');
    }
  }

}

carregarArquivo() {
  final List<String> linhas = File('file.txt').readAsLinesSync();
  for (int i = 0; i < linhas.length; i++) {
    final List<String> campos = linhas[i].split(';');
    if (campos.length == 3) {

       listaContatos.add({
        'nome': campos[0],
        'telefone': campos[1],
        'email': campos[2],
    });
    }
  }
}
 
salvarArquivo() {
  final List<String> linhas = [];
  for (int i = 0; i < listaContatos.length; i++) {
    linhas.add(
      '${listaContatos[i]['nome']} |'
      '${listaContatos[i]['telefone']} |'
      '${listaContatos[i]['email']} |'
    
    );
  }
  File('file.txt').writeAsStringSync(linhas.join('\n'));
  print('Arquivo salvo com sucesso!');
}

    //Auxiliares
   String validaEmail(String email) {
  //String email = '';
  bool emailValido = false;
 
  while (!emailValido) { 
    if (!RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email)) {
      print('E-mail inválido');
      continue;
    }
    emailValido = true;
  }
  return email;
}

int validaTelefone(int telefone) {
  //String email = '';
  var telefoneTexto = telefone.toString();
  bool telefoneValido = false;
 
  while (!telefoneValido) { 
    if (!RegExp(
      r'^\d{10,11}$',
    ).hasMatch(telefoneTexto)) {
      print('Telefone inválido');
      continue;
    }
    telefoneValido = true;
  }
  return telefone;
}

bool existe(String nome){
 return listaContatos.any((item) => item['nome'] == nome);
}







