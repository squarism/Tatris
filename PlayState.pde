public class PlayState implements GameState {
	
	Piece currentPiece;
	float blockSize;
	Block deadGrid[][];		// the grid are the blocks that are done on the field
	int gridSizeX;
	int gridSizeY;	
	Point2d playField[] = new Point2d[2];
	float timer;
	boolean gameOver;
	
	public PlayState() {
		gameOver = false;	
		blockSize=16.0f;
				
		// playfield is 15x29
		playField[0] = new Point2d(blockSize, blockSize);	// start
		playField[1] = new Point2d(256,480);				// end
		
		// TODO: take out non primitives		
		gridSizeX = (int)((playField[1].getX() - playField[0].getX() ) / blockSize);
		gridSizeY = (int)((playField[1].getY() - playField[0].getY() ) / blockSize);
		
		println("GRIDSIZE " + gridSizeX + " " + gridSizeY);
		
		currentPiece = new LPiece(playField[1].getX()/2, 32.0f);
		
		deadGrid = new Block[gridSizeX][gridSizeY];
		
		timer = 1.0f;
		
		// create graphics offscreen size of play field
		Float playFieldWidth = playField[0].getX() - playField[1].getX();
		Float playFieldHeight = playField[0].getY() - playField[1].getY();
		
		drawPlayField();
		
		// TWO LINE TEST
		/*
		int tmp = 28;
		for (int i=0; i < 15; i++) {
			deadGrid[i][tmp] = new Block(i*blockSize + playField[0].getX(), tmp*blockSize + playField[0].getY(), blockSize, "#444444");
		}
		tmp--;
		for (int i=0; i < 15; i++) {
			deadGrid[i][tmp] = new Block(i*blockSize + playField[0].getX(), tmp*blockSize + playField[0].getY(), blockSize, "#444444");
		}*/

		// ONE LINE TEST
		/*
		int tmp = 28;
		for (int i=0; i < 15; i++) {
			if (i != 7 && i != 8){
				deadGrid[i][tmp] = new Block(i*blockSize + playField[0].getX(), tmp*blockSize + playField[0].getY(), blockSize, "#444444");
			}
		}
		tmp--;
		for (int i=0; i < 15; i++) {
			if (i != 7 && i != 8){
				deadGrid[i][tmp] = new Block(i*blockSize + playField[0].getX(), tmp*blockSize + playField[0].getY(), blockSize, "#444444");
			}
		}*/
		
		// TWO LINE TEST
		
		int tmp = 28;
		for (int i=0; i < 15; i++) {
			if (i != 8){
				deadGrid[i][tmp] = new Block(i*blockSize + playField[0].getX(), tmp*blockSize + playField[0].getY(), blockSize, "#444444");
			}
		}
		tmp--;
		for (int i=0; i < 15; i++) {
			if (i != 8){
				deadGrid[i][tmp] = new Block(i*blockSize + playField[0].getX(), tmp*blockSize + playField[0].getY(), blockSize, "#444444");
			}
		}
		
	}
	
	public void update(float elapsed) {
		currentPiece.update();
		timer -= elapsed;
		// hit bottom, copy to deadGrid
		if (currentPiece.getMaxY() > playField[1].getY() - blockSize * 2 && timer <= 0) {
			copyToGrid();
		} 
		
		// this is the timed downward movement of the piece
		if (timer <= 0) {
			if (! gridCollideY(currentPiece.getBlocks())) {				// won't hit, move down
				//currentPiece.setY(currentPiece.getY() + blockSize);
			} else {													// we hit something, deadgrid it
				copyToGrid();
			}

			// TODO: add difficulty timer
			timer = 1;
			
		}
	}
	
	// order of drawing in paint() is important
	// last drawn appears on top
	public void paint() {
		background(25);
		drawPlayField();
		currentPiece.draw();
		
		for (int x=0; x < gridSizeX; x++) {
			for (int y=0; y < gridSizeY; y++) {
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
			// checks collision with walls
			if (! currentPiece.rotateCollide(playField[0].getX(), playField[1].getX())) {
				currentPiece.setRotation(currentPiece.getRotation() + radians(90));
			}
		}

		// down arrow key
		if (keyCode == DOWN) {
			// When player presses down, reset timer to make gameplay more
			// predictable and smooth.  Pieces can fall "twice" otherwise.



			if (currentPiece.getMaxY() + blockSize < playField[1].getY()) {				
				// this is down movement from keystroke
				currentPiece.setY(currentPiece.getY() + blockSize);
			} else {
				// but if the player is mashing down at the very bottom, copy piece
				copyToGrid();
			}
			
			// TODO: add difficulty timer
			timer = 1;			

			
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
				columns[i] = (int)((yBlocks[i].getX() - playField[0].getX()) / blockSize);
				//println (columns[i]);
			}
			
			// search down columns with Y in current piece
			Block hitPoint = null;
			ArrayList hitPoints = new ArrayList();
			
			boolean hitSomething = false;
			float yStart = yBlocks[0].getY() / blockSize;
			
			int rowEnd = (int)((playField[1].getY() - playField[0].getY()) / blockSize);
			for (int col=0; col < columns.length - 1; col++) {
				for (int row=(int)yStart; row < rowEnd; row++) {
					//println ("checking col:" + columns[col] + " row:" + row);
					
					// hit something
					try{
					if(deadGrid[(int)columns[col]][row] != null) {
						hitSomething = true;
						hitPoint = deadGrid[(int)columns[col]][row];
						hitPoints.add(hitPoint);
						//println(hitPoint.getX() + "," + hitPoint.getY());
					}
				} catch (Exception e) {
					println("!!!!! hit something EXCEPTION !!!");
					e.printStackTrace();
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
					
						if (b.getX() == yBlocks[i].getX()) {
							if (closest == 0.0f) {
								closest = b.getY() - yBlocks[i].getY();
							}
							if ((b.getY() - yBlocks[i].getY()) < closest ) {
								closest = b.getY() - yBlocks[i].getY();
								closestBlock = b;
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
				currentPiece.setY(playField[1].getY() - playField[0].getY() - blockSize);

				// TODO: why do I have to do this instead of copyToGrid()?
				timer = 0;
			}
		}
	}
	
	public void keyReleased() {

	}
	
	void copyToGrid() {
		Block copyBlock[] = currentPiece.getBlocks();
		
		ArrayList rowsAffected = new ArrayList();

		for (int i=0; i < 4; i++) {
			// TODO: replace with primatives
			Float fx = (copyBlock[i].getX() - playField[0].getX()) / blockSize;
			Float fy = (copyBlock[i].getY() - playField[0].getY()) / blockSize;
			int x = fx.intValue();
			int y = fy.intValue();
			rowsAffected.add(y);
			println("rows affected:" + y);

			//deadGrid[x][y] = new Block(x*blockSize, y*blockSize, blockSize, copyBlock[i].getFillColor());
			deadGrid[x][y] = new Block(x*blockSize + playField[0].getX(), y*blockSize + playField[0].getY(), blockSize, "#444444");
		}
		
		// TODO: check for done lines HERE
	
		// loop through 2 dimensional array without knowing length


		ArrayList doneRows = new ArrayList();
		int rows = deadGrid[0].length;
		int cols = deadGrid.length;

		int done=0;
		for (int j=0; j < rows; j++) {

			done = 0;
			for (int i=0; i < cols; i++) {
				//if (deadGrid[i][j] !=null && deadGrid[i][j].getX() > 0) {
					//println("col:" + i + " row:" + j + (deadGrid[i][j]==null));
				
				if (deadGrid[i][j] != null) {
				//	if (deadGrid[i][j].getX() > 0) {
					done++;
					}
				//}
				//println("done checking col:" + i + " row:" + j + " was:" + done);
				
				//println(deadGrid[15][29].getFillColor());
				if (done == cols) {
					// add up all rows to be removed
					doneRows.add(j);
					println("ROW " + j + " DONE");				
				}
			}

		}
		

		if (doneRows.size() > 0) {

			// now we remove rows in a few passes
			Block trimmedGrid[][] = new Block[gridSizeX][gridSizeY];
			// copy rows to new array, skipping rows that are done
			for (int j=0; j < rows; j++) {
			
				// indexOf returns -1 when not found, else returns position in array
				if(doneRows.indexOf(j) <= -1) {

					for (int i=0; i < cols; i++) {
						if (deadGrid[i][j] != null) {
							Block dgb = deadGrid[i][j];
							Block b = new Block(dgb.getX(), dgb.getY(), dgb.getHeight(), dgb.getFillColor());
							trimmedGrid[i][j] = b;
						}
					}				
				}
			}


			// using traditional for loop with iterator
			for(Iterator i = doneRows.iterator(); i.hasNext(); ) {
				println("Iter:" + i.next());
			}
			println("---");

			// test -- checking memory locations
			//println(deadGrid[14][28]);
			//println(trimmedGrid[14][28]);


				
			// compress grid
		
			// loop all
			// if done
			// loop back (ie: j ... 0)
			// for each row, move blocks y+1 (down)



		
			// copy grid
			Block compressedGrid[][] = new Block[gridSizeX][gridSizeY];
			for (int i=0; i < cols; i++) {
				for (int k=0; k < rows; k++) {
					if (trimmedGrid[i][k] != null) {
						Block tgb = trimmedGrid[i][k];
						Block b = new Block(tgb.getX(), tgb.getY(), tgb.getHeight(), tgb.getFillColor());
						compressedGrid[i][k] = b;
						//compressedGrid[i][k] = trimmedGrid[i][k];
					}
				}
			}
		
			ArrayList emptyRows = new ArrayList();
			// look for empty lines
			for (int rowsI = rows - 1; rowsI >= 0; rowsI--) {
				int empty = 0;
				for (int colsI=0; colsI < cols; colsI++) {					
					if (trimmedGrid[colsI][rowsI] == null) {
						empty++;
					}
				}

				
				if (empty == cols && rowsAffected.indexOf(rowsI) > -1 ) {
					emptyRows.add(rowsI);
					println("empty index" + (rowsAffected.indexOf(rowsI) > -1));				
				}
				
			}
			
			for(Iterator i = emptyRows.iterator(); i.hasNext(); ) {

				int rowNum = (Integer)i.next(); 
				for (int k=0; k < rows; k++) {
					if (k < rowNum){
						println("doing row:" + k);
						for (int colI=0; colI < cols; colI++) {
							if (compressedGrid[colI][k] != null) {
								Block tgb = compressedGrid[colI][k];
								Block b = new Block(tgb.getX(), tgb.getY(), tgb.getHeight(), tgb.getFillColor());
								b.setY(b.getY() + blockSize);
								compressedGrid[colI][k+1] = b;
								compressedGrid[colI][k] = null;
								//compressedGrid[i][k] = trimmedGrid[i][k];
							}
						}

						
					}
				}
			}

			
			
		
			
			// using traditional for loop with iterator
			for(Iterator i = emptyRows.iterator(); i.hasNext(); ) {
				println("Iter:" + i.next());
			}
			println("---");
			
					
			
			
			
			
			
			
		

			deadGrid = compressedGrid;
		}

		
		
		
		/*
		for (int i=0; i < doneRows.size(); i++) {
			println(doneRows.get(i));
		}
		*/
		
		
		
		// new piece HERE
		currentPiece = new LPiece(playField[1].getX() / 2, 32.0f);
		
		// check for game over HERE
	}

	// check for blocks below current piece				
	boolean gridCollideY(Block checkBlocks[]) {	
		//Block copyBlock[] = currentPiece.getBlocks();
		
		boolean hit = false;
			
		for (int i=0; i < 4; i++) {
			Float fx = (checkBlocks[i].getX() - playField[0].getX()) / blockSize;
			Float fy = (checkBlocks[i].getY() - playField[0].getY()) / blockSize;
			
			
			//println("block" + i + " " + fx * blockSize + " " + fy * blockSize);
			int x = fx.intValue();
			int y = fy.intValue() + 1;
			
			// we check below piece but we don't want an ArrayOutOfBounds exception
			if (y >= gridSizeY) {
				y = gridSizeY - 1;
			}

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
			Float fx = (checkBlocks[i].getX() + playField[0].getX()) / blockSize;
			Float fy = (checkBlocks[i].getY() + playField[0].getY()) / blockSize;
			
			
			//println("block" + i + " " + fx * blockSize + " " + fy * blockSize);
			if (direction > 0) {
				// limit x to edge of playfield
				int x = fx.intValue();
				if (x < gridSizeX - 1) {
					int y = fy.intValue() - 1;
					// we hit something on the grid
					if(deadGrid[x-1][y-1] != null) {
						println("deny right");
						return true;
					}		
				}
				
			} else {
				// limit x to edge of playfield
				int x = fx.intValue() - 2;
				if (x > 0) {
					int y = fy.intValue() - 1;
					// we hit something on the grid
					if(deadGrid[x-1][y-1] != null) {
						println("deny left");
						return true;
					}
				}
			}
			
		}

		return false;

	}
		
	// background art etc
	// TODO: offscreen drawing
	void drawPlayField() {
		background(25);
		// grid lines
		strokeWeight(1);
  		stroke(0);
		for (float i=playField[0].getX(); i <= playField[1].getX(); i+=blockSize) {
			for (float j=playField[0].getY(); j <= playField[1].getY(); j+=blockSize) {
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