/* NES pad
B = 0
A = 1
Select = 2
Start = 3
*/
import procontroll.*; 
import java.io.*; 

class NESJoystick extends Joystick {

  // nes gamepad specific buttons here
  ControllButton aButton;
  ControllButton bButton;
  ControllButton startButton;
  ControllButton selectButton;

  public NESJoystick(PApplet sketch) {

	println("Starting joystick/gamepad setup...");

    //seek out gamepad controlls 
    controll = ControllIO.getInstance(sketch);  

    for (int i=0; i < controll.getNumberOfDevices(); i++) {
		device = controll.getDevice(i);

      if (device.getName().equals("RetroPad")) {
        i = controll.getNumberOfDevices();  // found it, break loop
        //print(device.getName());
	    // assign buttons
		println("Assigning buttons");
    	assignButtons(device);
      }
    }

	println("Done with joystick/gamepad setup.");


  }

  void assignButtons(ControllDevice dev) {
    // load values into variables 
    stick = dev.getStick(0); 
    stick.setTolerance(0.15f); 
    
    // add all buttons into array
    for (int i=0; i < dev.getNumberOfButtons(); i++){
      buttons.add(dev.getButton(i));
    }
    
    bButton = (ControllButton)buttons.get(0);
    aButton = (ControllButton)buttons.get(1);
    selectButton = (ControllButton)buttons.get(2);
    startButton = (ControllButton)buttons.get(3);


  }
  
  boolean aButtonPressed() {
    if(aButton.pressed()){ 
      return true;
    } else {
      return false;
    }
  }
  
  boolean bButtonPressed() {
    if(bButton.pressed()){ 
      return true;
    } else {
      return false;
    }
  }
  
  boolean selectButtonPressed() {
    if(selectButton.pressed()){ 
      return true;
    } else {
      return false;
    }
  }
  
  boolean startButtonPressed() {
    if(startButton.pressed()){ 
      return true;
    } else {
      return false;
    }
  }
  

  


}



