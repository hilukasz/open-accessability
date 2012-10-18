// TODO: add mouse-click event so it clicks in window and gives it focus when it sees movement
// add "flick" physics

import java.awt.AWTException;
import java.awt.Robot;
import processing.serial.*;

int xx = 10, yy = 10;
Robot robby;

Serial    myPort;   // Create object from Serial class
Robot myMouse;  // create arduino controlled mouse  
                             
public static final short LF = 10;        // ASCII linefeed
public static final short portIndex = 4;  // select the com port, 

int posX, posY, btn; // data from msg fields will be stored here  

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

void draw(){
  println("scrollme: " + scrollMe);
  if(checkScroll != scrollMe && scrollMe % 2 == 0){
    robby.mouseWheel(scrollMe);
  }
  checkScroll = scrollMe;
  println("checkScroll: " + checkScroll);
}

int lastVal = 1000;
int currentVal;
int scrollMe;

void serialEvent(Serial p) {
  String message = myPort.readStringUntil('\n'); // read serial data
  if(message != null)
  {
    String [] data  = message.split(","); // Split the comma-separated message
    print(data[1]);
    if ( data[0].equals("Data"))// check for data header    
    {
      if( data.length > 1 ){
        //print("passed");
        try {
          //posX = Integer.parseInt(data[1]);  
          //print("passed");
          //print("X: " + posX);
          if(posX > 100) {
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
          print("."); // parse error
          //print(message);
        }          
      }
    }
  }
}
