#include <Servo.h>

// Define motor pins
#define IN1 6
#define IN2 7
#define IN3 8
#define IN4 9
# define s1 5
# define s2 10

// Define ultrasonic sensor pins
const int trigPin = A0;
const int echoPin = A1;
// Servo motor
Servo servo;
#define SERVO_PIN 11

// Define distances
#define SAFE_DISTANCE 20 // Safe distance in cm
long duration;
float distance;
void setup() {
  // Initialize motor pins
  pinMode(IN1, OUTPUT);
  pinMode(IN2, OUTPUT);
  pinMode(IN3, OUTPUT);
  pinMode(IN4, OUTPUT);
pinMode(s1, OUTPUT);
pinMode(s2, OUTPUT);
  // Initialize ultrasonic sensor pins
   pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);

  // Attach servo motor
  servo.attach(SERVO_PIN);
  servo.write(90); // Set servo to center position

  Serial.begin(9600); // For debugging
}

void loop() {
    digitalWrite(s1,1);
digitalWrite(s2,1);
  int distance = measureDistance();
  Serial.println("distance");
Serial.println(distance);
  if (distance < SAFE_DISTANCE) {
    stopCar();
    avoidObstacle();
  } else {
    moveForward();
  }
}

void moveForward() {
  digitalWrite(IN1, HIGH);
  digitalWrite(IN2, LOW);
  digitalWrite(IN3, HIGH);
  digitalWrite(IN4, LOW);
}

void stopCar() {
  digitalWrite(IN1, LOW);
  digitalWrite(IN2, LOW);
  digitalWrite(IN3, LOW);
  digitalWrite(IN4, LOW);
}

void turnRight() {
  digitalWrite(IN1, HIGH);
  digitalWrite(IN2, LOW);
  digitalWrite(IN3, LOW);
  digitalWrite(IN4, HIGH);
  delay(500); // Adjust delay for smoother turn
}

void turnLeft() {
  digitalWrite(IN1, LOW);
  digitalWrite(IN2, HIGH);
  digitalWrite(IN3, HIGH);
  digitalWrite(IN4, LOW);
  delay(500); // Adjust delay for smoother turn
}

void avoidObstacle() {
  servo.write(30); // Turn sensor to left
  delay(500);
  int leftDistance = measureDistance();
  Serial.println("leftDistance");
Serial.println(leftDistance);
  servo.write(150); // Turn sensor to right
  delay(500);
  int rightDistance = measureDistance();
  Serial.println("rightDistance");
Serial.println(rightDistance);
  servo.write(90); // Reset sensor to center

  if (leftDistance > rightDistance) {
    turnLeft();
  } else {
    turnRight();
  }
}

int measureDistance() {
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);

  // Trigger the sensor by setting the Trig pin high for 10 microseconds
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  // Read the echo pin
  duration = pulseIn(echoPin, HIGH);

  // Calculate the distance (in cm)
  distance = (duration * 0.034) / 2;

  // Print the distance to the Serial Monitor
  Serial.print("Distance: ");
  Serial.print(distance);
  Serial.println(" cm");

  // Wait a bit before the next measurement
  delay(500);
  return distance;
}
