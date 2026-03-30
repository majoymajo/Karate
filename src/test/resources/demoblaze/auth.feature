Feature: Demoblaze signup & login

  Background:
    * url baseUrl
    * def password = 'P@ssw0rd123'
    * def newUsername = function(){ return 'u' + java.util.UUID.randomUUID() }
    * def parseBody =
    """
    function (x) {
      if (karate.typeOf(x) != 'string') return x;
      var t = x.trim();
      // a veces el API responde JSON como string (e.g. "" o "{...}")
      if ((t.startsWith('{') && t.endsWith('}')) || (t.startsWith('[') && t.endsWith(']')) || (t.startsWith('"') && t.endsWith('"'))) {
        try { return karate.fromString(t); } catch (e) { return x; }
      }
      return x;
    }
    """

    * def extractToken =
    """
    function (x) {
      if (karate.typeOf(x) == 'map') {
        return x.Auth_token ? x.Auth_token : (x.token ? x.token : null);
      }
      if (karate.typeOf(x) != 'string') return null;
      var t = x.trim();
      var m = /Auth_token\s*:\s*(.+)/.exec(t);
      return m ? m[1].trim() : null;
    }
    """

  Scenario: Crear un nuevo usuario en signup
    * def username = newUsername()
    Given path 'signup'
    And request { username: '#(username)', password: '#(password)' }
    When method post
    Then status 200
    # Observado: en alta exitosa el API responde "" (string JSON vacío)
    * def body = parseBody(response)
    And match body == ''

  Scenario: Intentar crear un usuario ya existente en signup
    * def username = newUsername()
    # 1) crea el usuario
    Given path 'signup'
    And request { username: '#(username)', password: '#(password)' }
    When method post
    Then status 200
    * def body = parseBody(response)
    And match body == ''
    # 2) reintenta crear el mismo usuario (debe fallar por existente)
    Given path 'signup'
    And request { username: '#(username)', password: '#(password)' }
    When method post
    Then status 200
    # el error puede venir como objeto { errorMessage: '...' } o como string
    * def body = parseBody(response)
    * def err = karate.typeOf(body) == 'map' ? body.errorMessage : body
    And match err == '#string'
    * assert err.length > 0

  Scenario: Usuario y password correcto en login
    * def username = newUsername()
    # asegurar que el usuario existe
    Given path 'signup'
    And request { username: '#(username)', password: '#(password)' }
    When method post
    Then status 200
    * def body = parseBody(response)
    And match body == ''
    # login correcto
    Given path 'login'
    And request { username: '#(username)', password: '#(password)' }
    When method post
    Then status 200
    * def body = parseBody(response)
    * def token = extractToken(body)
    And match token == '#string'
    * assert token.length > 0

  Scenario: Usuario y password incorrecto en login
    * def username = newUsername()
    # asegurar que el usuario existe
    Given path 'signup'
    And request { username: '#(username)', password: '#(password)' }
    When method post
    Then status 200
    * def body = parseBody(response)
    And match body == ''
    # login con password incorrecto
    Given path 'login'
    And request { username: '#(username)', password: 'wrong-password' }
    When method post
    Then status 200
    * def body = parseBody(response)
    * def err = karate.typeOf(body) == 'map' ? body.errorMessage : body
    And match err == '#string'
    * assert err.length > 0
