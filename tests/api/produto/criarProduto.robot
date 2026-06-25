*** Settings ***
Documentation   Suite para criar um produto na aplicação utilizando a API de criação de produtos.
Resource        ../../../resources/API_ProdutoResource.robot
Test Setup      Preparar Ambiente Autenticado

*** Test Cases ***
CT01 - Deve realizar a criacao de um produto na API.
    [Documentation]     Criar um produto na aplicação utilizando a API de criação de produtos.
    [Tags]    CT01    Produto    CriarProduto    Smoke
    Dado que eu crie 1 produto valido
    Entao a API deve retornar status 201
    E deve retornar os dados dos produtos criados


CT02 - Deve realizar a criacao de dois produto com ddos na suite
    [Documentation]     Criar um produto na aplicação utilizando a API de criação de produtos.
    [Tags]    CT02    Produto    CriarProduto    Smoke
    Dado que eu crie 200 produto valido
    Entao a API deve retornar status 201
    E deve retornar os dados dos produtos criados
