public class PlayState implements GameState {

	Piece currentPiece;

	float blockSize;
	
	Block deadGrid[][];		// the grid are the blocks that are done on the field
	Float gridSizeX;
	Float gridSizeY;
	
	Point2d playField[] = new Point2d[2];
	
	float timer;
	
	public PlayState() {
		currentPiece = new LPiece(width/2,32.0f);

		blockSize=16.0f;
		
		gridSizeX = new Float(width/blockSize);
		gridSizeY = new Float(height/blockSize);		
		deadGrid = new Block[gridSizeX.intValue() + 1][gridSizeY.intValue() + 1];

		playField[0] = new Point2d(blockSize, blockSize);	// start
		playField[1] = new Point2d(256,480);				// end
		
		println(gridSizeX.intValue() + " " + gridSizeY.intValue());
		
		timer = 1.0f;
	}
	
	public void update(float elapsed) {
		currentPiece.update();
		
		timer -= elapsed;

		// hit bottom, copy to deadGrid
		if (currentPiece.getMaxY() > playField[1].getY() - blockSize * 2) {
			copyToGrid();
			// check for done lines
			currentPiece = new LPiece(width/2,32.0f);
		} 
		
		if (timer <= 0) {
			
			// move down one
			//Piece testPiece = new Piece();
			//testPiece = (LPiece)currentPiece.clone();
			//testPiece.setY(testPiece.getY() + blockSize);
			

			// won't hit, move down
			if (! gridCollideY(currentPiece.getBlocks())) {
				currentPiece.setY(currentPiece.getY() + blockSize);
			} else {
				copyToGrid();
				currentPiece = new LPiece(width/2,32.0f);
			}
			
			timer = 1;
			
		}
	}
	
	// order of drawing in paint() is important
	// last drawn appears on top
	public void paint() {
		background(25);

		drawPlayField();

		currentPiece.draw();
		
		for (int x=0; x < gridSizeX.intValue(); x++) {
			for (int y=0; y < gridSizeY.intValue(); y++) {
				if (deadGrid[x][y]!=null) deadGrid[x][y].draw();
			}
		}


			
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
			// When player presses down, reset timer to make gameplay more
			// predictable and smooth.  Pieces can fall "twice" otherwise.
			timer = 1;

			if (currentPiece.getMaxY() + blockSize < playField[1].getY()) {
				currentPiece.setY(currentPiece.getY() + blockSize);
			}

			
			// user pressed down, check for grid collide
			if (gridCollideY(currentPiece.getBlocks())) {
				println("collision on grid");
				copyToGrid();
				currentPiece = new LPiece(width/2,32.0f);
			}
			
		}
	}
	public void keyReleased() {

	}
	
	void copyToGrid() {
		Block copyBlock[] = currentPiece.getBlocks();

		for (int i=0; i < 4; i++) {
			Float fx = copyBlock[i].getX() / blockSize;
			Float fy = copyBlock[i].getY() / blockSize;
			int x = fx.intValue();
			int y = fy.intValue();

			//deadGrid[x][y] = new Block(x*blockSize, y*blockSize, blockSize, copyBlock[i].getFillColor());
			deadGrid[x][y] = new Block(x*blockSize, y*blockSize, blockSize, "#444444");
		}
	}

	// check for blocks below current piece				
	boolean gridCollideY(Block checkBlocks[]) {	
		//Block copyBlock[] = currentPiece.getBlocks();
		
		boolean hit = false;
			
		for (int i=0; i < 4; i++) {
			Float fx = checkBlocks[i].getX() / blockSize;
			Float fy = checkBlocks[i].getY() / blockSize;
			
			
			//println("block" + i + " " + fx * blockSize + " " + fy * blockSize);
			int x = fx.intValue();
			int y = fy.intValue() + 1;

			// we hit something on the grid
			if(deadGrid[x][y] != null) {
				
				//println(deadGrid[x][y].getX());
				//println(deadGrid[x][y].getY());
				hit = true;
			}		
		}
		
		if (hit == true) {
			return true;
		} else {
			return false;
		}
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