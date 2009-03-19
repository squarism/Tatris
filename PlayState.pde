public class PlayState implements GameState {
	
	Piece currentPiece;
	float blockSize;
	Block deadGrid[][];		// the grid are the blocks that are done on the field
	int gridSizeX;
	int gridSizeY;	
	Point2d playField[] = new Point2d[2];
	float timer;
	boolean gameOver;
	
	PGraphics grid;		// offscreen buffer for grid lines
	PGraphics overlay;	// offscreen buffer for overlay (border etc)
	
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
		
		// create offscreen grid buffer image
		createGrid();

		// create offscreen overlay buffer image
		createOverlay();
		
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
		/*
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
		}*/
		
		// BUMPY ROTATE GRID TEST
		
		String bumpy = "#FFAA00";
		int tmp = 28;
		for (int i=0; i < 15; i++) {
			if (i != 8){
				deadGrid[i][tmp] = new Block(i*blockSize + playField[0].getX(), tmp*blockSize + playField[0].getY(), blockSize, bumpy);
			}
		}
		tmp--;
		for (int i=0; i < 15; i++) {
			if (i != 8){
				deadGrid[i][tmp] = new Block(i*blockSize + playField[0].getX(), tmp*blockSize + playField[0].getY(), blockSize, bumpy);
			}
		}
		tmp--;
		for (int i=5; i < 8; i++) {
				deadGrid[i][tmp] = new Block(i*blockSize + playField[0].getX(), tmp*blockSize + playField[0].getY(), blockSize, bumpy);
		}
		tmp--;
		deadGrid[7][tmp] = new Block(7*blockSize + playField[0].getX(), tmp*blockSize + playField[0].getY(), blockSize, bumpy);
		
		
		// SINGLE GODDAMN BLOCK TEST -- THROUGH FLOOR BUG
		//deadGrid[7][28] = new Block(7*blockSize + playField[0].getX(), 28*blockSize + playField[0].getY(), blockSize, "#FFAA00");
		
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
			if (! gridCollideY(currentPiece.getBlocks())) {
				// won't hit, move down
				currentPiece.setY(currentPiece.getY() + blockSize);
			} else {
				// we hit something, deadgrid it
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

		// display offscreen grid buffer image
		image(grid, playField[0].getX() - 1, playField[0].getY() - 1);

		currentPiece.draw();
				
		stroke(0,125);		// black border, mostly opaque
		strokeWeight(3);
  		
		for (int x=0; x < gridSizeX; x++) {
			for (int y=0; y < gridSizeY; y++) {
				if (deadGrid[x][y]!=null) deadGrid[x][y].draw();
			}
		}

		//drawOverlay();
		image(overlay, playField[0].getX() - 2, playField[0].getY() - 2);
		
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

	// TODO: instead of setting X etc, set a variable and let update() move pieces.
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
			// checks collision with grid
			if (! currentPiece.rotateCollide(deadGrid, playField)) {
				if (! currentPiece.rotateCollide(playField[0].getX(), playField[1].getX())) {
					currentPiece.setRotation(currentPiece.getRotation() + radians(90));
				}
			} 
			// checks collision with walls			
			//if (! currentPiece.rotateCollide(playField[0].getX(), playField[1].getX())) {
			//	currentPiece.setRotation(currentPiece.getRotation() + radians(90));
			//}
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
			dropPiece();
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
			//println("rows affected:" + y);

			try{
			deadGrid[x][y] = new Block(x*blockSize + playField[0].getX(), y*blockSize + playField[0].getY(), blockSize, copyBlock[i].getFillColor());
			} catch (Exception e) {
				println("!!!  HOLY ASS TEETH !!");
				// catch nothing, I'm doing horrible shit here to test
			}
		}
		
		// mark filled rows (tetrises) into doneRows ArrayList
		// loop through 2 dimensional array without knowing length
		ArrayList doneRows = new ArrayList();
		int rows = deadGrid[0].length;
		int cols = deadGrid.length;

		int done=0;
		for (int j=0; j < rows; j++) {

			done = 0;
			for (int i=0; i < cols; i++) {				
				if (deadGrid[i][j] != null) {
					done++;
				}
				//println("done checking col:" + i + " row:" + j + " was:" + done);
				
				//println(deadGrid[15][29].getFillColor());
				if (done == cols) {
					// doneRows contains markers to done rows that need to be deleted
					doneRows.add(j);
					println("ROW " + j + " DONE");				
				}
			}

		}
		
		// now we remove rows if there are any to be done
		if (doneRows.size() > 0) {

			// copy rows to new array, skipping rows that are done
			Block trimmedGrid[][] = new Block[gridSizeX][gridSizeY];
			for (int j=0; j < rows; j++) {
				// indexOf returns -1 when not found, else returns position in array
				if(doneRows.indexOf(j) <= -1) {
					// get all collumns in row not marked as done
					for (int i=0; i < cols; i++) {
						if (deadGrid[i][j] != null) {
							Block dgb = deadGrid[i][j];
							Block b = new Block(dgb.getX(), dgb.getY(), dgb.getHeight(), dgb.getFillColor());
							// done rows are blank rows in trimmedGrid now
							trimmedGrid[i][j] = b;
						}
					}				
				}
			}


			// using traditional for loop with iterator
			//for(Iterator i = doneRows.iterator(); i.hasNext(); ) {
			//	println("Iter:" + i.next());
			//}
			//println("---");

				
			// compress grid psuedocode:
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

			// look for empty lines		
			ArrayList emptyRows = new ArrayList();
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
			
			// this moves a row down
			// need to repeat for every empty row
			for(Iterator i = emptyRows.iterator(); i.hasNext(); ) {

				int rowNum = (Integer)i.next(); 
				//for (int k=0; k < rows; k++) {
				for (int k=rowNum; k > 0; k--) {					
					// if you're above an empty row you need to go down one
					// but k needs to start on the empty row, thus <= instead of <
					if (k <= rowNum){
						// loop through columns
						for (int colI=0; colI < cols; colI++) {
							// skip blank blocks (throws a NPE)
							if (compressedGrid[colI][k] != null) {
								// get block into variable for easier get() methods later
								Block tgb = compressedGrid[colI][k];
								// new block because of java memory gotcha, can't just get from trimmedGrid
								Block b = new Block(tgb.getX(), tgb.getY(), tgb.getHeight(), tgb.getFillColor());
								b.setY(b.getY() + blockSize);
								// copy row above
								compressedGrid[colI][k+1] = b;
								// delete row above, otherwise it will copy itself all the way down
								compressedGrid[colI][k] = null;
							}
						}
					}
				}
			}
			
			// using traditional for loop with iterator
			//for(Iterator i = emptyRows.iterator(); i.hasNext(); ) {
			//	println("Iter:" + i.next());
			//}
			//println("---");

			// compressedGrid is flattened and removed of done rows
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
	void createGrid() {
		
		/*
		background(25);
		// grid lines
		strokeWeight(1);
  		stroke(0);
		for (float i=playField[0].getX(); i <= playField[1].getX(); i+=blockSize) {
			for (float j=playField[0].getY(); j <= playField[1].getY(); j+=blockSize) {
		    	line(i, playField[0].getY(), i, playField[1].getY());
		    	line(playField[0].getX(), j, playField[1].getX(), j);
			}
		}*/
		
		
		grid = createGraphics( (int)(gridSizeX * blockSize) + 1, (int)(gridSizeY * blockSize) + 1, P2D);
		grid.beginDraw();
		grid.background(0);
		grid.strokeWeight(1);
		grid.stroke(10);
		for (float i=0; i <= gridSizeX; i++) {
			for (float j=0; j <= gridSizeY; j++) {
		    	grid.line(i*blockSize, 0, i*blockSize, gridSizeY*blockSize);
		    	grid.line(0, j*blockSize, gridSizeX*blockSize, j*blockSize);
			}
		}
		grid.endDraw();
		

		
	}
	
	// top most art
	void createOverlay() {
		
		// +3 is for interior padding border
		int xlen = (int)(playField[1].getX() - playField[0].getX()) + 3;
		int ylen = (int)(playField[1].getY() - playField[0].getY()) + 3;
		overlay = createGraphics( xlen + 3, ylen + 3, P2D);
		
		overlay.beginDraw();
		overlay.strokeWeight(1);
  		overlay.stroke(255);
		overlay.line(0, 0, xlen, 0);	// top line
		overlay.line(xlen, 0, xlen, ylen);	// right line
		overlay.line(xlen, ylen, 0, ylen); // bottom line		
		overlay.line(0, ylen, 0, 0); // left line				
		overlay.endDraw();
		
		// border box
		/*
		strokeWeight(3);
  		stroke(255);
		line(playField[0].getX(), playField[0].getY(), playField[1].getX(), playField[0].getY());	// top line
		line(playField[1].getX(), playField[0].getY(), playField[1].getX(), playField[1].getY());	// right line
		line(playField[1].getX(), playField[1].getY(), playField[0].getX(), playField[1].getY());	// bottom line		
		line(playField[0].getX(), playField[1].getY(), playField[0].getX(), playField[0].getY());	// left line				
		*/
	}
	
	void dropPiece() {
		// get greatest Y values
		Block yBlocks[] = currentPiece.getMaxYBlocks();
		int columns[] = new int[yBlocks.length];
		for (int i=0; i < yBlocks.length; i++) {
			columns[i] = (int)((yBlocks[i].getX() - playField[0].getX()) / blockSize);
			//println (columns[i]);
			
			// store the least Y value for yStart later
			println("YB:" + yBlocks[i].getX() + "," + yBlocks[i].getY());
		}
		
		// search down columns with Y in current piece
		Block hitPoint = null;
		ArrayList hitPoints = new ArrayList();
		
		boolean hitSomething = false;

		// what row to start on, doesn't matter which because grid is always below
		float yStart = yBlocks[0].getY() / blockSize;
		// row to end checking offset by playField
		int rowEnd = (int)((playField[1].getY() - playField[0].getY()) / blockSize);
		
		// loop through columns and rows looking for pieces below
		for (int col=0; col < columns.length; col++) {
			for (int row=(int)yStart; row < rowEnd; row++) {
				//println ("checking col:" + columns[col] + " row:" + row);
				
				// hit something
				//try{
				if(deadGrid[(int)columns[col]][row] != null) {
					hitSomething = true;
					
					// this is a point of colision
					hitPoint = deadGrid[(int)columns[col]][row];

					// remember where we hit the grid
					hitPoints.add(hitPoint);

					println(hitPoint.getX() + "," + hitPoint.getY() + "hitsomething=" + hitSomething);
				}
			//} catch (Exception e) {
			//	println("!!!!! hit something EXCEPTION !!!");
			//	e.printStackTrace();
			//}
			}
		}

		if (hitSomething == true) {

			// TODO: finds too many hit points, do reverse MaxYBlock function on deadgrid
			float closest = 0.0f;
			//Block closestBlock = null;

			for (int i=0; i < yBlocks.length; i++) {
				for (int j=0; j < hitPoints.size(); j++) {
					Block hpb = (Block)hitPoints.get(j);
					//println("hpb x:" + hpb.getX() + " hpb y:" + hpb.getY());
				
					// is the block to test over a hitting point?
					if (hpb.getX() == yBlocks[i].getX()) {
						// initial seed vs setting closest to 9999 etc
						if (closest == 0.0f) {
							closest = hpb.getY() - yBlocks[i].getY();
							//println("ZERO SHIT");
						}
						if ((hpb.getY() - yBlocks[i].getY()) < closest ) {
							closest = hpb.getY() - yBlocks[i].getY();
							//closestBlock = hpb;
							//println("CLOSEST" + hpb.getY() + "," + hpb.getX());
						}
					}
				}
			}
			

			// new Y pos is current pos minus offset plus closest distance of hit block
			float newYPosition = currentPiece.getY() - playField[0].getY() + closest;
			
			println("new:" + newYPosition + " playY:" + playField[1].getY() + " yb" + currentPiece.getMaxY());
			if (newYPosition >= playField[1].getY() - playField[0].getY()) {
				float correction = newYPosition - (playField[1].getY() - playField[0].getY()) + blockSize;
				newYPosition = newYPosition - correction; 
			}
			
			// the piece might go through the floor, check it
			//if (newYPosition >  )
			// set x,y of piece minus offset of block
			currentPiece.setY(newYPosition);

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