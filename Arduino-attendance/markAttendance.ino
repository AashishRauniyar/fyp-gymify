#include <Arduino.h>
#include <SPI.h>
#include <MFRC522.h>
#include <WiFi.h>
#include <HTTPClient.h>
#include <ESP32Servo.h>
#include <ArduinoJson.h>

// RFID pins
#define RST_PIN     27
#define SS_PIN      5  
#define SERVO_PIN   13  // Servo control pin

// WiFi credentials
const char* ssid = "Aashish";
const char* password = "";


// API endpoint
const char* serverUrl = "https://gymify-m2guj.ondigitalocean.app/api/attendance";

// Initialize RFID and ServoD
MFRC522 rfid(SS_PIN, RST_PIN);
Servo gateServo;

// LED Pins for status indication
const int greenLED = 32;
const int redLED = 33;

void setup() {
  Serial.begin(9600);
  
  // Initialize LED pins
  pinMode(greenLED, OUTPUT);
  pinMode(redLED, OUTPUT);
  digitalWrite(greenLED, LOW);
  digitalWrite(redLED, LOW);
  
  // Initialize servo
  ESP32PWM::allocateTimer(0);
  gateServo.setPeriodHertz(50);    // Standard 50hz servo
  gateServo.attach(SERVO_PIN, 500, 2400); // Default min/max pulse widths
  gateServo.write(0); // Initial position
  
  // Initialize RFID
  SPI.begin();
  rfid.PCD_Init();
  
  // Connect to WiFi
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\nConnected to WiFi");
}

String getCardUID(MFRC522::Uid uid) {
  String cardID = "";
  for (byte i = 0; i < uid.size; i++) {
    if (uid.uidByte[i] < 0x10) {
      cardID += "0";
    }
    cardID += String(uid.uidByte[i], HEX);
  }
  cardID.toUpperCase();
  return cardID;
}

void openGate() {
  gateServo.write(90); // Open position
  digitalWrite(greenLED, HIGH);
  delay(3000);         // Keep open for 3 seconds
  gateServo.write(0);  // Close position
  digitalWrite(greenLED, LOW);
}

void indicateError() {
  digitalWrite(redLED, HIGH);
  delay(2000);
  digitalWrite(redLED, LOW);
}

bool markAttendance(String cardNumber) {
  if (WiFi.status() != WL_CONNECTED) {
    Serial.println("WiFi not connected");
    return false;
  }

  HTTPClient http;
  http.begin(serverUrl);
  http.addHeader("Content-Type", "application/json");

  // Prepare JSON payload
  StaticJsonDocument<200> doc;
  doc["card_number"] = cardNumber;
  
  String jsonString;
  serializeJson(doc, jsonString);

  // Send POST request
  int httpResponseCode = http.POST(jsonString);
  
  if (httpResponseCode > 0) {
    String response = http.getString();
    Serial.println("HTTP Response code: " + String(httpResponseCode));
    Serial.println("Response: " + response);
    
    // Parse response
    StaticJsonDocument<200> responseDoc;
    DeserializationError error = deserializeJson(responseDoc, response);
    
    if (!error) {
      const char* status = responseDoc["status"];
      if (String(status) == "success") {
        return true;
      }
    }
  } else {
    Serial.println("Error on HTTP request");
  }
  
  http.end();
  return false;
}

void loop() {
  // Check if a new card is present
  if (!rfid.PICC_IsNewCardPresent() || !rfid.PICC_ReadCardSerial()) {
    delay(50);
    return;
  }

  // Get card UID
  String cardUID = getCardUID(rfid.uid);
  Serial.println("Card detected: " + cardUID);

  // Try to mark attendance
  if (markAttendance(cardUID)) {
    Serial.println("Attendance marked successfully");
    openGate();
  } else {
    Serial.println("Failed to mark attendance");
    indicateError();
  }

  rfid.PICC_HaltA();
  rfid.PCD_StopCrypto1();
}