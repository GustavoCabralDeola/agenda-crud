# Agenda CRUD

Este projeto é uma agenda simples desenvolvida em Dart, construída como um aplicativo de console para gerenciar contatos.

## Descrição

O sistema permite adicionar, listar, editar e remover contatos. Cada contato possui:
- nome
- telefone
- email

Os registros são carregados e salvos em um arquivo local chamado `file.txt`, o que mantém os dados entre execuções.

## Funcionalidades

- Adicionar novos contatos
- Listar todos os contatos
- Buscar contatos por nome, telefone ou email
- Editar informações de um contato existente
- Remover contatos
- Salvar dados em arquivo local

## Como executar

1. Abra o terminal no diretório do projeto:
   ```bash
   cd aulas/agenda
   ```
2. Execute o programa Dart:
   ```bash
   dart run main.dart
   ```

## Arquivos principais

- `main.dart` — implementa a lógica da agenda e as operações CRUD
- `agenda.dart` — módulo auxiliar do projeto
- `file.txt` — arquivo de dados gerado automaticamente com os contatos

## Observações

- O projeto é voltado para uso em linha de comando.
- O arquivo `file.txt` deve estar no mesmo diretório do programa para que os contatos sejam carregados e salvos corretamente.
- Caso não exista, o arquivo será criado na primeira execução.
