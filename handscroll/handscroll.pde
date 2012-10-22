// TODO: add mouse-click event so it clicks in window and gives it focus when it sees movement
// add "flick" physics

//IR sensor
import java.awt.AWTException;
import java.awt.Robot;
import processing.serial.*;
import java.awt.MouseInfo;
import java.awt.event.InputEvent; 
import java.awt.PointerInfo.*;

//servo stuff
#include <Servo.h> 
Servo myservo;  // create servo object to control a servo 
                // a maximum of eight servo objects can be created 
int pos = 0;    // variable to store the servo position 


Robot robby;
Robot mouseWheel2;
Serial myPort;   // Create object from Serial class
int posX; // data from msg fields will be stored here  
int windowHeight = 500;
int windowWidth = 500;

void setup() {
  myPort = new Serial(this, Serial.list()[4], 9600);
  myPort.bufferUntil('\n');
  size(windowWidth, windowHeight);
  try {
    robby = new Robot();
    mouseWheel2 = new Robot();
  }
  catch (AWTException e){
    println("Robot class not supported by your system!");
    exit();
  }
}

int checkScroll;
int scrollMe;
int active, top, bottom;
int myMouseX, myMouseY;
int lastMouseX, lastMouseY;

void draw(){
  //get global mouse position 
  myMouseX = MouseInfo.getPointerInfo().getLocation().x;
  myMouseY = MouseInfo.getPointerInfo().getLocation().y;

  if(checkScroll != scrollMe){
    robby.mouseWheel(scrollMe);
    // check to see user has moved the mouse, if it has then click (focus window hack) could use 
    // some improvement here
    if( lastMouseX != myMouseX && lastMouseY != myMouseY){
      try {
          Robot clickRobot = new Robot();
          // Simulate a mouse click
          clickRobot.mousePress(InputEvent.BUTTON1_MASK);
          clickRobot.mouseRelease(InputEvent.BUTTON1_MASK);
      } catch (AWTException e) {
          e.printStackTrace();
      }
      lastMouseX = myMouseX;
      lastMouseY = myMouseX;
    }
    
    if(scrollMe == 0){
      top = 0;
      bottom = 0;
    }
    if(scrollMe > 0){
      top = 0;
      bottom = 255;
    }
    if (scrollMe < 0){ 
      top = 255;
      bottom = 0;
    }
  }
  checkScroll = scrollMe;
  //println("active color: "+active);
  fill(top);
  rect(0, 0, windowWidth, windowHeight/2);
  fill(bottom);
  rect(0, windowHeight/2, windowWidth,  windowHeight/2);
}

int lastVal = 1000;
int currentVal;

void serialEvent(Serial p) {
  String message = myPort.readStringUntil('\n'); // read serial data
  if(message != null) {
    String [] data  = splitTokens(message,",\n"); // Split the comma-separated message
    if ( data[0].equals("Data")){
      posX = Integer.parseInt(data[1]);
      println(posX);
      if( data.length > 1 && downSampleint(posX){
        try {
          if(posX > 120) {
             scrollMe = 0;
          }
          if(posX < 100){
            if(posX > lastVal){
              scrollMe = scrollMe - 1;
            }
            if(posX < lastVal){
              scrollMe = scrollMe + 1;
            }
          }
          lastVal = posX;
        }
        catch (Throwable t) {
          print("parse error");
        }          
      }
    }
  }
}



int downSampleint handSensor) {
    if (handSensor % 3 == 0){
      int meetsThreshold = 1;
      Serial.println("meets threshold");
    } else if (handSensor % 3 != 0){
      meetsThreshold = 0;
      Serial.println("doesnt meet threshold");
    }
    return meetsThreshold;
}

