int car;
void setup() {
  Serial.begin(9600);
}
 
void loop() {
  int sensorValue = analogRead(A0);
  if (sensorValue <= 800)
    car = 1;
  else
    car = 0;
  if (car == 1)
    Serial.println("There is car above me");
  else 
    Serial.println("I'm available");
  delay(500);        
}
