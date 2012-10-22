// TODO: add mouse-click event so it clicks in window and gives it focus when it sees movement
// add "flick" physics

//IR sensor
import java.awt.AWTException;
import java.awt.Robot;
import processing.serial.*;
import java.awt.MouseInfo;
import java.awt.event.InputEvent; 
import java.awt.PointerInfo.*;

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

void draw(){
}

int lastVal = 1000;
int currentVal;

void serialEvent(Serial p) {
  String message = myPort.readStringUntil('\n'); // read serial data
  if(message != null) {
    String [] data  = splitTokens(message,",\n"); // Split the comma-separated message
    //trim(data[2]);
    println(data[0]);
    if (data[0].equals("Data")){
      posX = Integer.parseInt(data[1]);
      print("X:"); println(posX);
      posY = Integer.parseInt(data[2]);
      print("Y:"); println(posY);
      if( data.length > 3){
        println("length greater than 3");
        // numberToBeConverted, minSampleData, maxSampleData, minToConvertTo,maxToConvertTo  
        map(posX, 25, 120, 0, 100); 
        myPort.write(posX);
      }
    }
  }
  
}


int meetsThreshold;
int downSample(int handSensor) {
    if (handSensor % 3 == 0){
      int meetsThreshold = 1;
      println("meets threshold");
    } else if (handSensor % 3 != 0){
      meetsThreshold = 0;
      println("doesnt meet threshold");
    }
    return meetsThreshold;
}

