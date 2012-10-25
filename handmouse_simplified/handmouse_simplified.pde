// TODO: add mouse-click event so it clicks in window and gives it focus when it sees movement
// add "flick" physics

//IR sensor
import processing.serial.*;

Serial myPort;   // Create object from Serial class
int posX, posY; // data from msg fields will be stored here  
int windowHeight = 500;
int windowWidth = 500;

void setup() {
  myPort = new Serial(this, Serial.list()[4], 9600);
  myPort.bufferUntil('\n');
  size(windowWidth, windowHeight);
}

int checkScroll;
int scrollMe;
int active, top, bottom;
int myMouseX, myMouseY;

void draw() {
}

int lastVal = 1000;
int currentVal;

void serialEvent(Serial p) {
  String message = myPort.readString(); // read serial data
  //println(message);
  if (message != null) {
    //String [] data  = splitTokens(message,",\n"); // Split the comma-separated message

    posX = Integer.parseInt(message);
    print("X:"); 
    println(posX);
    // numberToBeConverted, minSampleData, maxSampleData, minToConvertTo,maxToConvertTo  
    map(posX, 25, 120, 0, 100); 
    myPort.write(posX);
  }
}

