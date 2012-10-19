// TODO: add mouse-click event so it clicks in window and gives it focus when it sees movement
// add "flick" physics

import java.awt.AWTException;
import java.awt.Robot;
import processing.serial.*;

Robot robby;
Serial myPort;   // Create object from Serial class
int posX; // data from msg fields will be stored here  

void setup() {
  myPort = new Serial(this, Serial.list()[4], 9600);
  myPort.bufferUntil('\n');
  size(500, 500);
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

void draw(){
  //println("scrollme: " + scrollMe);
  if(checkScroll != scrollMe && scrollMe % 2 == 0){
    scrollMe = scrollMe/2;
    
    println(scrollMe);
    robby.mouseWheel(scrollMe);
  }
  checkScroll = scrollMe;
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
