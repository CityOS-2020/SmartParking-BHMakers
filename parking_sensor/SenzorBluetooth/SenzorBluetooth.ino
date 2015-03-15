#include <NewPing.h>
#include <SoftwareSerial.h>

#define trig  2  
#define echo     3  
#define max_dist 200 

SoftwareSerial bhmakers(10, 11); // RX, TX
NewPing sonar(trig, echo, max_dist); 
unsigned int pingSpeed = 50; 
unsigned long pingTimer;     

void setup() 
{  
  pingTimer = millis();
  bhmakers.begin(9600);
  bhmakers.println("Bluetooth On please wait...."); 
}

void loop() {
  
  if (millis() >= pingTimer) {   
    pingTimer += pingSpeed;      
    sonar.ping_timer(echoCheck); 
  }
 

}

void echoCheck() {
  int i; 
  if (sonar.check_timer()) {
    if ( sonar.ping_result / US_ROUNDTRIP_CM >= 10 && sonar.ping_result / US_ROUNDTRIP_CM <= 50){
     i = 2;
    }
    else if ( sonar.ping_result / US_ROUNDTRIP_CM < 10){
     i = 3;
    }
    else if ( sonar.ping_result / US_ROUNDTRIP_CM > 50){
      i = 1;
      }
    delay(30000); 
    bhmakers.println(i); 
  }
  
}
