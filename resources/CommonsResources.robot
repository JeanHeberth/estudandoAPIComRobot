*** Settings ***
Resource    ../variables/globais.robot
Library    RequestsLibrary
Library    Collections


*** Keywords ***
Criar Sessao Da API
    Create Session    api    ${BASE_URL}

Autenticar Usuario Na API
    Validar Credenciais De Login Configuradas

    ${body}=    Create Dictionary
    ...    email=${EMAIL_LOGIN}
    ...    senha=${SENHA_LOGIN}

    ${response}=    POST On Session
    ...    api
    ...    ${ENDPOINT_TOKEN}
    ...    json=${body}
    ...    expected_status=any

    ${json}=    Set Variable         ${response.json()}
    ${headers}=     Create Dictionary
    ...    Authorization=${json['tipo']} ${json['token']}
    Set Suite Variable    ${headers}

    RETURN    ${response}

Validar Credenciais De Login Configuradas
    Should Not Be Empty    ${EMAIL_LOGIN}
    ...    msg=API_EMAIL nao configurada. Exporte a variavel de ambiente no shell/Run Configuration.
    Should Not Be Empty    ${SENHA_LOGIN}
    ...    msg=API_SENHA nao configurada. Exporte a variavel de ambiente no shell/Run Configuration.
Gerar Usuario Login Padrao
    ${usuario}=    Create Dictionary
    ...    nome=jean
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


Criar Usuario na API
    ${body}=    Gerar Dados De Usuario Faker

    ${response}=    POST On Session
    ...    api
    ...    ${ENDPOINT_USUARIOS}
    ...    json=${body}
    ...    expected_status=any

    Set Suite Variable    ${response}
    Set Suite Variable    ${body}

    RETURN    ${response}    ${body}


#GERACAO
Criar Produto na API
    ${body}         Gerar Produto Faker
    ${response}     POST On Session
    ...             api
    ...             ${ENDPOINT_PRODUTOS}
    ...             json=${body}
    ...             headers=${headers}
    ...             expected_status=any
    RETURN          ${response}    ${body}


#FAKERS


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

#STEPS
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


#### VALIDACOES ######
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
