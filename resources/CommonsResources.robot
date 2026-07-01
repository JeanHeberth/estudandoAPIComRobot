*** Settings ***
Resource    ../variables/globais.robot
Library     RequestsLibrary
Library     Collections


#########################################
############### SESSÃO ##################
#########################################

*** Keywords ***
Criar Sessao Da API
    Create Session
    ...    api
    ...    ${BASE_URL}

Preparar Ambiente Autenticado
    Criar Sessao Da API
    Criar Usuario Login Padrao Na API
    Autenticar Usuario Na API


#########################################
########### AUTENTICAÇÃO ################
#########################################

Validar Credenciais De Login Configuradas
    Should Not Be Empty
    ...    ${EMAIL_LOGIN}
    ...    msg=API_EMAIL não configurada.

    Should Not Be Empty
    ...    ${SENHA_LOGIN}
    ...    msg=API_SENHA não configurada.


Autenticar Usuario Na API
    [Arguments]    ${body}=${None}

    IF    $body is None
        Validar Credenciais De Login Configuradas

        ${body}=    Create Dictionary
        ...    email=${EMAIL_LOGIN}
        ...    senha=${SENHA_LOGIN}
    END

    ${response}=    POST On Session
    ...    api
    ...    ${ENDPOINT_TOKEN}
    ...    json=${body}
    ...    expected_status=any

    IF    ${response.status_code} == 200
        ${json}=    Set Variable    ${response.json()}

        ${headers}=    Create Dictionary
        ...    Authorization=${json['tipo']} ${json['token']}

        Set Suite Variable    ${HEADERS}    ${headers}
    END

    RETURN    ${response}
#########################################
############### USUÁRIO #################
#########################################

Gerar Usuario Login Padrao
    ${usuario}=    Create Dictionary
    ...    nome=Jean Heberth
    ...    email=${EMAIL_LOGIN}
    ...    senha=${SENHA_LOGIN}

    RETURN    ${usuario}


Criar Usuario Login Padrao Na API
    ${body}=    Gerar Usuario Login Padrao

    ${response}=    POST On Session
    ...    api
    ...    ${ENDPOINT_USUARIOS}
    ...    json=${body}
    ...    expected_status=any

    RETURN    ${response}


Gerar Dados De Usuario Faker
    ${faker}=         Evaluate    __import__('faker').Faker('pt_BR')

    ${first_name}=    Evaluate    $faker.first_name()
    ${last_name}=     Evaluate    $faker.last_name()
    ${email}=         Evaluate    $faker.ascii_safe_email()
    ${password}=      Evaluate    $faker.password(length=12)

    ${usuario}=    Create Dictionary
    ...    nome=${first_name} ${last_name}
    ...    email=${email}
    ...    senha=${password}

    RETURN    ${usuario}


Criar Usuario Na API
    ${body}=    Gerar Dados De Usuario Faker

    ${response}=    POST On Session
    ...    api
    ...    ${ENDPOINT_USUARIOS}
    ...    json=${body}
    ...    expected_status=any

    RETURN    ${response}    ${body}


#########################################
############### PRODUTO #################
#########################################

Gerar Produto Faker
    ${faker}=        Evaluate    __import__('faker').Faker('pt_BR')

    ${nome}=         Evaluate    $faker.name()
    ${descricao}=    Evaluate    $faker.text()
    ${preco}=        Evaluate    $faker.random_number(digits=5)
    ${estoque}=      Evaluate    $faker.random_number(digits=3)

    ${produto}=    Create Dictionary
    ...    nome=${nome}
    ...    descricao=${descricao}
    ...    preco=${preco}
    ...    estoque=${estoque}
    ...    categoria=ELETRONICO

    RETURN    ${produto}


Criar Produto Na API
    [Arguments]     ${body}=${None}

    IF   $body is None
    ${body}=    Gerar Produto Faker
    END

    ${response}=    POST On Session
    ...    api
    ...    ${ENDPOINT_PRODUTOS}
    ...    headers=${HEADERS}
    ...    json=${body}
    ...    expected_status=any

    RETURN    ${response}    ${body}


#########################################
############### PEDIDO ##################
#########################################

Criar Pedido Na API
    ${produto_id}=    Convert To Integer    1
    ${quantidade}=    Convert To Integer    2

    ${item}=    Create Dictionary
    ...    produtoId=${produto_id}
    ...    quantidade=${quantidade}

    ${itens}=    Create List
    ...    ${item}

    ${body}=    Create Dictionary
    ...    itens=${itens}

    ${response}=    POST On Session
    ...    api
    ...    ${ENDPOINT_PEDIDOS}
    ...    headers=${HEADERS}
    ...    json=${body}
    ...    expected_status=any

    RETURN    ${response}    ${body}


#########################################
############## VALIDAÇÕES ###############
#########################################

Validar Status 200 OK
    [Arguments]    ${response}
    Should Be Equal As Integers
    ...    ${response.status_code}
    ...    200


Validar Status 201 Created
    [Arguments]    ${response}
    Should Be Equal As Integers
    ...    ${response.status_code}
    ...    201


Validar Status 204 No Content
    [Arguments]    ${response}
    Should Be Equal As Integers
    ...    ${response.status_code}
    ...    204


Validar Status 400 Bad Request
    [Arguments]    ${response}
    Should Be Equal As Integers
    ...    ${response.status_code}
    ...    400


Validar Status 401 Unauthorized
    [Arguments]    ${response}
    Should Be Equal As Integers
    ...    ${response.status_code}
    ...    401


Validar Status 404 Not Found
    [Arguments]    ${response}
    Should Be Equal As Integers
    ...    ${response.status_code}
    ...    404


Validar Status 409 Conflict
    [Arguments]    ${response}
    Should Be Equal As Integers
    ...    ${response.status_code}
    ...    409


Validar Campo Existe No Response
    [Arguments]    ${response}    ${campo}

    ${json}=    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${json}    ${campo}


Validar Token JWT
    [Arguments]    ${response}

    ${json}=    Set Variable    ${response.json()}

    Dictionary Should Contain Key    ${json}    token
    Should Not Be Empty             ${json['token']}
    Should Be Equal As Strings      ${json['tipo']}    Bearer

Validar Mensagem De Campo Obrigatorio
    [Arguments]    ${response}    ${campo}    ${mensagem}

    ${json}=    Set Variable    ${response.json()}

    Should Be Equal As Strings
    ...    ${json['mensagem']}
    ...    Um ou mais campos estão inválidos

    ${campos}=    Set Variable    ${json['campos']}

    ${mensagens}=    Create List

    FOR    ${erro}    IN    @{campos}
        IF    '${erro['campo']}' == '${campo}'
            Append To List    ${mensagens}    ${erro['mensagem']}
        END
    END

    List Should Contain Value
    ...    ${mensagens}
    ...    ${mensagem}