*** Settings ***
Documentation   Suite para criar um produto na aplicação utilizando a API de criação de produtos.
Resource        ../../../resources/API_ProdutoResource.robot
Test Setup      Criar Sessao Da API


*** Test Cases ***
CT - Deve realizar a criacao de um produto na API.
    [Documentation]     Criar um produto na aplicação utilizando a API de criação de produtos.
    [Tags]    CT01    Produto    CriarProduto    Smoke
    Dado que eu esteja autenticado na api
    Quando eu criar um produto valido
    Entao a API deve retornar status 201
    E deve retornar os dados do produto criado