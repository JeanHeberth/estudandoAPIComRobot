*** Settings ***
Library     RequestsLibrary
Library     Collections
Resource   ../resources/CommonsResources.robot


*** Keywords ***

#DADO
Dado que exista um usuario padrao cadastrado
    ${response}     Criar Usuario Login Padrao Na API
    Set Suite Variable    ${response}

#QUANDO
Quando eu realizar login com usuario valido
    ${response}=    Autenticar Usuario Na API
    Set Suite Variable    ${response}

#ENTAO
Entao a API deve retornar status 200
   Validar Status 200 OK    ${response}

#E
E deve retornar um token JWT
    ${json}=   Set Variable         ${response.json()}
    Dictionary Should Contain Key   ${json}    token
    Should Not Be Empty             ${json['token']}
    Should Be Equal As Strings      ${json['tipo']}    Bearer
