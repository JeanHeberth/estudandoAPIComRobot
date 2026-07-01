*** Settings ***
Library     RequestsLibrary
Library     Collections
Resource   ../resources/CommonsResources.robot


*** Keywords ***

#DADO
Dado que exista um usuario padrao cadastrado
    ${response}     Criar Usuario Login Padrao Na API
    Set Suite Variable    ${response}

#QUANDO
Quando eu realizar login com usuario valido
    ${response}=   Autenticar Usuario Na API
    Set Suite Variable    ${response}

Quando eu realizar login com email e senha incorretos
    ${body}=         Gerar Login Inválido
       ...              email=xxx@xxx.com
       ...              senha=xxxcxcxcxc

       ${response}=     Autenticar Usuario Na API    ${body}

       Set Suite Variable    ${response}
       Set Suite Variable    ${body}

Quando eu realizar login com email incorreto
   ${body}=         Gerar Login Inválido
   ...              email=xxx@xxx.com
   ...              senha=${SENHA_LOGIN}

   ${response}=     Autenticar Usuario Na API    ${body}

   Set Suite Variable    ${response}
   Set Suite Variable    ${body}

Quando eu realizar login com a senha incorreta
   ${body}=         Gerar Login Inválido
   ...              email=${EMAIL_LOGIN}
   ...              senha=fsdfsfgdgdsgdsf

   ${response}=     Autenticar Usuario Na API    ${body}

   Set Suite Variable    ${response}
   Set Suite Variable    ${body}


Quando eu realizar login sem informar email
    ${body}         Gerar Login Inválido
    ...             email=
    ...             senha=${SENHA_LOGIN}
    
    ${response}=    Autenticar Usuario Na API    ${body}
    
    Set Suite Variable    ${response}
    Set Suite Variable    ${body}

Quando eu realizar login sem informar a senha
    ${body}         Gerar Login Inválido
    ...             email=${EMAIL_LOGIN}
    ...             senha=

    ${response}=    Autenticar Usuario Na API    ${body}

    Set Suite Variable    ${response}
    Set Suite Variable    ${body}


#ENTAO
Entao a API deve retornar status 200
   Validar Status 200 OK    ${response}

 Entao a API deve retornar status 401
    Validar Status 401 Unauthorized     ${response}

Entao a API deve retornar status 400
    Validar Status 400 Bad Request     ${response}

#E
E deve retornar um token JWT
    ${json}=   Set Variable         ${response.json()}
    Dictionary Should Contain Key   ${json}    token
    Should Not Be Empty             ${json['token']}
    Should Be Equal As Strings      ${json['tipo']}    Bearer

E deve retornar a mensagem de erro "${mensagem}"
    ${json}=    Set Variable    ${response.json()}
    Should Be Equal As Strings    ${json['mensagem']}    ${mensagem}



E deve retornar a mensagem "${mensagem}" para o campo "${campo}"
    ${json}=    Set Variable    ${response.json()}
    ${campos}=    Set Variable    ${json['campos']}

    ${mensagens}=    Create List
    FOR    ${erro}    IN    @{campos}
        IF    '${erro['campo']}' == '${campo}'
            Append To List    ${mensagens}    ${erro['mensagem']}
        END
    END

    List Should Contain Value    ${mensagens}    ${mensagem}


Gerar Login Inválido
    [Arguments]
    ...     ${email}=
    ...     ${senha}=

    ${body}=    Create Dictionary
    ...    email=${email}
    ...    senha=${senha}


    RETURN    ${body}

