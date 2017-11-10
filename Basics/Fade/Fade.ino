int led = 9;
int brightness = 0;
int fadeAmount = 5;

void setup() {
  pinMode(led, OUTPUT);
}

void loop() {
  // Set brightness.
  analogWrite(led, brightness);
  
  // Change brightness.
  brightness = brightness + fadeAmount;
  
  // Reverse fadeAmount.
  if (brightness <= 0 || brightness >= 255) {
    fadeAmount = -fadeAmount;
  }
  
  delay(30);
}
