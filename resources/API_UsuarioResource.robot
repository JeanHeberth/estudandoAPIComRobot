*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource  ../variables/globais.robot
Resource  ../resources/CommonsResources.robot


*** Keywords ***
#QUANDO
Quando eu criar um usuario valido
   ${response}      ${body}=    Criar Usuario Na API
   Set Suite Variable    ${response}
   Set Suite Variable    ${body}

#ENTAO
Entao a API deve retornar status 201
    Validar Status 201 Created    ${response}

#E
E deve retornar os dados do usuario criado
    ${json}=    Set Variable         ${response.json()}
    Dictionary Should Contain Key    ${json}    id
    Should Be Equal As Strings       ${json['nome']}     ${body['nome']}
    Should Be Equal As Strings       ${json['email']}    ${body['email']}
