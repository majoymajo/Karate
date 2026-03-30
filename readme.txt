EJERCICIO 2 - Demoblaze API (Karate)

Objetivo
- Probar los servicios REST de signup y login de https://www.demoblaze.com/
  Signup: https://api.demoblaze.com/signup
  Login:  https://api.demoblaze.com/login

Requisitos
- Java 17+ y Maven 3.8+ instalados (o equivalente).

Estructura
- src/test/resources/karate-config.js
- src/test/resources/demoblaze/auth.feature
- src/test/java/demoblaze/DemoBlazeTest.java

Ejecución paso a paso
1) Abrir una terminal en la carpeta del proyecto.
2) Ejecutar:
   mvn test

Resultados / Evidencias
- Karate genera reportes en:
  target/karate-reports/karate-summary.html

Casos cubiertos (ver feature)
- Crear un nuevo usuario en signup
- Intentar crear un usuario ya existente
- Usuario y password correcto en login
- Usuario y password incorrecto en login

Notas
- Para evitar colisiones, el test genera un username único (timestamp).
- En el reporte HTML queda el request/response (pretty) de cada escenario.
