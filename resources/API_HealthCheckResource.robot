*** Settings ***
Resource    ../resources/CommonsResources.robot
Library     RequestsLibrary


*** Keywords ***
#Dado
Dado que eu tenha acesso a api
     Criar Sessao Da API

#Quando
Quando eu consultar o healhcheck
    ${response}=    GET On Session    api    /health
    Set Suite Variable    ${response}

#Entao
Entao a API deve retornar status 200
    Validar Status 200 OK       ${response}

#E
E o status da aplicação deve ser UP e campo aplicacao deve ser igual a criandoAPI
    ${json}=    Set Variable      ${response.json()}
    Should Be Equal As Strings    ${json['status']}    UP
    Should Be Equal As Strings    ${json['aplicacao']}  criandoAPI