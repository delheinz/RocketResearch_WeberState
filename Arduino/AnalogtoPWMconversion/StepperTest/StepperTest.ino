#include <AccelStepper.h>
int lastTarget = 0;

AccelStepper stepper(AccelStepper::DRIVER, 2, 3);  // Pins 2 for STEP, 3 for DIR

void setup() {
  Serial.begin(9600);
  // pinMode(8, OUTPUT);          // Set pin 8 as an output for pulse signal

  stepper.setMaxSpeed(1000);    // Max speed for zeroing and positioning
  stepper.setAcceleration(200);
}

void loop() {
  int targetAngle = map(analogRead(A1),0,1023,-500,500);

  //  if (targetAngle != lastTarget) {
  //   stepper.moveTo(targetAngle);  // Set new target position
  //   lastTarget = targetAngle;     // Save the current target position
  // }
  
  stepper.moveTo(10);  // Set new target position
  stepper.runToPosition(39);

  Serial.print("Mapping: ");
  Serial.println(targetAngle);

  // put your main code here, to run repeatedly:
  // digitalWrite(9,HIGH);
  // delay(2);
  // digitalWrite(9,LOW);
  // delay(2);
  // digitalWrite(8, HIGH);
  // delayMicroseconds(1250);        // Short delay to create the pulse width
  // digitalWrite(8, LOW);
  // delayMicroseconds(1250);        // Short delay to create the pulse width

}


// void ZeroMotor(){
//   float xValue = analogRead(A4);
//   float xangle = map(xValue, 399, 610, -90, 90);
//   stepper.moveTo()
// }
