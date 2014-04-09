#include <Servo.h>
#include <SPI.h>
#include <boards.h>
#include <ble_shield.h>
#include <services.h>

Servo servo;
int pos = 0;
const int servoPin = 6;

void setup()
{
  // Init. and start BLE library.
  ble_begin();

  // Enable serial debug
  Serial.begin(9600);

  servo.attach(servoPin);  
}

void loop()
{

  while(ble_available())
  {
    // read out command and data
    byte data0 = ble_read();
    byte data1 = ble_read();
    byte data2 = ble_read();
    
//    Serial.println(data0);
//    Serial.println(data1);
//    Serial.println(data2);

    int unlockAngle = 120;
    int lockAngle = 10;
    

    if (data0 == 0x00)  // Unlock
    {
      Serial.println("Unlock");
      for (pos = lockAngle; pos < unlockAngle; pos++) {
        servo.write(pos);
        delay(10);
      }
      
    }
    else if(data0 == 0x01) { //Lock
      Serial.println("lock");
      for (pos = unlockAngle; pos > lockAngle; pos -=1){
        servo.write(pos);
        delay(10);
      }    
    }
    
//    
//    //reset
//    if (data0 == 0x08)
//    {
////      reset();
//    }    
    
  }
  
  if (!ble_connected())
  {
//    reset();
  }
   
  Serial.println(pos);

  // Allow BLE Shield to send/receive data
  ble_do_events();  
}

void reset()
{
//  digitalWrite(servoPin, LOW);
}
