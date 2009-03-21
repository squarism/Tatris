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

void setup(){ 
  	//setup game display area, background colour and framerate 
  	size(320, 496); 
  	frameRate(60);
  	fill(0); 
	noSmooth();
	smallFont = loadFont("04b-08-8.vlw");
	crackedFont = loadFont("Cracked-48.vlw");
	regFont = loadFont("MyriadPro-Regular-12.vlw");
	textFont(smallFont,8);

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




