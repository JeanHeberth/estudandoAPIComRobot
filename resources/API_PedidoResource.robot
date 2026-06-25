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
Quando eu criar um pedido valido
    ${response}     ${body}=    Criar Pedido na API
    Set Suite Variable    ${response}
    Set Suite Variable    ${body}
#E
E existe um produto cadastrado
    ${response}     ${body}=    Criar Produto na API
    Set Suite Variable    ${response}
    Set Suite Variable    ${body}


#ENTAO
Entao a API deve retornar status 201
    Validar Status 201 Created    ${response}

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


#STEPS
Criar Pedido na API
   ${produto_id}=    Convert To Integer    1
   ${quantidade}=    Convert To Integer    1
   ${item}=     Create Dictionary
   ...          produtoId=${produto_id}
   ...          quantidade=${quantidade}

   ${itens}=    Create List
   ...          ${item}

   ${body}=     Create Dictionary
   ...          itens=${itens}

   ${response}=  POST On Session
   ...           api
   ...           ${ENDPOINT_PEDIDOS}
   ...           headers=${HEADERS}
   ...           json=${body}
   ...           expected_status=any

   RETURN       ${response}    ${body}