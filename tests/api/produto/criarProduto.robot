*** Settings ***
Documentation   Suite para criar um produto na aplicação utilizando a API de criação de produtos.
Resource        ../../../resources/API_ProdutoResource.robot
Test Setup      Preparar Ambiente Autenticado

*** Test Cases ***
CT01 - Deve realizar a criacao de um produto na API.
    [Documentation]     Criar um produto na aplicação utilizando a API de criação de produtos.
    [Tags]    CT01    Produto    CriarProduto    Smoke
    Quando que eu criar 1 produto valido
    Entao a API deve retornar status 201
    E deve retornar os dados dos produtos criados

CT02 - Deve realizar a criacao de dois produto com dados na suite
    [Documentation]     Criar um produto na aplicação utilizando a API de criação de produtos.
    [Tags]    CT02    Produto    CriarProduto    Smoke
    Quando que eu criar 2 produto valido
    Entao a API deve retornar status 201
    E deve retornar os dados dos produtos criados

CT03 - Não deve criar produto sem nome na API
    [Documentation]   Não deve criar produto sem nome na API de criação de produtos.
    [Tags]    CT03    Produto    CriarProdutoSemNome    Smoke
    Quando eu criar um produto com nome vazio
    Entao a API deve retornar status 400
    E deve retornar a mensagem "Nome é obrigatório" para o campo "nome"

CT04 - Estoque negativo
    [Documentation]   Não deve criar produto com estoque negativo na API de criação de produtos.
    [Tags]    CT04    Produto    CriarProdutoEstoqueNegativo    Smoke
    Quando eu criar um produto com estoque -1
    Entao a API deve retornar status 400
    E deve retornar a mensagem "Estoque não pode ser negativo" para o campo "estoque"

CT05 - Categoria inválida
    [Documentation]   Não deve criar produto com categoria inválida na API de criação de produtos.
    [Tags]    CT05    Produto    CriarProdutoCategoriaInvalida    Smoke
    Quando eu criar um produto com categoria inválida
    Entao a API deve retornar status 400
    E a mensagem deve conter "Valor 'TESTE' invalido."

CT06 - Valor Negativo
    [Documentation]   Não deve criar produto com valor negativo na API de criação de produtos.
    [Tags]    CT06    Produto    CriarProdutoValorNegativo    Smoke
    Quando eu criar um produto com valor -1
    Entao a API deve retornar status 400
    E deve retornar a mensagem "Preço deve ser maior que zero" para o campo "preco"