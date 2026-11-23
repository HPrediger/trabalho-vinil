# mobile

# Vinyl Store — Aplicativo Mobile

## Integrantes
- Henrique Terres Prediger 
- Diwei Victor Nicolay da Silva 

## Descrição
O Vinyl Store é um aplicativo mobile desenvolvido em Flutter, integrado a uma API REST construída em NestJS. O aplicativo permite consultar um catálogo de discos de vinil, visualizar informações dos produtos e realizar autenticação de usuários.

## Funcionalidades
- Login de usuários utilizando autenticação JWT.
- Armazenamento seguro do token e manutenção da sessão.
- Listagem de discos de vinil cadastrados na API.
- Pesquisa por título do disco ou nome do artista.
- Filtro de discos por gênero musical.
- Visualização dos detalhes dos discos, incluindo artista, gênero, ano, preço, conservação, rotação e estoque.
- Exibição das capas dos discos.
- Atualização do catálogo por meio da API.
- Tratamento de erros de conexão e verificação da expiração da sessão.
- Logout do usuário.

## Tecnologias utilizadas
- Flutter e Dart
- Pacote HTTP para comunicação com a API
- Flutter Secure Storage para armazenamento do token
- API REST em NestJS
- Banco de dados SQLite gerenciado pelo Prisma

## Integração
O aplicativo consome a mesma API REST utilizada pelo sistema Web desenvolvido em Next.js, permitindo que os dados cadastrados no site sejam consultados no aplicativo mobile.