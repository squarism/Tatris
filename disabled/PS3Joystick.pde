/* PS3 pad
 L2 = 8          R2 = 9
 L1 = 10         R1 = 11
 up = 4          down = 6  
 left = 7        right = 5
 triangle = 12   square = 15
 circle = 13     x = 14
 select = 0      start = 3                                           
 L3 = 1          R3 = 2
 PS = 16      
 */
import procontroll.*; 
import java.io.*; 

class PS3Joystick extends Joystick {

  // ps3 gamepad specific buttons here
  ControllButton xButton;

  public PS3Joystick(PApplet sketch) {

    //seek out gamepad controlls 
    controll = ControllIO.getInstance(sketch);  

    for (int i=0; i < controll.getNumberOfDevices(); i++) {
      device = controll.getDevice(i);
      if (device.getName().equals("PLAYSTATION(R)3 Controller")) {
        i = controll.getNumberOfDevices();
        print(device.getName());
      }
    }

    // assign buttons
    assignButtons(device);
  }

  void assignButtons(ControllDevice dev) {
    // load values into variables 
    stick = dev.getStick(0); 
    stick.setTolerance(0.15f); 
    
    // add all buttons into array
    for (int i=0; i < dev.getNumberOfButtons(); i++){
      buttons.add(dev.getButton(i));
    }
    
    xButton = (ControllButton)buttons.get(14);


  }
  
  boolean xButtonPressed() {
    if(xButton.pressed()){ 
      return true;
    } else {
      return false;
    }
  }
  


}



