*** Settings ***
Documentation     Suite para criar um usuário na aplicação utilizando a API de criação de usuários.
Resource          ../../../resources/API_UsuarioResource.robot
Test Setup       Criar Sessao Da API

*** Test Cases ***
CT - Deve realizar a criacao de um usuario na API.
    [Documentation]         Criar um usuário na aplicação utilizando a API de criação de usuários.
    [Tags]    CT03    CriarUsuario    CriarUsuario    Smoke
    Quando eu criar um usuario valido
    Entao a API deve retornar status 201
    E deve retornar os dados do usuario criado
