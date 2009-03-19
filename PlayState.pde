public class PlayState implements GameState {

	Piece lpiece;
	Piece lpiece2;
	Piece lpiece3;
	Piece lpiece4;
	float blockSize;
	
	public PlayState() {
		 lpiece = new LPiece(32.0f,128.0f);
		 lpiece2 = new LPiece(96.0f,128.0f);
		 lpiece3 = new LPiece(160.0f,128.0f);
		 lpiece4 = new LPiece(224.0f,128.0f);
		blockSize=16.0f;
	}
	
	public void update(float elapsed) {
		
	}
	public void paint() {
		  background(25);

			strokeWeight(1);
		  // fucking grid
		  for (int i=0; i < height; i++) {
		    if ( (i%16) == 0) {
		      line(i,0,i,height);
		      line(0,i,width,i);
		    }
		  } 
		strokeWeight(3);

			lpiece.draw();
			lpiece2.setRotation(radians(90));
			lpiece2.draw();
			lpiece3.setRotation(radians(180));
			lpiece3.draw();
			lpiece4.setRotation(radians(270));
			lpiece4.draw();
			
			fill(255);
			text("fps: " + Math.round(fps * .1)/.1,8,8);
			
		
	}
	public GameState nextState() {
	    if (lpiece.getY() > height) {
	      return new GameOverState();
	    }
	    else{
	      return this;
	    }
	  }
	public void keyPressed() {
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
	public void keyReleased() {

	}
}