Feature: Demoblaze signup & login

  Background:
    * url baseUrl
    * def password = 'P@ssw0rd123'
    * def newUsername = function(){ return 'u' + java.lang.System.currentTimeMillis() }

  Scenario: Crear un nuevo usuario en signup
    * def username = newUsername()
    Given path 'signup'
    And request { username: '#(username)', password: '#(password)' }
    When method post
    Then status 200
    And match response.errorMessage == '#notpresent'

  Scenario: Intentar crear un usuario ya existente en signup
    * def username = newUsername()
    # 1) crea el usuario
    Given path 'signup'
    And request { username: '#(username)', password: '#(password)' }
    When method post
    Then status 200
    And match response.errorMessage == '#notpresent'
    # 2) reintenta crear el mismo usuario (debe fallar por existente)
    Given path 'signup'
    And request { username: '#(username)', password: '#(password)' }
    When method post
    Then status 200
    And match response.errorMessage == '#string'

  Scenario: Usuario y password correcto en login
    * def username = newUsername()
    # asegurar que el usuario existe
    Given path 'signup'
    And request { username: '#(username)', password: '#(password)' }
    When method post
    Then status 200
    And match response.errorMessage == '#notpresent'
    # login correcto
    Given path 'login'
    And request { username: '#(username)', password: '#(password)' }
    When method post
    Then status 200
    * def token = response.Auth_token ? response.Auth_token : response.token
    And match token == '#string'
    And match response.errorMessage == '#notpresent'

  Scenario: Usuario y password incorrecto en login
    * def username = newUsername()
    # asegurar que el usuario existe
    Given path 'signup'
    And request { username: '#(username)', password: '#(password)' }
    When method post
    Then status 200
    And match response.errorMessage == '#notpresent'
    # login con password incorrecto
    Given path 'login'
    And request { username: '#(username)', password: 'wrong-password' }
    When method post
    Then status 200
    And match response.errorMessage == '#string'
