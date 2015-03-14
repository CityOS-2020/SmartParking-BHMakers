

#include <ESP8266.h>

// CHANGE THIS TO 2 TO SEE MOST OF THE OUTPUT FROM THE LIBRARY
#define DEBUG_LEVEL 0

ESP8266 wifi(WIFI_MODE_STA, 9600, DEBUG_LEVEL);
bool connected = false;
int connectAttempts = 0;

void setup() {
  int ret;
  
  Serial1.begin(9600);
  Serial1.println("Starting up WiFi to RS232 Bridge");
  
  // start up the wifi connection
  // returns true if the module responds / resets properly
  ret = wifi.initializeWifi(&dataCallback, &connectCallback);
  if (ret != WIFI_ERR_NONE) {   
    Serial1.println(F("Wifi initialization failed."));
    Serial1.println(ret);
    return;
  }
  
  Serial1.println(F("Wifi initialized"));
    
  while (connectAttempts < 5)
  {
    // connect the module to the provided SSID
    ret = wifi.connectWifi("SmartParking", "sarajevo");
    //ret = wifi.connectWifi("Nest71", "UZmajevomGnijezdu");
    if (ret != WIFI_ERR_NONE) {
      Serial1.println(F("Unable to connect with associated access point."));
      Serial1.println(ret);
      connectAttempts++;
      Serial1.println("Retrying");
    }
    else
    { 
      Serial1.println(F("Wifi connected"));
      Serial1.println(wifi.ip());
      break;
    }
  }
  
  if (connectAttempts >= 5)
  {
    Serial1.println("Tried five times to connect. Aborting.");
  }
  
  /*if (wifi.startClient("188.138.48.162", 80, 1000)) {
    delay(500);
    wifi.send("GET /parkings/api/parkings/2/places/4/?status=2 HTTP/1.1\r\nHost: preview.hardver.ba\r\n\r\n");
  }*/
  
  /*if (wifi.startClient("192.168.1.101", 9009, 1000)) {
    wifi.send("GET /parkings/api/parkings/1/places/1/?status=1 HTTP/1.1\r\nHost: 192.168.1.101:9009\r\n\r\n");
  }*/
  
  //Serial1.println("Request sent");
}

int dataCallback(char *data) {
  Serial1.println(data);
}



void connectCallback() {
  connected = true;
}

long lastSend = 0;
void loop() {
  
  if (millis() - lastSend > 10000)
  {
    //if (wifi.startClient("188.138.48.162", 80, 1000)) {      
     if (wifi.startClient("192.168.1.101", 13000, 1000)) {      
      wifi.send("GET /parkings/api/parkings/2/places/4/?status=2 HTTP/1.1\r\nHost: preview.hardver.ba\r\n\r\n");
    }
    
    Serial1.println("Request sent.");
    
    lastSend = millis();
  }
   
  wifi.run();
  //delay(1000);
    //wifi.run();
  
}
