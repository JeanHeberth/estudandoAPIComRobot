*** Settings ***
Documentation     Suite para validar se a API está no ar através de um Health-Check
Resource          ../../../resources/API_HealthCheckResource.robot
Test Setup        Criar Sessao Da API


*** Test Cases ***
CT - Deve validar que a API está no ar.
    [Documentation]     Validar se a API está no ar através de um Health-Check
    [Tags]  CT01    HealthCheck
    Quando eu consultar o healhcheck
    Entao a API deve retornar status 200
    E o status da aplicação deve ser UP e campo aplicacao deve ser igual a criandoAPI


