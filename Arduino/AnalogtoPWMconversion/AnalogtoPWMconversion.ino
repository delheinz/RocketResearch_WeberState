#include <Servo.h>
Servo servo1;
Servo servo2;
void setup() {
  // put your setup code here, to run once:
  Serial.begin(19200);
  servo1.attach(6);
  // servo2.attach(3);
}

void loop() {
  int digitalValue = analogRead(0); // Channel 0 (A0) is selected
  // int digitalValue2 = analogRead(1);
  // 5.067V is the max voltage signal -> 1023. 
  int position = map(analogRead(A0),0,1023,0,180);
  // servo2.write(position);
  servo1.write(position);
  
  // delay(10);
  // analogWrite(3,map(analogRead(A0),0,1023,0,255));
  // analogWrite(6,map(analogRead(A0),0,1023,0,255));

  // Serial.print("Digital value: "); // Print text in serial monitor 
  // Serial.println(digitalValue); // Print Digital value in serial
  // Serial.println(digitalValue2);
                      // monitor ( 0 to 1023 ) 
}