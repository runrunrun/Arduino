
int ledPin = 12;

// The setup function runs once when you press reset or power the board
void setup() {
  pinMode(ledPin, OUTPUT);
}

// The loop function runs over and over again forever
void loop() {
  digitalWrite(ledPin, HIGH);
  delay(1000);
  digitalWrite(ledPin, LOW);
  delay(1000);
}
