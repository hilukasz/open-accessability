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
int windowHeight = 500;
int windowWidth = 500;
int lastVal = 1000;
int currentVal,
    posX,
    meetsThreshold;
float posXf, mappedPosXf;

void setup() {
  myPort = new Serial(this, Serial.list()[4], 9600);
  myPort.bufferUntil('\n');
  size(windowWidth, windowHeight);
}

void draw(){
}

void serialEvent(Serial p) {
  String message = myPort.readStringUntil('\n'); // read serial data
  if(message != null) {
    String [] data  = splitTokens(message,",\n"); // Split the comma-separated message
    if (data[0].equals("Data")){
      posX = Integer.parseInt(data[1]);
      print("X:"); println(posX);
      if( data.length > 2){
        posXf = float(posX);
        mappedPosXf = map(posXf, 150, 740, 0, 180);
        posX = int(mappedPosXf);
        println(posX);
        myPort.write(posX);
      }
    }
  }
  
}

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

