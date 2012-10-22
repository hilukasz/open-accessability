// TODO: add mouse-click event so it clicks in window and gives it focus when it sees movement
// add "flick" physics

import java.awt.AWTException;
import java.awt.Robot;
import processing.serial.*;

Robot robby;
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
  }
  catch (AWTException e){
    println("Robot class not supported by your system!");
    exit();
  }
}

int checkScroll;
int scrollMe;
int active, top, bottom;

void draw(){
  //println("scrollme: " + scrollMe);
  if(checkScroll != scrollMe && scrollMe % 2 == 0){
    scrollMe = scrollMe/2;
    
    println("scroll me: "+scrollMe);
    robby.mouseWheel(scrollMe);
    delay(100);
    robby.mouseWheel(scrollMe/3);
    delay(100);
    robby.mouseWheel(scrollMe/4);
    delay(100);
    robby.mouseWheel(scrollMe/5);
    
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

  println("active color: "+active);
  fill(top);
  rect(0, 0, windowWidth, windowHeight/2);
  fill(bottom);
  rect(0, windowHeight/2, windowWidth,  windowHeight/2);
  //background(active);
  //delay(400);
}

int lastVal = 1000;
int currentVal;

void serialEvent(Serial p) {
  String message = myPort.readStringUntil('\n'); // read serial data
  if(message != null) {
    String [] data  = splitTokens(message,",\n"); // Split the comma-separated message
    if ( data[0].equals("Data")){
      if( data.length > 1 ){
        try {
          posX = Integer.parseInt(data[1]);
          if(posX > 100) {
             scrollMe = 0;
             //println("scroll me is 0");
          }
          if(posX < 100){
            if(posX > lastVal){
              scrollMe = scrollMe - 1;
              //println("scroll me is -1");
            }
            if(posX < lastVal){
              scrollMe = scrollMe + 1;
              //println("scroll me is 1");
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


