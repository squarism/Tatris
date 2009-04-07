//Block block = new Block(125,215,50,"#2020AA");

//NESJoystick nes;

//ArrayList pieces = new ArrayList();

GameState gameState;

// we keep track of the time elapsed between frames so we can achieve smooth animation
int now;   // the current time
int then;  // the time from the last frame
float fps; // frames per second

PFont smallFont;	// pixel font
PFont regFont;		// readable font
PFont crackedFont;	// huge font
PFont visitorFont;

// Game Options
boolean soundEnabled = false;
boolean musicEnabled = false;
boolean fpsEnabled = false;

// Game Controls
int controlLeft = LEFT;
int controlRight = RIGHT;
int controlDown = DOWN;
int controlRotate = KeyEvent.VK_UP;
int controlDrop = KeyEvent.VK_SPACE;

PApplet tatris;

String ver = "v0.3";

void setup(){ 
  	//setup game display area, background colour and framerate
  	size(320, 496); 
  	frameRate(60);
  	fill(0); 
	noSmooth();
	smallFont = loadFont("04b-08-8.vlw");
	crackedFont = loadFont("Cracked-48.vlw");
	regFont = loadFont("MyriadPro-Regular-12.vlw");
	visitorFont = loadFont("VisitorTT1-BRK--48.vlw");
	textFont(smallFont,8);
	tatris = this;
	
	// start off our game
	gameState = new PlayState();
  //nes = new NESJoystick(this);
} 

// This handy drawing routine draws text centered horizontally on the screen
void textCentered(String txt, float y, color textColor, color borderColor) {
  float x = width/2-textWidth(txt)/2;
  text(txt, x, y);
}

// TODO: framerate independant drawing
void draw(){ 
	
  // note how much time has passed since our last loop
  then = now;

  float elapsed = 0;

  // wait for at least 1/100th of a second to pass
  while( elapsed < 1.0/100.0 ) {
    now = millis();

    // compute elapsed time in seconds
    elapsed = (now - then) / 1000.0f;
  }

  // compute frames per second by averaging over the past + current
  fps = .95*fps + .05/elapsed;



  // slow the game down if the computer can't keep up a reasonable frame rate
  // by limiting the elapsed time to 1/12th of a second (12fps)
  if( elapsed > 1.0/12.0 ) elapsed = 1.0/12.0;	
	
	gameState.update(elapsed);
	gameState.paint();
	gameState = gameState.nextState();

  //((Piece)pieces.get(0)).setX(nes.getTotalY() + width/2);
  //((Piece)pieces.get(0)).setY(nes.getTotalX() + height/2);


/*
  if (nes.aButtonPressed()) {

	lpiece.setRotation(lpiece.getRotation() + radians(90));
    //((Piece)pieces.get(0)).setRotation(radians(90));
  }


  if (nes.bButtonPressed()) {
	lpiece.setRotation(lpiece.getRotation() - radians(90));

    //Piece tmp = (Piece)pieces.get(0);
    //tmp.setRotation(radians(270));
  }	
*/

/*
  for (int i=0; i < pieces.size(); i++) {
    //pushMatrix();
    ((Piece)pieces.get(i)).draw();
    //popMatrix();
  }	
*/

}

void keyPressed() {
	gameState.keyPressed();
}

/* joystick control
 NESJoystick nes; 
 
 nes = new NESJoystick(this);
 
 if (nes.aButtonPressed()) {
 println("A");
 fill(255,0,0); 
 } 
 else { 
 fill(0); 
 } 
 
 if (nes.bButtonPressed()) println("B");  
 if (nes.selectButtonPressed()) println("SELECT");  
 if (nes.startButtonPressed()) println("START");  
 
 float x = nes.getTotalY() + width/2; 
 float y = nes.getTotalX() + height/2; 
 
 rect(x,y,20,20); 
 */

private static String getKeyText(int code) {
      switch (code) {
         case KeyEvent.VK_ACCEPT: return "Accept";
         case KeyEvent.VK_BACK_QUOTE: return "Back_Quote";
         case KeyEvent.VK_BACK_SPACE: return "Backspace";
         case KeyEvent.VK_CAPS_LOCK: return "Caps_Lock";
         case KeyEvent.VK_CLEAR: return "Clear";
         case KeyEvent.VK_CONVERT: return "Convert";
         case KeyEvent.VK_DELETE: return "Delete";
         case KeyEvent.VK_DOWN: return "Down";
         case KeyEvent.VK_END: return "End";
         case KeyEvent.VK_ENTER: return "Enter";
         case KeyEvent.VK_ESCAPE: return "Escape";
         case KeyEvent.VK_F1: return "F1";
         case KeyEvent.VK_F2: return "F2";
         case KeyEvent.VK_F3: return "F3";
         case KeyEvent.VK_F4: return "F4";
         case KeyEvent.VK_F5: return "F5";
         case KeyEvent.VK_F6: return "F6";
         case KeyEvent.VK_F7: return "F7";
         case KeyEvent.VK_F8: return "F8";
         case KeyEvent.VK_F9: return "F9";
         case KeyEvent.VK_F10: return "F10";
         case KeyEvent.VK_F11: return "F11";
         case KeyEvent.VK_F12: return "F12";
         case KeyEvent.VK_FINAL: return "Final";
         case KeyEvent.VK_HELP: return "Help";
         case KeyEvent.VK_HOME: return "Home";
         case KeyEvent.VK_INSERT: return "Insert";
         case KeyEvent.VK_LEFT: return "Left";
         case KeyEvent.VK_NUM_LOCK: return "Num_Lock";
         case KeyEvent.VK_MULTIPLY: return "NumPad_*";
         case KeyEvent.VK_PLUS: return "NumPad_+";
         case KeyEvent.VK_COMMA: return "NumPad_,";
         case KeyEvent.VK_SUBTRACT: return "NumPad_-";
         case KeyEvent.VK_PERIOD: return "Period";
         case KeyEvent.VK_SLASH: return "NumPad_/";
         case KeyEvent.VK_PAGE_DOWN: return "Page_Down";
         case KeyEvent.VK_PAGE_UP: return "Page_Up";
         case KeyEvent.VK_PAUSE: return "Pause";
         case KeyEvent.VK_PRINTSCREEN: return "Print_Screen";
         case KeyEvent.VK_QUOTE: return "Quote";
         case KeyEvent.VK_RIGHT: return "Right";
         case KeyEvent.VK_SCROLL_LOCK: return "Scroll_Lock";
         case KeyEvent.VK_SPACE: return "Space";
         case KeyEvent.VK_TAB: return "Tab";
         case KeyEvent.VK_UP: return "Up";
         default: return java.awt.event.KeyEvent.getKeyText(code);
      }
}

/**

* Call the PApplet main method.

*/



public static void main( String[] args ) {
	System.out.println( "\nOpenCV meet Processing PApplet\n" );
	PApplet.main( new String[]{"Tatris"} );
}




