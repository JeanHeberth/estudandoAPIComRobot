*** Settings ***
Library     RequestsLibrary
Library     Collections
Resource    ../variables/globais.robot
Resource    ../resources/CommonsResources.robot

*** Keywords ***

#DADO
Dado que eu crie ${quantidade} produto valido
    ${quantidade}=    Convert To Integer    ${quantidade}
    ${responses}=    Create List
    ${bodies}=       Create List

    FOR    ${index}    IN RANGE    ${quantidade}
        ${response}    ${body}=    Criar Produto Na API

        Append To List    ${responses}    ${response}
        Append To List    ${bodies}       ${body}
    END

    Set Suite Variable    ${responses}
    Set Suite Variable    ${bodies}

#ENTAO
Entao a API deve retornar status 201
    FOR     ${response}    IN    @{responses}
        Validar Status 201 Created    ${response}
    END

E deve retornar os dados dos produtos criados
        ${total_responses}=    Get Length    ${responses}
        ${total_bodies}=       Get Length    ${bodies}

        Should Be Equal As Integers    ${total_responses}    ${total_bodies}

        FOR    ${index}    IN RANGE    ${total_responses}
            ${response}=    Get From List    ${responses}    ${index}
            ${body}=        Get From List    ${bodies}       ${index}

            ${json}=    Set Variable    ${response.json()}

            Dictionary Should Contain Key    ${json}    id
            Should Be Equal As Strings       ${json['nome']}         ${body['nome']}
            Should Be Equal As Strings       ${json['descricao']}    ${body['descricao']}
            Should Be Equal As Numbers       ${json['preco']}        ${body['preco']}
            Should Be Equal As Integers      ${json['estoque']}      ${body['estoque']}
            Should Be Equal As Strings       ${json['categoria']}    ${body['categoria']}
        END