#include <SPI.h>
#include <boards.h>
#include <ble_shield.h>
#include <services.h>
#include <Servo.h> 
 
#define DIGITAL_OUT_PIN1    1
#define DIGITAL_OUT_PIN2    2
#define DIGITAL_OUT_PIN3    3
#define DIGITAL_OUT_PIN4    4
#define DIGITAL_OUT_PIN5    5
#define DIGITAL_OUT_PIN6    6
#define DIGITAL_OUT_PIN7    7

void setup()
{
  // Init. and start BLE library.
  ble_begin();
  
  // Enable serial debug
  Serial.begin(57600);
    
  pinMode(DIGITAL_OUT_PIN1, OUTPUT);
  pinMode(DIGITAL_OUT_PIN2, OUTPUT);
  pinMode(DIGITAL_OUT_PIN3, OUTPUT);
  pinMode(DIGITAL_OUT_PIN4, OUTPUT);
  pinMode(DIGITAL_OUT_PIN5, OUTPUT);
  pinMode(DIGITAL_OUT_PIN6, OUTPUT);
}

void loop()
{  
  // If data is ready
  while(ble_available())
  {
    // read out command and data
    byte data0 = ble_read();
    byte data1 = ble_read();
    byte data2 = ble_read();
    
    Serial.println(data0);
    Serial.println(data1);
    Serial.println(data2);

    
    int pin = DIGITAL_OUT_PIN7;//default
    
    if (data0 == 0x01)  // Command is to control digital out pin
    {
      pin = DIGITAL_OUT_PIN1;
    }
    else if(data0 == 0x02) {
      pin = DIGITAL_OUT_PIN2;
    }
    else if(data0 == 0x03) {
      pin = DIGITAL_OUT_PIN3;
    }
    else if(data0 == 0x04) {
      pin = DIGITAL_OUT_PIN4;
    }
    else if(data0 == 0x05) {
      pin = DIGITAL_OUT_PIN5;
    }
    else if(data0 == 0x06) {
      pin = DIGITAL_OUT_PIN6;
    }
    else if(data0 == 0x07) {
      pin = DIGITAL_OUT_PIN7;
    }
    
    Serial.println(pin);
    
   if (data1 == 0x01)
      digitalWrite(pin, HIGH);
    else
      digitalWrite(pin, LOW);
        
    //reset
    if (data0 == 0x08)
    {
      reset();
    }    
    
  }
  
  if (!ble_connected())
  {
    reset();
  }
  
  // Allow BLE Shield to send/receive data
  ble_do_events();  
}

void reset()
{
  digitalWrite(DIGITAL_OUT_PIN1, LOW);
  digitalWrite(DIGITAL_OUT_PIN2, LOW);
  digitalWrite(DIGITAL_OUT_PIN3, LOW);
  digitalWrite(DIGITAL_OUT_PIN4, LOW);
  digitalWrite(DIGITAL_OUT_PIN5, LOW);
  digitalWrite(DIGITAL_OUT_PIN6, LOW);
  digitalWrite(DIGITAL_OUT_PIN7, LOW);
}

