//#include <SPI.h>
//#include <services.h>
//#include <Servo.h> 

//Slave will follow BLEController commands

#include <Wire.h>

int leftMotor = 13;
int leftBrake = 8;
int leftSpeed = 11;

int rightMotor = 12;
int rightBrake = 9;
int rightSpeed = 3;

const int up    = 1;
const int down  = 2;
const int left  = 3;
const int right = 4;

void setup()
{
    //Join i2c bus with address #4
  Wire.begin(4);
  Wire.onReceive(receiveEvent);
  
  // Enable serial debug
  Serial.begin(9600);

  pinMode(leftMotor, OUTPUT);
  pinMode(leftBrake, OUTPUT);
  pinMode(rightMotor, OUTPUT);
  pinMode(rightBrake, OUTPUT);  
}

void loop()
{
  delay(100);  
}

// function that executes whenever data is received from master
// this function is registered as an event, see setup()
void receiveEvent(int driveCommands)
{
  Serial.println("Drive");         // print the character
  
  int dir = Wire.read();    // receive byte as an integer
  Serial.println(dir);
  boolean drive = dir != 0;
  driveRobot(drive, 255, dir);
  
}

void driveRobot(boolean drive, int robotSpeed, int robotDirection)
{
  if (drive){
    switch (robotDirection) {
      case up:{
        digitalWrite(leftMotor, LOW);
        digitalWrite(leftBrake, LOW); 
        analogWrite(leftSpeed, robotSpeed); 
      
        digitalWrite(rightMotor, LOW);
        digitalWrite(rightBrake, LOW); 
        analogWrite(rightSpeed, robotSpeed); 
        break;
      }
      case down:{
        digitalWrite(leftMotor, HIGH); 
        digitalWrite(leftBrake, LOW);
        analogWrite(leftSpeed, robotSpeed);
      
        digitalWrite(rightMotor, HIGH); 
        digitalWrite(rightBrake, LOW); 
        analogWrite(rightSpeed, robotSpeed); 
        break;
      }
      case left:{
        digitalWrite(leftMotor, HIGH); 
        digitalWrite(leftBrake, LOW); 
        analogWrite(leftSpeed, robotSpeed); 
      
        digitalWrite(rightMotor, LOW);
        digitalWrite(rightBrake, LOW);
        analogWrite(rightSpeed, robotSpeed); 
        break;
      }
      case right:{
        digitalWrite(leftMotor, LOW);
        digitalWrite(leftBrake, LOW); 
        analogWrite(leftSpeed, robotSpeed);  
      
        digitalWrite(rightMotor, HIGH);
        digitalWrite(rightBrake, LOW);   
        analogWrite(rightSpeed, robotSpeed);   
        break;
      } 
    }
  }
  else {//stop the robot
    digitalWrite(leftMotor, LOW); 
    digitalWrite(leftBrake, HIGH); 
    
    digitalWrite(rightMotor, HIGH); 
    digitalWrite(rightBrake, HIGH);
  }
}

