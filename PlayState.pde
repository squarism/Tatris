public class PlayState implements GameState {

	Piece currentPiece;
	Piece currentPiece2;
	Piece currentPiece3;
	Piece currentPiece4;
	float blockSize;
	
	Block deadGrid[][];
	Float gridSizeX;
	Float gridSizeY;
	
	Point2d playField[] = new Point2d[2];
	
	public PlayState() {
		currentPiece = new LPiece(width/2,32.0f);

		blockSize=16.0f;
		
		gridSizeX = new Float(width/blockSize);
		gridSizeY = new Float(height/blockSize);		
		deadGrid = new Block[gridSizeX.intValue() + 1][gridSizeY.intValue() + 1];

		playField[0] = new Point2d(blockSize, blockSize);	// start
		playField[1] = new Point2d(256,480);				// end
		
		println(gridSizeX.intValue() + " " + gridSizeY.intValue());
	}
	
	public void update(float elapsed) {
		currentPiece.update();

		// hit bottom, copy to deadGrid
		if (currentPiece.getMaxY() > playField[1].getY() - blockSize * 2) {
			Block copyBlock[] = currentPiece.getBlocks();
			for (int i=0; i < 4; i++) {
				
				// int x = Math.round(copyBlock[i].getX() / blockSize) * blockSize;
				Float fx = copyBlock[i].getX() / blockSize;
				Float fy = copyBlock[i].getY() / blockSize;
				int x = fx.intValue();
				int y = fy.intValue();
				
				deadGrid[x][y] = new Block(x*blockSize, y*blockSize, blockSize, copyBlock[i].getFillColor());
				
				// check for done lines
			}
			currentPiece = new LPiece(width/2,32.0f);
		}
		
		// check for blocks around current piece
		
	}
	
	// order of drawing in paint() is important
	// last drawn appears on top
	public void paint() {
		background(25);


		currentPiece.draw();
		
		for (int x=0; x < gridSizeX.intValue(); x++) {
			for (int y=0; y < gridSizeY.intValue(); y++) {
				if (deadGrid[x][y]!=null) deadGrid[x][y].draw();
			}
		}

		drawPlayField();
			
		fill(255);
		text("fps: " + Math.round(fps * .1)/.1,8,8);

			
		
	}
	public GameState nextState() {
	    if (currentPiece.getY() > height) {
	      //return new GameOverState();
			currentPiece = new LPiece(32.0f,128.0f);
			return this;
	    }
	    else{
	      return this;
	    }
	  }
	public void keyPressed() {
		if (keyCode == LEFT) {
			currentPiece.setX(currentPiece.getX() - blockSize, playField[0].getX());
		}

		if (keyCode == RIGHT) {
			currentPiece.setX(currentPiece.getX() + blockSize, playField[1].getX());
		}

		if (keyCode == UP) {
			if (! currentPiece.rotateCollide(playField[0].getX(), playField[1].getX())) {
				currentPiece.setRotation(currentPiece.getRotation() + radians(90));
			}
		}

		if (keyCode == DOWN) {
			if (currentPiece.getMaxY() + blockSize < playField[1].getY()) {
				currentPiece.setY(currentPiece.getY() + blockSize);
			}
		}
	}
	public void keyReleased() {

	}
	
	void drawPlayField() {
		// grid lines
		strokeWeight(1);
  		stroke(0);
		for (int i=0; i < height; i++) {
			if ( (i%16) == 0) {
		    	line(i,0,i,height);
		    	line(0,i,width,i);
			}
		}
		// border box
		strokeWeight(3);
  		stroke(255);
		line(playField[0].getX(), playField[0].getY(), playField[1].getX(), playField[0].getY());	// top line
		line(playField[1].getX(), playField[0].getY(), playField[1].getX(), playField[1].getY());	// right line
		line(playField[1].getX(), playField[1].getY(), playField[0].getX(), playField[1].getY());	// bottom line		
		line(playField[0].getX(), playField[1].getY(), playField[0].getX(), playField[0].getY());	// left line		
	}
}