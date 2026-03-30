function fn() {
  var config = {
    baseUrl: 'https://api.demoblaze.com'
  };

  karate.configure('logPrettyRequest', true);
  karate.configure('logPrettyResponse', true);

  // Hace que el reporte HTML incluya todos los pasos
  karate.configure('report', { showLog: true, showAllSteps: true });

  return config;
}
