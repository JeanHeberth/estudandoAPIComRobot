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

CT - Login com credenciais inválidas
    [Tags]    credenciaisInvalidas    Login    Smoke
       Quando eu realizar login com email e senha incorretos
       Entao a API deve retornar status 401
       E deve retornar a mensagem de erro "Credenciais inválidas"

CT - Login email incorreto
    [Tags]    emailIncorreto    Login    Smoke
       Quando eu realizar login com email incorreto
       Entao a API deve retornar status 401
       E deve retornar a mensagem de erro "Credenciais inválidas"

CT - Login senha incorreto
    [Tags]    senhaIncorreta    Login    Smoke
       Quando eu realizar login com a senha incorreta
       Entao a API deve retornar status 401
       E deve retornar a mensagem de erro "Credenciais inválidas"

CT - Login email não informado
    [Tags]    emailVazio    Login    Smoke
       Quando eu realizar login sem informar email
       Entao a API deve retornar status 400
       E deve retornar a mensagem "E-mail é obrigatório" para o campo "email"

CT - Login senha não informada
    [Tags]    senhaVazia    Login    Smoke
       Quando eu realizar login sem informar a senha
       Entao a API deve retornar status 400
       E deve retornar a mensagem "Senha é obrigatória" para o campo "senha"
