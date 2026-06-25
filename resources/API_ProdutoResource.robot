*** Settings ***
Library     RequestsLibrary
Library     Collections
Resource    ../variables/globais.robot
Resource    ../resources/CommonsResources.robot

*** Keywords ***

#DADO
Dado que eu esteja autenticado na api
     ${response}     Autenticar Usuario Na API
     Set Suite Variable    ${response}

#QUANDO
Quando eu criar um produto valido
    ${response}     ${body}=    Criar Produto na API
    Set Suite Variable    ${response}
    Set Suite Variable    ${body}

#ENTAO
Entao a API deve retornar status 201
    Should Be Equal As Integers    ${response.status_code}    201

E deve retornar os dados do produto criado
    ${json}     Set Variable         ${response.json()}
    Dictionary Should Contain Key    ${json}    id
    Should Be Equal As Strings       ${json['nome']}     ${body['nome']}
    Should Be Equal As Strings       ${json['descricao']}    ${body['descricao']}
    Should Be Equal As Numbers       ${json['preco']}    ${body['preco']}
    Should Be Equal As Numbers       ${json['estoque']}    ${body['estoque']}
    Should Be Equal As Strings       ${json['categoria']}    ${body['categoria']}

