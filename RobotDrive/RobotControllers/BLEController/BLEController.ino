#include <SPI.h>
#include <boards.h>
#include <ble_shield.h>
#include <services.h>
#include <Servo.h> 
#include <Wire.h>

//BLE controllers will be the master
//RobotDrive

//Direction constants
const int up       = 1;
const int down     = 2;
const int left     = 3;
const int right    = 4;
const int stopping = 0;

void setup()
{
  // Init. and start BLE library.
  ble_begin();
  
  //Join i2c bus
  Wire.begin();
  
  // Enable serial debug
  Serial.begin(9600);
}

void loop()
{ 

  // If data is ready
  while(ble_available())
  {
    Wire.beginTransmission(4); // transmit to device #4

    // read out command and data
    byte data0 = ble_read();
    byte data1 = ble_read();
    byte data2 = ble_read();

    boolean drive = data1 == 0x01;
        
    if(drive) {
       if(data0 == 0x01) {
          Wire.write(up);
       }
        else if(data0 == 0x02) {
          Wire.write(down);
        }
        else if(data0 == 0x03) {
          Wire.write(left);
        }
        else if(data0 == 0x04) {
          Wire.write(right);
        }
    }
    else {
      Wire.write(stopping);
    }
    
    Wire.endTransmission();    // stop transmitting
  }
  
  
  if (!ble_connected())
  {
    reset();
  }
  
  // Allow BLE Shield to send/receive data
  ble_do_events();  

  delay(500);
}

void reset()
{

}
