*** Settings ***

Library     RequestsLibrary

*** Keywords ***
#Dado
Dado que eu tenha acesso a api
    Create Session    api    ${BASE_URL}

#Quando
Quando eu consultar o healhcheck
    ${response}=    Get Request    api    /actuator/health
    Set Suite Variable    ${response}

#Entao
Entao a API deve retornar status 200
    Should Be Equal As Integers    ${response.status_code}    200
#E
E o status da aplicação deve ser UP
    ${json}=    To Json    ${response.content}
    Should Be Equal As Strings    ${json['status']}    UP