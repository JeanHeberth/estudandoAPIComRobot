*** Settings ***
Library     RequestsLibrary
Library     Collections
Resource    ../variables/globais.robot
Resource    ../resources/CommonsResources.robot

*** Keywords ***

#QUANDO
Quando que eu crio ${quantidade} produto valido
    ${quantidade}=    Convert To Integer    ${quantidade}
    ${responses}=     Create List
    ${bodies}=        Create List

    FOR    ${index}    IN RANGE    ${quantidade}
        ${response}    ${body}=    Criar Produto Na API

        Append To List    ${responses}    ${response}
        Append To List    ${bodies}       ${body}
    END

    Set Suite Variable    ${responses}
    Set Suite Variable    ${bodies}

Quando eu criar um produto com nome vazio
    ${body}=    Gerar Produto Sem Nome

    ${response}    ${body}=    Criar Produto Na API    ${body}

    Set Suite Variable    ${response}
    Set Suite Variable    ${body}

#ENTAO
Entao a API deve retornar status 201
    FOR     ${response}    IN    @{responses}
        Validar Status 201 Created    ${response}
    END

Entao a API deve retornar status 400
    Validar Status 400 Bad Request    ${response}

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

E deve retornar a mensagem "${mensagem}"
    Validar Mensagem De Campo Obrigatorio
    ...    ${response}
    ...    nome
    ...    ${mensagem}

Gerar Produto Sem Nome
    ${produto}=    Create Dictionary
    ...    nome=
    ...    descricao=MacBook M4, 16GB RAM, SSD 512GB
    ...    preco=39499.99
    ...    estoque=500000
    ...    categoria=ELETRONICO

    RETURN    ${produto}