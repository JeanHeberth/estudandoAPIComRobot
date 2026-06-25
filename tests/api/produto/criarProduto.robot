*** Settings ***
Documentation   Suite para criar um produto na aplicação utilizando a API de criação de produtos.
Resource        ../../../resources/API_ProdutoResource.robot
Test Setup      Preparar Ambiente Autenticado

*** Test Cases ***
CT01 - Deve realizar a criacao de um produto na API.
    [Documentation]     Criar um produto na aplicação utilizando a API de criação de produtos.
    [Tags]    CT01    Produto    CriarUmProduto    Smoke
    Quando que eu crio 1 produto valido
    Entao a API deve retornar status 201
    E deve retornar os dados dos produtos criados


CT02 - Deve realizar a criacao de dois produto com dados na suite
    [Documentation]     Criar um produto na aplicação utilizando a API de criação de produtos.
    [Tags]    CT02    Produto    CriarDoisProdutos    Smoke
    Quando que eu crio 200 produto valido
    Entao a API deve retornar status 201
    E deve retornar os dados dos produtos criados

CT03 - Não deve criar produto sem nome na API
    [Documentation]   Não deve criar produto sem nome na API de criação de produtos.
    [Tags]    CT03    Produto    ProdutoSemNome    Smoke
    Quando eu criar um produto com nome vazio
    Entao a API deve retornar status 400
    E deve retornar a mensagem "Nome é obrigatório"
