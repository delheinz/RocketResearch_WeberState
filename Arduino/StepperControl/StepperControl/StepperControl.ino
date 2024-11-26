#define X_PIN A6
#define STEP_PIN A1
#define Accel_PIN A4
#define SERVO_PIN A0
#include <Arduino.h>
#include <Servo.h>

// Variable declarations
const int stepPin = 2;
const int dirPin = 3;   // Direction control pin
const float stepsPerDegree = 40000.0 / 360.0;  // 200 steps per 360° rotation
Servo servo1;

//State Variables
float currentAngle = 0;
// bool isMoving = false;

unsigned long previousMillis = 0; // Tracks time for stepper updates
const unsigned long interval = 3000; // 3 seconds interval
int lastTargetAngle = 0; // Tracks the last processed target angle
bool isMovingStepper = false; 

// Convert angle to steps
int stepsToMove(float degrees) {
  return degrees * stepsPerDegree;
}

void setup() {
  Serial.begin(19200);
  pinMode(stepPin, OUTPUT);
  pinMode(dirPin, OUTPUT);
  pinMode(X_PIN, INPUT_PULLUP);
  servo1.attach(6);
  servo1.write(0);
  // Serial.println("Enter target angle (e.g., -30 or 20) to move the stepper motor:");
  ZeroMotorOnce();
  delay(1000);
  zeroStepperFast(20);
  delay(1000);
  ZeroMotorTwice();

  // ZeroMotorOnce();
  // delay(1000);
  // zeroStepperFast(20);
  // delay(500);
  // ZeroMotorTwice();

  // int targetAngle = map(analogRead(DAQ_PIN),0,1023,-20,20);
  // moveStepper(-20);
}

int readSensorAverage(int pin, int samples = 10){
  long sum = 0;
  for (int i = 0; i < samples; i++) {
    sum += analogRead(pin);
  }
  return sum / samples;
}

void loop() {
  // Read analog inputs
  int hallstate = analogRead(X_PIN);
  int position = map(analogRead(SERVO_PIN), 0, 1023, 0, 180);
  int targetAngle = map(analogRead(STEP_PIN), 0, 1023, -90, 90);

  // Update servo position continuously
  servo1.write(position);

  // Check elapsed time for stepper updates
  // unsigned long currentMillis = millis();
  // if (currentMillis - previousMillis >= interval) {
  //   previousMillis = currentMillis; // Reset timer

  //   // Process stepper target angle
  //   if (targetAngle != lastTargetAngle) { 
  //     lastTargetAngle = targetAngle; // Update last target angle

  //     if (targetAngle == -1 || targetAngle == 0) {
  //       zeroStepperFast(0);
  //     } else if (targetAngle == 19 || targetAngle == 20) {  
  //       zeroStepperFast(20);
  //     } else if (targetAngle == -31 || targetAngle == -30 || targetAngle == -29) {
  //       zeroStepperFast(-30);
  //     } else if (targetAngle == 29 || targetAngle == 30 || targetAngle == 31) {
  //       zeroStepperFast(30);
  //     } else if(targetAngle == 9 || targetAngle == 10 || targetAngle == 11){
  //       zeroStepperFast(10);
  //     }

  //     isMovingStepper = false; // Movement completed
  //   }
  // }

  // Check for serial input
  if (Serial.available() > 0) {
    String command = Serial.readStringUntil('\n'); // Read user input
    command.trim(); // Remove any extra spaces or newline characters

    if (command == "S") {
      // Stop the motor immediately
      Serial.println("Emergency STOP activated!");
      zeroStepperFast(0); // Assume this stops the motor
      isMovingStepper = false;
    } else {
      // Try parsing a target angle from the input
      float userAngle = command.toFloat();
      Serial.print("Moving to user-specified angle: ");
      Serial.println(userAngle);
      zeroStepperFast(userAngle); // Move to the specified angle
      isMovingStepper = true;
    }
  }
}


// First iteration of zeroing the motor. Fast movement until zero is reached
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

// Second interation of zeroing the motor. Slow movement until zero is reached
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

  // currentAngle = targetAngle;
}

// Move the stepper motor to the target angle
void moveStepper(float targetAngle) {
  int steps = stepsToMove(targetAngle);  // Calculate steps needed
  int direction = (steps > 0) ? LOW : HIGH;
  steps = abs(steps);                     // Use absolute step count
  
  digitalWrite(dirPin, direction);        // Set motor direction
  for (int i = 0; i < steps; i++) {
    digitalWrite(stepPin, LOW);
    delayMicroseconds(5);              // Pulse width for step
    digitalWrite(stepPin, HIGH);
    delayMicroseconds(5);              // Delay before next step

    // Calculate dynamic delay to ramp speed
    int remainingSteps = steps - i;
    int dynamicDelay = map(remainingSteps, 0, steps, 1, 0.4); // Adjust the range as needed

    delay(dynamicDelay);                           // Adjust for slower/faster motion
  }
}

void moveStepper2(float targetAngle) {
  int steps = stepsToMove(targetAngle);  // Calculate steps needed
  int direction = (steps > 0) ? HIGH : LOW;
  steps = abs(steps);                     // Use absolute step count
  
  digitalWrite(dirPin, direction);        // Set motor direction
  for (int i = 0; i < steps; i++) {
    digitalWrite(stepPin, LOW);
    delayMicroseconds(5);              // Pulse width for step
    digitalWrite(stepPin, HIGH);
    delayMicroseconds(5);              // Delay before next step

    // Calculate dynamic delay to ramp speed
    int remainingSteps = steps - i;
    int dynamicDelay = map(remainingSteps, 0, steps, 1, 0.4); // Adjust the range as needed

    delay(dynamicDelay);                           // Adjust for slower/faster motion
  }
}

void moveStepperRampUpDown(float targetAngle) {
  int steps = stepsToMove(targetAngle);  // Calculate steps needed
  int direction = (steps > 0) ? HIGH : LOW;
  steps = abs(steps);                     // Use absolute step count

  digitalWrite(dirPin, direction);        // Set motor direction

  int accelerationSteps = 100;       // Steps to ramp up to speed
  int decelerationSteps = 100;       // Steps to ramp down to stop
  int startDelay = 1000;             // Starting delay in microseconds
  int minDelay = 200;                // Minimum delay at max speed

  for (int i = 0; i < steps; i++) {
    int currentDelay = startDelay;

    // Ramp up
    if (i < accelerationSteps) {
      currentDelay = startDelay - ((startDelay - minDelay) * i / accelerationSteps);
    }
    // Ramp down
    else if (i > steps - decelerationSteps) {
      currentDelay = minDelay + ((startDelay - minDelay) * (i - (steps - decelerationSteps)) / decelerationSteps);
    } 
    // Constant speed in the middle
    else {
      currentDelay = minDelay;
    }

    digitalWrite(stepPin, LOW);
    delayMicroseconds(5);               // Pulse width for step
    digitalWrite(stepPin, HIGH);
    delayMicroseconds(currentDelay);    // Delay for speed control
  }
}


void ZeroMotorOnce(){
  //Hall State setup
  // while(true){
  //   int hallstate = analogRead(X_PIN);
  //   // Serial.println("Zeroing...");
  //   Serial.println(hallstate);
  //   if(hallstate < 200){
  //     zeroStepperSlow(-3);
  //     zeroStepperSlow(0);
  //     Serial.println("Motor zeroed at current position");
  //     break;
  //   }
  // zeroStepperFast(-1);
  // delay(50);
  // }
  //Accelerometer setup
  while(true){
    int accelAngle = map(analogRead(Accel_PIN),260,396,-90,90);
    Serial.println("Zeroing... X Tilt Angle: ");
    // Serial.println(accelAngle);
    if (accelAngle >= -2 && accelAngle <= 2) {                      // Threshold for zeroing
      zeroStepperSlow(0);                        // Set current position as zero
      Serial.println("Motor zeroed at current position.");  // Confirm zeroing
      break;
    }
    zeroStepperFast(1);
    delay(50);
  }
  currentAngle = 0;
}

void ZeroMotorTwice(){
  //Hall State Setup:
  // while(true){
  //   int hallstate = analogRead(X_PIN);
  //   // Serial.print("Zeroing Again ...");
  //   // Serial.println(hallstate);
  //   if(hallstate < 200){
  //     zeroStepperSlow(2);
  //     zeroStepperSlow(0);
  //     Serial.println("Motor zeroed at current position");
  //     break;
  //   }
  // zeroStepperSlow(-1);
  // delay(50);
  // }
  while(true){
    int accelAngle = map(analogRead(Accel_PIN),260,396,-90,90);
    Serial.println("Zeroing... Again ");
    // Serial.println(accelAngle);
    if (accelAngle >= -2 && accelAngle <= 2) {                      // Threshold for zeroing
      zeroStepperSlow(0);                        // Set current position as zero
      Serial.println("Motor zeroed at current position.");  // Confirm zeroing
      break;
    }
    zeroStepperSlow(1);
    delay(50);
  }
  currentAngle = 0;
}