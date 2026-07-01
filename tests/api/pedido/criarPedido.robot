*** Settings ***
Documentation   Suite para criar um pedido na aplicação utilizando a API de criação de pedidos.
Resource        ../../../resources/API_PedidoResource.robot
Test Setup      Preparar Ambiente Autenticado

*** Test Cases ***
CT - Deve realizar a criacao de um pedido na API.
    [Documentation]     Criar um pedido na aplicação utilizando a API de criação de pedidos.
    [Tags]    CT01    Pedido    CriarPedido    Smoke
    Dado que exista um produto cadastrado
    Quando eu criar 1 pedido valido
    Entao a API deve retornar status 201
    E deve retornar os dados do pedido criado

CT - Deve realizar a criacao de um pedido na API.
    [Documentation]     Criar um pedido na aplicação utilizando a API de criação de pedidos.
    [Tags]    CT01    Pedido    CriarPedido    Smoke
    Dado que exista um produto cadastrado
    Quando eu criar 2 pedido valido
    Entao a API deve retornar status 201
    E deve retornar os dados do pedido criado

CT - Nao deve realizar a criacao de um pedido na API sem a quantidade
    [Documentation]     Nao deve realizar a criacao de um pedido na aplicação utilizando a API de criação de pedidos sem a quantidade.
    [Tags]    CT02    Pedido    CriarPedido
    Dado que exista um produto cadastrado
    Quando eu criar um pedido com quantidade vazia
    Entao a API deve retornar status 400
    E deve retornar a mensagem "Quantidade é obrigatória" para o campo "itens[0].quantidade"

CT - Nao deve realizar a criacao de um pedido na API sem a o ID do produto
    [Documentation]     Nao deve realizar a criacao de um pedido na aplicação utilizando a API de criação de pedidos sem o ID do produto.
    [Tags]    CT03    Pedido    CriarPedidoInvalido
    Dado que exista um produto cadastrado
    Quando eu criar um pedido com ID do produto vazio
    Entao a API deve retornar status 400
    E deve retornar a mensagem "ID do produto é obrigatório" para o campo "itens[0].produtoId"