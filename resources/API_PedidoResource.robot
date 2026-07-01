*** Settings ***
Library     RequestsLibrary
Library     Collections
Resource    ../variables/globais.robot
Resource    ../resources/CommonsResources.robot


*** Keywords ***
#DADO
Dado que exista um produto cadastrado
     ${response}     ${body}=    Criar Produto na API
     Set Suite Variable    ${response}
     Set Suite Variable    ${body}

#QUANDO
Quando eu criar ${quantidade} pedido valido
    ${quantidade}=    Convert To Integer    ${quantidade}
    ${responses}=     Create List
    ${bodies}=        Create List

    FOR     ${index}    IN RANGE    ${quantidade}
        ${response}    ${body}=    Criar Pedido Na API

        Append To List    ${responses}    ${response}
        Append To List    ${bodies}       ${body}
    END

    Set Suite Variable    ${responses}
    Set Suite Variable    ${bodies}
    Set Suite Variable    ${response}
    Set Suite Variable    ${body}

Quando eu criar um pedido com quantidade vazia
    ${body}=    Gerar Pedido invalido
    ...   quantidade=${NONE}

    ${response}    ${body}=    Criar Pedido Na API    ${body}

    Set Suite Variable    ${response}
    Set Suite Variable    ${body}

Quando eu criar um pedido com ID do produto vazio
    ${body}=    Gerar Pedido invalido
    ...   produto_id=${NONE}

    ${response}    ${body}=    Criar Pedido Na API    ${body}

    Set Suite Variable    ${response}
    Set Suite Variable    ${body}

#ENTAO
Entao a API deve retornar status 201
    Validar Status 201 Created    ${response}

Entao a API deve retornar status 400
    Validar Status 400 Bad Request    ${response}

#E
E deve retornar os dados do pedido criado
    ${json}=    Set Variable    ${response.json()}

    Dictionary Should Contain Key    ${json}    id
    Should Be Equal As Strings      ${json['status']}    PENDENTE
    Dictionary Should Contain Key    ${json}    valorTotal
    Dictionary Should Contain Key    ${json}    criadoEm

    ${item_response}=    Set Variable    ${json['itens'][0]}
    ${item_body}=        Set Variable    ${body['itens'][0]}

    Should Be Equal As Integers    ${item_response['produtoId']}     ${item_body['produtoId']}
    Should Be Equal As Integers    ${item_response['quantidade']}    ${item_body['quantidade']}
    Dictionary Should Contain Key  ${item_response}    produtoNome
    Dictionary Should Contain Key  ${item_response}    precoUnitario
    Dictionary Should Contain Key  ${item_response}    subtotal

E deve retornar a mensagem "${mensagem}" para o campo "${campo}"
    Validar Mensagem De Campo Obrigatorio
    ...    ${response}
    ...    ${campo}
    ...    ${mensagem}



#STEPS
Criar Pedido Na API
    [Arguments]    ${body}=${None}

    IF    ${body} == ${None}
        ${produto_id}=    Convert To Integer    1
        ${quantidade}=    Convert To Integer    1

        ${item}=    Create Dictionary
        ...    produtoId=${produto_id}
        ...    quantidade=${quantidade}

        ${itens}=    Create List
        ...    ${item}

        ${body}=    Create Dictionary
        ...    itens=${itens}
    END

    ${response}=    POST On Session
    ...    api
    ...    ${ENDPOINT_PEDIDOS}
    ...    headers=${HEADERS}
    ...    json=${body}
    ...    expected_status=any

    RETURN    ${response}    ${body}


Gerar Pedido Invalido
     [Arguments]
     ...    ${produto_id}=${NONE}
     ...    ${quantidade}=${NONE}

     ${item}=    Create Dictionary

     IF    $produto_id is not None
         ${produto_id}=    Convert To Integer    ${produto_id}
         Set To Dictionary    ${item}    produtoId=${produto_id}
     END

     IF    $quantidade is not None
         ${quantidade}=    Convert To Integer    ${quantidade}
         Set To Dictionary    ${item}    quantidade=${quantidade}
     END

     ${itens}=    Create List    ${item}

     ${body}=    Create Dictionary
     ...    itens=${itens}

     RETURN    ${body}