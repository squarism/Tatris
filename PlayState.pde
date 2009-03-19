public class PlayState implements GameState {
	
	Piece currentPiece;
	float blockSize;
	Block deadGrid[][];		// the grid are the blocks that are done on the field
	Float gridSizeX;
	Float gridSizeY;	
	Point2d playField[] = new Point2d[2];
	float timer;
	boolean gameOver;
	
	public PlayState() {
		gameOver = false;	
		currentPiece = new LPiece(width/2,32.0f);
		blockSize=16.0f;		
		gridSizeX = new Float(width/blockSize);
		gridSizeY = new Float(height/blockSize);		
		deadGrid = new Block[gridSizeX.intValue() + 1][gridSizeY.intValue() + 1];
		playField[0] = new Point2d(blockSize, blockSize);	// start
		playField[1] = new Point2d(256,480);				// end
		timer = 1.0f;
		
		// create graphics offscreen size of play field
		Float playFieldWidth = playField[0].getX() - playField[1].getX();
		Float playFieldHeight = playField[0].getY() - playField[1].getY();
		
		// TMP
		drawPlayField();
	}
	
	public void update(float elapsed) {
		currentPiece.update();
		timer -= elapsed;
		// hit bottom, copy to deadGrid
		if (currentPiece.getMaxY() > playField[1].getY() - blockSize * 2) {
			copyToGrid();
		} 
		
		// this is the timed downward movement of the piece
		if (timer <= 0) {
			if (! gridCollideY(currentPiece.getBlocks())) {				// won't hit, move down
				currentPiece.setY(currentPiece.getY() + blockSize);
			} else {													// we hit something, deadgrid it
				copyToGrid();
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

		drawOverlay();
		fill(255);
		text("fps: " + Math.round(fps * .1)/.1,8,8);
	}

	public GameState nextState() {
	    if (gameOver == true) {
			return new GameOverState();
	    }
	    else{
	    	return this;
	    }
	}

	public void keyPressed() {
		
		// left arrow key
		if (keyCode == LEFT) {
			if (! gridCollideX(currentPiece.getBlocks(), -1)) {
				currentPiece.setX(currentPiece.getX() - blockSize, playField[0].getX());				
			}
		}

		// right arrow key
		if (keyCode == RIGHT) {
			if (! gridCollideX(currentPiece.getBlocks(), 1)) {
				currentPiece.setX(currentPiece.getX() + blockSize, playField[1].getX());
			}
		}

		// up arrow key
		if (keyCode == UP) {
			if (! currentPiece.rotateCollide(playField[0].getX(), playField[1].getX())) {
				currentPiece.setRotation(currentPiece.getRotation() + radians(90));
			}
		}

		// down arrow key
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

			}
			
		}
		
		// space bar
		if (keyCode == ' ') {
			// get greatest Y values
			Block yBlocks[] = currentPiece.getMaxYBlocks();
			int columns[] = new int[yBlocks.length];
			for (int i=0; i < yBlocks.length; i++) {
				columns[i] = (int)(yBlocks[i].getX() / blockSize);
				//println (columns[i]);
			}
			
			// search down columns with Y in current piece
			Block hitPoint = null;
			ArrayList hitPoints = new ArrayList();
			
			boolean hitSomething = false;
			float xStart = yBlocks[0].getY() / blockSize;
			for (int col=0; col < columns.length; col++) {
				for (int row=(int)xStart; row < (int)playField[1].getY() / blockSize; row++) {
					//println ("checking col:" + columns[col] + " row:" + row);
					
					// hit something
					if(deadGrid[(int)columns[col]][row] != null) {
						println("there's something down there");
						hitSomething = true;
						hitPoint = deadGrid[(int)columns[col]][row];
						hitPoints.add(hitPoint);
					}
				}
			}

			if (hitSomething) {

				// TODO: finds too many hit points, do reverse MaxYBlock function on deadgrid
				float closest = 0.0f;
				Block closestBlock = null;
				float distance = 0.0f;

				for (int i=0; i < yBlocks.length; i++) {
					for (int j=0; j < hitPoints.size(); j++) {
						Block b = (Block)hitPoints.get(j);
				
						println("ylen " + yBlocks.length + " hitlen" + hitPoints.size());
					
						if (b.getX() == yBlocks[i].getX()) {
							if (closest == 0.0f) {
								println("b.getY()" + b.getY() + " yBlocks[j].getY()" + yBlocks[i].getY());
								closest = b.getY() - yBlocks[i].getY();
							}
							if ((b.getY() - yBlocks[i].getY()) < closest ) {
								closest = b.getY() - yBlocks[i].getY();
								closestBlock = b;
								println(closestBlock.getX() + " " + closestBlock.getY());
							}
						}
					}
				}
				
				// set x,y of piece minus offset of block						
				currentPiece.setY(currentPiece.getY() + closest - blockSize);

				// TODO: why do I have to do this instead of copyToGrid()?
				timer = 0;		
				
			} else {
				// nothing below, just drop
				println(playField[1].getY());
				currentPiece.setY(playField[1].getY() - blockSize * 2);

				// TODO: why do I have to do this instead of copyToGrid()?
				timer = 0;
			}
			

			
			/*
			} else {
				if (hitPoint.getY() < deadGrid[(int)columns[col]][row].getY()) {
					hitPoint = deadGrid[(int)columns[col]][row];
					println("---HIT----" + hitPoint.getX() + " " + hitPoint.getY() );
				}
			}*/


			
			// copy to grid

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
		
		// TODO: check for done lines HERE
		
		// new piece HERE
		currentPiece = new LPiece(playField[1].getX() / 2, 32.0f);	
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
	
	// check for blocks on X, -1 is left, 1 is right
	boolean gridCollideX(Block checkBlocks[], int direction) {	
		//Block copyBlock[] = currentPiece.getBlocks();
		
		boolean hit = false;
			
		for (int i=0; i < 4; i++) {
			Float fx = checkBlocks[i].getX() / blockSize;
			Float fy = checkBlocks[i].getY() / blockSize;
			
			
			//println("block" + i + " " + fx * blockSize + " " + fy * blockSize);
			if (direction > 0) {
				int x = fx.intValue() + 1;
				int y = fy.intValue();
				// we hit something on the grid
				if(deadGrid[x][y] != null) {
					println("deny right");
					return true;
				}		
				
			} else {
				int x = fx.intValue() - 1;
				int y = fy.intValue();
				// we hit something on the grid
				if(deadGrid[x][y] != null) {
					println("deny left");
					return true;
				}		
				
			}


		}
		
		return false;
		/*
		if (hit == true) {
			return true;
		} else {
			return false;
		}*/
	}
	
	
	
	// background art etc
	// TODO: offscreen drawing
	void drawPlayField() {
		background(25);
		// grid lines
		strokeWeight(1);
  		stroke(0);
		for (float i=playField[0].getX(); i < playField[1].getX(); i+=blockSize) {
			for (float j=playField[0].getY(); j < playField[1].getY(); j+=blockSize) {
		    	line(i, playField[0].getY(), i, playField[1].getY());
		    	line(playField[0].getX(), j, playField[1].getX(), j);
			}
		}
	}
	
	// top most art
	void drawOverlay() {
		// border box
		strokeWeight(3);
  		stroke(255);
		line(playField[0].getX(), playField[0].getY(), playField[1].getX(), playField[0].getY());	// top line
		line(playField[1].getX(), playField[0].getY(), playField[1].getX(), playField[1].getY());	// right line
		line(playField[1].getX(), playField[1].getY(), playField[0].getX(), playField[1].getY());	// bottom line		
		line(playField[0].getX(), playField[1].getY(), playField[0].getX(), playField[0].getY());	// left line				
	}
}