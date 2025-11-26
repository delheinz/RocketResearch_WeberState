#define X_PIN A6 //Hall Effect
#define STEP_PIN A1
#define Accel_PIN A4
#define SERVO_PIN A0
#include <Arduino.h>
#include <Servo.h>
// Variable declarations
const int stepPin = 2;
const int dirPin = 3;   // Direction control pin
const float stepsPerDegree = 40000.0 / 360.0;  // 200 steps per 360° rotation
const int switchPin = 8;
Servo servo1;

//State Variables
float currentAngle = 0;
bool manualControl = false;
// bool isMoving = false;
unsigned long previousMillis = 0; // Tracks time for stepper updates
const unsigned long interval = 3000; // 3 seconds interval
int lastTargetAngle = 0; // Tracks the last processed target angle
bool isMovingStepper = false; 

int stepsToMove(float degrees) {
  return degrees * stepsPerDegree;
}

void setup() {
  // put your setup code here, to run once:
  Serial.begin(19200);
  pinMode(stepPin, OUTPUT);
  pinMode(dirPin, OUTPUT);
  pinMode(switchPin, INPUT);
  // pinMode(X_PIN, INPUT_PULLUP);
  servo1.attach(6);
  servo1.write(0);
  //CCW Is positive angle , C2 is negative angle
  ZeroMotorOnce();
  delay(1000);
  zeroStepperFast(2.5); //small correction to get as close as possible to zero, values may change
}

void loop() {
  // Read analog inputs
  bool isSwitchOn = digitalRead(switchPin);
  if(isSwitchOn == HIGH){
    int hallstate = analogRead(X_PIN);
    int position = map(analogRead(SERVO_PIN), 0, 1023, 0, 180);
    int rawtargetAngle = map(analogRead(STEP_PIN), 0, 1023, -90, 90);
    int targetAngle = getClosestValidAngle(rawtargetAngle);
    // Update servo position continuously90
    servo1.write(position);

    // Check for serial input
    if (Serial.available() > 0) {
      String command = Serial.readStringUntil('\n'); // Read user input
      command.trim(); // Remove extra spaces or newline characters

      if (command == "manual") {
        manualControl = true;  // Enable manual control
        Serial.println("Manual control enabled.");
      } else if (command == "auto") {
        manualControl = false; // Disable manual control
        Serial.println("Automatic control enabled.");
        previousMillis = millis();
      } else if (command == "zero") {
        ZeroMotorOnce();
        delay(1000);
        // zeroStepperFast(-20);
        // delay(500)
      } else if (command == "s") {
        // Stop the motor immediately
        Serial.println("Emergency STOP activated!");
        zeroStepperFast(0); // Assume this stops the motor
        isMovingStepper = false;
      } else if (command == "reset") {
        Serial.println("Resetting Program...");
        delay(100);
        asm volatile("jmp 0");
      } else {
        // Try parsing a target angle from the input
        float userAngle = command.toFloat();
        Serial.print("Moving to user-specified angle: ");
        Serial.println(userAngle);
        zeroStepperFast(userAngle); // Move to the specified angle
        currentAngle = userAngle;
        isMovingStepper = true;
      }
    }

    // Stepper update logic
    // if (!manualControl && (millis() - previousMillis >= interval)) {
    //   previousMillis = millis(); // Reset timer
    //   Serial.println(previousMillis);
    //   if (targetAngle != lastTargetAngle) { 
    //     lastTargetAngle = targetAngle; // Update last target angle

    //     if (targetAngle == -1 || targetAngle == 0) {
    //       zeroStepperFast(0);
    //     } else if (targetAngle == -19 || targetAngle == -20 || targetAngle == -21) {  
    //       zeroStepperFast(-20);
    //     } else if (targetAngle == -31 || targetAngle == -30 || targetAngle == -29) {
    //       zeroStepperFast(-30);
    //     } else if (targetAngle == 29 || targetAngle == 30 || targetAngle == 31) {
    //       zeroStepperFast(30);
    //     } else if (targetAngle == -9 || targetAngle == -10 || targetAngle == -11) {
    //       zeroStepperFast(-10);
    //     }

    //     isMovingStepper = false; // Movement completed
    //   }
    // }
    if (!manualControl && targetAngle != currentAngle) {
      Serial.print("Updating stepper motor to target angle: ");
      // if (targetAngle == -1 || targetAngle == 0 || targetAngle == 1) {
      //   targetAngle = 0;
      // } else if (targetAngle == -19 || targetAngle == -20 || targetAngle == -21) {  
      //   targetAngle =-20;
      // } else if (targetAngle == 11 || targetAngle == 10 || targetAngle == 9) {
      //   targetAngle = 10;
      // } else if (targetAngle == 29 || targetAngle == 30 || targetAngle == 31) {
      //   targetAngle = 30;
      // } else if (targetAngle == -9 || targetAngle == -10 || targetAngle == -11) {
      //   targetAngle = -10;
      // }
      zeroStepperFast(targetAngle);
      currentAngle = targetAngle;
      Serial.println(targetAngle);
    }
  }else{
    Serial.println("Shutting system down...");
    int targetAngle = 0;
    zeroStepperFast(targetAngle);
    currentAngle = targetAngle;
    servo1.write(0);
    delay(1000);
  }
}


void zeroStepperFast(float targetAngle) {
  int steps = stepsToMove(targetAngle - currentAngle);  // Calculate steps needed
  int direction = (steps > 0) ? LOW : HIGH;
  steps = abs(steps);                     // Use absolute step count
  
  digitalWrite(dirPin, direction);        // Set motor direction
  for (int i = 0; i < steps; i++) {
    digitalWrite(stepPin,  HIGH);
    delayMicroseconds(5);              // Pulse width for step
    digitalWrite(stepPin, LOW);
    delayMicroseconds(5);              // Delay before next step
    delayMicroseconds(100);
  }
  // currentAngle = targetAngle;
}
void zeroStepperSlow(float targetAngle) {
  int steps = stepsToMove(targetAngle);  // Calculate steps needed
  int direction = (steps > 0) ? LOW : HIGH;
  steps = abs(steps);                     // Use absolute step count
  
  digitalWrite(dirPin, direction);        // Set motor direction
  
  for (int i = 0; i < steps; i++) {
    digitalWrite(stepPin, HIGH);
    delayMicroseconds(5);              // Pulse width for step
    digitalWrite(stepPin, LOW);
    delayMicroseconds(5);              // Delay before next step

    delayMicroseconds(1500);
  }
}

int getClosestValidAngle(int inputAngle) {
  int closestAngle = -90; // Start with the smallest valid angle (-90)
  int smallestDifference = abs(inputAngle - closestAngle);

  for (int angle = -90; angle <= 90; angle += 5) { // Generate angles dynamically
    int difference = abs(inputAngle - angle);
    if (difference < smallestDifference) {
      closestAngle = angle;
      smallestDifference = difference;
    }
  }

  return closestAngle;
}

void ZeroMotorOnce(){
  //Hall State setup
  while(true){
    int hallstate = analogRead(A6);
    // Serial.println("Zeroing...");
    // Serial.println("Zeroing...");
    // Serial.println(hallstate);
    if(hallstate < 150){
      // zeroStepperSlow(3);
      zeroStepperSlow(0);
      Serial.println("Motor zeroed at current position");
      break;
    }
  zeroStepperFast(1);
  delay(400);
  }
  //Accelerometer setup
  // while(true){
  //   int accelAngle = map(analogRead(Accel_PIN),260,396,-90,90);
  //   Serial.println("Zeroing... X Tilt Angle: ");
  //   // Serial.println(accelAngle);
  //   if (accelAngle >= -2 && accelAngle <= 2) {                      // Threshold for zeroing
  //     zeroStepperSlow(0);                        // Set current position as zero
  //     Serial.println("Motor zeroed at current position.");  // Confirm zeroing
  //     break;
  //   }
  //   zeroStepperFast(1);
  //   delay(50);
  // }
  // currentAngle = 0;
}

void ZeroMotorTwice(){
  //Hall State Setup:
  while(true){
    int hallstate = analogRead(X_PIN);
    // Serial.print("Zeroing Again ...");
    // Serial.println(hallstate);
    if(hallstate < 50){
      // zeroStepperSlow(2);
      zeroStepperSlow(0);
      Serial.println("Motor zeroed at current position");
      break;
    }
  zeroStepperSlow(1);
  delay(500);
  }
  // while(true){
  //   int accelAngle = map(analogRead(Accel_PIN),260,396,-90,90);
  //   Serial.println("Zeroing... Again ");
  //   // Serial.println(accelAngle);
  //   if (accelAngle >= -2 && accelAngle <= 2) {                      // Threshold for zeroing
  //     zeroStepperSlow(0);                        // Set current position as zero
  //     Serial.println("Motor zeroed at current position.");  // Confirm zeroing
  //     break;
  //   }
  //   zeroStepperSlow(1);
  //   delay(50);
  // }
  // currentAngle = 0;
}