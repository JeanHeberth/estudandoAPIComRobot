*** Variables ***

### ENDPOINTS
${API_APPLICATION_NAME}     /criandoAPI
${API_VERSION_PREFIX}       /v1
${API_PORT}                 9999
${BASE_URL}                 http://localhost:${API_PORT}${API_APPLICATION_NAME}${API_VERSION_PREFIX}
${EMAIL_LOGIN}              %{API_EMAIL=}
${SENHA_LOGIN}              %{API_SENHA=}
${ENDPOINT_TOKEN}           /auth/login
${ENDPOINT_USUARIOS}        /usuarios
${ENDPOINT_PRODUTOS}        /produtos
${ENDPOINT_PEDIDOS}         /pedidos

