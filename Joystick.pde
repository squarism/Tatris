import procontroll.*; 
import java.io.*; 

class Joystick {
  //Create gamepad variables 
  ControllIO controll; 
  ControllDevice device; 
  ControllStick stick; 

  // all buttons on device
  ArrayList buttons;
  
  Joystick() {
    buttons = new ArrayList();
  }
  
  float getTotalY() {
    return stick.getTotalY();
  }
  
  float getTotalX() {
    return stick.getTotalX();
  }
  
}

