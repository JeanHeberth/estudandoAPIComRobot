*** Settings ***
Library     RequestsLibrary
Library     Collections
Resource    ../variables/globais.robot
Resource    ../resources/CommonsResources.robot

*** Keywords ***

#QUANDO
Quando que eu criar ${quantidade} produto valido
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
    ${body}=    Gerar Produto invalido
    ...   nome=
    ${response}    ${body}=    Criar Produto Na API    ${body}

    Set Suite Variable    ${response}
    Set Suite Variable    ${body}

Quando eu criar um produto com categoria inválida
    ${body}=    Gerar Produto invalido
    ...         categoria=TESTE
    ${response}    ${body}=    Criar Produto Na API    ${body}

    Set Suite Variable    ${response}
    Set Suite Variable    ${body}

Quando eu criar um produto com estoque -1
    ${body}=    Gerar Produto invalido
    ...   estoque=-1

    ${response}    ${body}=    Criar Produto Na API    ${body}

    Set Suite Variable    ${response}
    Set Suite Variable    ${body}

Quando eu criar um produto com valor -1
    ${body}=    Gerar Produto invalido
    ...   preco=-1

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

E deve retornar a mensagem "${mensagem}" para o campo "${campo}"
    Validar Mensagem De Campo Obrigatorio
    ...    ${response}
    ...    ${campo}
    ...    ${mensagem}

E a mensagem deve conter "${texto}"
    ${json}=    Set Variable    ${response.json()}
    ${erro}=    Set Variable    ${json['mensagem'][0]}

    Should Contain
    ...    ${json['mensagem']}
    ...    ${texto}

Gerar Produto invalido
    [Arguments]
    ...    ${nome}=Notebook Gamer
    ...    ${descricao}=RTX 4060
    ...    ${preco}=3500
    ...    ${estoque}=100
    ...    ${categoria}=ELETRONICO

    ${produto}=    Create Dictionary
    ...    nome=${nome}
    ...    descricao=${descricao}
    ...    preco=${preco}
    ...    estoque=${estoque}
    ...    categoria=${categoria}

    RETURN    ${produto}