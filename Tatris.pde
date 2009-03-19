//Block block = new Block(125,215,50,"#2020AA");

NESJoystick nes;

ArrayList pieces = new ArrayList();

Piece lpiece = new LPiece(32.0f,128.0f);
Piece lpiece2 = new LPiece(96.0f,128.0f);
Piece lpiece3 = new LPiece(160.0f,128.0f);
Piece lpiece4 = new LPiece(224.0f,128.0f);

float blockSize=16.0f;

GameState gameState = new PlayState();

void setup(){ 
  //setup game display area, background colour and framerate 
  size(384, 512); 
  frameRate(60);
  fill(0); 
  strokeWeight(3);	// keep an odd number for best look
  stroke(0,150);		// black border, mostly opaque
  //rectMode(CENTER); 
  smooth();
  //strokeCap(ROUND);

  pieces.add(new LPiece(225.0f,315.0f));
  //pieces.add(new SquarePiece(125.0f,115.0f));
  //pieces.add(new SPiece(55.0f,75.0f));
  //pieces.add(new ZPiece(55.0f,445.0f));
  //pieces.add(new ReverseLPiece(225.0f,445.0f));
  //pieces.add(new TPiece(55.0f,245.0f));	
  //pieces.add(new LinePiece(255.0f,65.0f));	
  /*
	pieces.add(new Piece(125,215,"square"));
   	pieces.add(new Piece(60,70,"s"));
   	pieces.add(new Piece(60,270,"z"));
   	pieces.add(new Piece(90,470,"revl"));
   	pieces.add(new Piece(250,70,"line"));
   	pieces.add(new Piece(250,470,"t"));
   	*/

  nes = new NESJoystick(this);




  //((Piece)pieces.get(0)).setX(124.0f);
  //((Piece)pieces.get(0)).setY(164.0f);	
  //println(((Piece)pieces.get(0)).getY());
} 

// TODO: framerate independant drawing
void draw(){ 
  background(25);

	strokeWeight(3);
  // fucking grid
  for (int i=0; i < height; i++) {
    if ( (i%16) == 0) {
      line(i,0,i,height);
      line(0,i,width,i);
    }
  } 
strokeWeight(1);

	lpiece.draw();
	lpiece2.setRotation(radians(90));
	lpiece2.draw();
	lpiece3.setRotation(radians(180));
	lpiece3.draw();
	lpiece4.setRotation(radians(270));
	lpiece4.draw();


  //((Piece)pieces.get(0)).setX(nes.getTotalY() + width/2);
  //((Piece)pieces.get(0)).setY(nes.getTotalX() + height/2);



  if (nes.aButtonPressed()) {

	lpiece.setRotation(lpiece.getRotation() + radians(90));
    //((Piece)pieces.get(0)).setRotation(radians(90));
  }


  if (nes.bButtonPressed()) {
	lpiece.setRotation(lpiece.getRotation() - radians(90));

    //Piece tmp = (Piece)pieces.get(0);
    //tmp.setRotation(radians(270));
  }	


/*
  for (int i=0; i < pieces.size(); i++) {
    //pushMatrix();
    ((Piece)pieces.get(i)).draw();
    //popMatrix();
  }	
*/

}

void keyPressed() {
	if (keyCode == LEFT) {
		lpiece.setX(lpiece.getX() - blockSize);
	}
	
	if (keyCode == RIGHT) {
		lpiece.setX(lpiece.getX() + blockSize);
	}
	
	if (keyCode == UP) {
		lpiece.setRotation(lpiece.getRotation() + radians(90));
	}
	
	if (keyCode == DOWN) {
		lpiece.setY(lpiece.getY() + blockSize);
	}
	
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




