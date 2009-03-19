//Block block = new Block(125,215,50,"#2020AA");

ArrayList pieces = new ArrayList();


void setup(){ 
  //setup game display area, background colour and framerate 
  size(300, 500); 
  fill(0); 
  strokeWeight(1.5);
  stroke(20,170);
  rectMode(CENTER); 

	pieces.add(new Piece(225,315,"l"));
	pieces.add(new Piece(125,215,"square"));
	pieces.add(new Piece(60,70,"s"));
	pieces.add(new Piece(60,270,"z"));
	pieces.add(new Piece(90,470,"revl"));
	pieces.add(new Piece(250,70,"line"));
	pieces.add(new Piece(250,470,"t"));
	
} 

void draw(){ 
  	background(25);
	for (int i=0; i < pieces.size(); i++) {
		((Piece)pieces.get(i)).draw();
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



