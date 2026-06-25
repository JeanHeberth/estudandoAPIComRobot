*** Settings ***
Documentation   Suite para validar a autenticação na API
Resource      ../../../resources/API_AutenticacaoResource.robot
Test Setup    Criar Sessao Da API

*** Test Cases ***
CT - Login com sucesso
    [Tags]    AutenticarUsuario    Login    Smoke
       Dado que exista um usuario padrao cadastrado
       Quando eu realizar login com usuario valido
       Entao a API deve retornar status 200
       E deve retornar um token JWT
