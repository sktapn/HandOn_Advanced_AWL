#include <DHT.h>

// Definição dos pinos
#define UV_SENSOR_PIN 34  // Pino analógico do sensor UV GUVA-S12SD
#define DHT_PIN 4         // Pino digital do sensor DHT11
#define DHT_TYPE DHT11    // Tipo de sensor (DHT11)

// Criação dos objetos
DHT dht(DHT_PIN, DHT_TYPE);  // Inicializa o sensor DHT11

void setup() {
  // Inicializa a comunicação serial
  Serial.begin(115200);
  
  // Inicializa o sensor DHT11
  dht.begin();

  // Aguarda um tempo para estabilização
  delay(2000); 
}

void loop() {
  // Leitura do sensor UV (valor analógico)
  int sensorValue = analogRead(UV_SENSOR_PIN);  
  float voltage = (sensorValue / 4095.0) * 3.3;  // Converte para tensão (0 a 3.3V)
  float uvIndex = voltage * 10.0;  // Exemplo de conversão para índice UV (ajustar conforme necessário)

  // Leitura do sensor DHT11 (temperatura e umidade)
  float temperature = dht.readTemperature();  // Temperatura em Celsius
  float humidity = dht.readHumidity();        // Umidade relativa em %

  // Verifica se as leituras do DHT11 foram bem-sucedidas
  if (isnan(temperature) || isnan(humidity)) {
    Serial.println("Falha na leitura do sensor DHT11!");
  } else {
    // Exibe os resultados no monitor serial
    Serial.print("Índice UV: ");
    Serial.print(uvIndex);
    Serial.print(" | Tensão: ");
    Serial.print(voltage);
    Serial.print("V");
    Serial.print(" | Temperatura: ");
    Serial.print(temperature);
    Serial.print("°C");
    Serial.print(" | Umidade: ");
    Serial.print(humidity);
    Serial.println("%");
  }

  // Aguarda 2 segundos antes de fazer nova leitura
  delay(2000);
}
