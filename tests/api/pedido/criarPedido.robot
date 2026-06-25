*** Settings ***
Documentation   Suite para criar um pedido na aplicação utilizando a API de criação de pedidos.
Resource        ../../../resources/API_PedidoResource.robot
Test Setup      Preparar Ambiente Autenticado

*** Test Cases ***
CT - Deve realizar a criacao de um pedido na API.
    [Documentation]     Criar um pedido na aplicação utilizando a API de criação de pedidos.
    [Tags]    CT01    Pedido    CriarPedido    Smoke
    Dado que exista um produto cadastrado
    Quando eu criar um pedido valido
    Entao a API deve retornar status 201
    E deve retornar os dados do pedido criado