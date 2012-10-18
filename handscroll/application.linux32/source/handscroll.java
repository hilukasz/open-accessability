import processing.core.*; 
import processing.data.*; 
import processing.opengl.*; 

import java.awt.AWTException; 
import java.awt.Robot; 
import processing.serial.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class handscroll extends PApplet {

// TODO: add mouse-click event so it clicks in window and gives it focus when it sees movement
// add "flick" physics





int xx = 10, yy = 10;
Robot robby;

Serial    myPort;   // Create object from Serial class
Robot myMouse;  // create arduino controlled mouse  
                             
public static final short LF = 10;        // ASCII linefeed
public static final short portIndex = 4;  // select the com port, 

int posX, posY, btn; // data from msg fields will be stored here  

public void setup() {
  myPort = new Serial(this, Serial.list()[4], 9600);
  myPort.bufferUntil('\n');
  
  size(500, 500);
  try
  {
    robby = new Robot();
  }
  catch (AWTException e)
  {
    println("Robot class not supported by your system!");
    exit();
  }
}
int checkScroll;
public void draw()
{
  if(checkScroll != scrollMe){
    robby.mouseWheel(scrollMe);
  }
  checkScroll = scrollMe;
  println(scrollMe);
}

int lastVal = 1000;
int currentVal;
int scrollMe = 0;
public void serialEvent(Serial p) {
  String message = myPort.readStringUntil('\n'); // read serial data
  //println(message);
  if(message != null)
  {
    //print(message);
    String [] data  = message.split(","); // Split the comma-separated message
    if ( data[0].equals("Data"))// check for data header    
    {
      if( data.length > 3 )
      {
        try {
          posX = Integer.parseInt(data[1]);  
          posX = Math.round(posX);
          println("X: "+posX);
          if(posX > 100) {
             scrollMe = 0;
          }
          if(posX <100){
            if(posX > lastVal){
              scrollMe = scrollMe - 1;
            }
            if(posX < lastVal){
              scrollMe = scrollMe + 1;
            }
            /*if(posX == lastVal){
              scrollMe = 0;
            }*/
          
          }
          posY = Integer.parseInt(data[2]); 
          btn  = Integer.parseInt(data[3]);
          lastVal = posX;
        }
        catch (Throwable t) {
          println("."); // parse error
          print(message);
        }          
      }
    }
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "handscroll" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
