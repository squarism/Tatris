 import java.util.TreeMap;
 import java.util.Collections;
 import java.util.Map;
 
 public class PlayState implements GameState {
	
	Piece currentPiece;
	Piece nextPiece;
	PieceBag pieceBag;
	int pieceBagI;
	float blockSize;
	Block deadGrid[][];		// the grid are the blocks that are done on the field
	int gridSizeX;
	int gridSizeY;	
	Point2d playField[] = new Point2d[2];
	float timer;
	boolean gameOver;
	boolean inMenu;
	
	PGraphics grid;		// offscreen buffer for grid lines
	PGraphics overlay;	// offscreen buffer for overlay (border etc)
	PGraphics sidebar;	// score, next piece etc
	PGraphics badge;	// logo etc, separate for blending
	
	Score score = new Score();
	Level level = new Level();
	float currentTimer = level.getTimer();
	ArrayList anim = new ArrayList();
	
	// try out moving key events to update()
	boolean pressedRotate = false;
	boolean pressedDown = false;
	boolean pressedLeft = false;
	boolean pressedRight = false;
	boolean pressedDrop = false;
	
	public PlayState() {
		gameOver = false;
		inMenu = false;	
		blockSize=16.0f;
				
		// playfield is 15x29
		playField[0] = new Point2d(blockSize, blockSize);	// start
//		playField[1] = new Point2d(256,480);				// end
		playField[1] = new Point2d(192,480);				// end		

		// TODO: take out non primitives		
		gridSizeX = (int)((playField[1].getX() - playField[0].getX() ) / blockSize);
		gridSizeY = (int)((playField[1].getY() - playField[0].getY() ) / blockSize);
		
		println("GRIDSIZE " + gridSizeX + " " + gridSizeY);
		
		pieceBag = new PieceBag(playField[1].getX()/2, 32.0f);
		//currentPiece = new ZPiece(playField[1].getX()/2, 32.0f);
		//currentPiece = new IPiece(playField[1].getX()/2, 32.0f);
		currentPiece = pieceBag.getPiece();
		nextPiece = pieceBag.getPiece();
		
		deadGrid = new Block[gridSizeX][gridSizeY];
		
		timer = 1.0f;
		
		// create graphics offscreen size of play field
		Float playFieldWidth = playField[0].getX() - playField[1].getX();
		Float playFieldHeight = playField[0].getY() - playField[1].getY();
		
		// create offscreen grid buffer image
		offscreenBuffers();
		
		// populate playfield if you want to test a certain situation, see method for test types
		//enableTest(10);
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
			if (! gridCollideY(currentPiece.getBlocks()) && currentPiece.getMaxY() <= playField[1].getY() - blockSize * 2) {
				// won't hit, move down
				currentPiece.setY(currentPiece.getY() + blockSize);
			} else {
				// we hit something, deadgrid it
				copyToGrid();
			}

			// currentTimer is dynamic speed based on current level
			timer = currentTimer;
			
		}
		
		if (pressedLeft) {
			pressedLeft = false;
			
			if (! gridCollideX(currentPiece.getBlocks(), -1)) {
				currentPiece.setX(currentPiece.getX() - blockSize, playField[0].getX());
			}
		} else if (pressedRight) {
			pressedRight = false;

			if (! gridCollideX(currentPiece.getBlocks(), 1)) {
				currentPiece.setX(currentPiece.getX() + blockSize, playField[1].getX());
			}
		} else if (pressedRotate) {
			pressedRotate = false;
			
			if (! currentPiece.rotateCollide(deadGrid, playField, gridSizeX, gridSizeY)) {
				// checks rotation collision with X boundries	
				if (! currentPiece.rotateCollideX(playField[0].getX(), playField[1].getX())) {
					// checks rotation collision with Y boundries
					if (! currentPiece.rotateCollideY(playField[0].getY(), playField[1].getY())) {
						currentPiece.setRotation(currentPiece.getRotation() + radians(90));
						// update our piece so not to cause weird bugs with key events
					}
				}
			}
		} else if (pressedDown) {
			pressedDown = false;
			
			// at bottom of play boundry
			if (currentPiece.getMaxY() + blockSize < playField[1].getY()) {				
				// this is down movement from keystroke
				currentPiece.setY(currentPiece.getY() + blockSize);
			} else {
				// but if the player is mashing down at the very bottom, copy piece
				copyToGrid();
			}
			
			// TODO: add difficulty timer
			// When player presses down, reset timer to make gameplay more
			// predictable and smooth.  Pieces can fall "twice" otherwise.
			// Ordering of timer setting and copyToGrid() checks matter for gameplay feel.
			timer = 1;
			
			// user pressed down, check for grid collide
			if (gridCollideY(currentPiece.getBlocks())) {
				//println("collision on grid");
				copyToGrid();
			}
		} else if (pressedDrop) {
			pressedDrop = false;
			dropPiece();
		}
		
		
		// animation & effects
		for (int i=0; i < anim.size(); i++) {
			Animation a = (Animation)anim.get(i);
			if (!a.isStarted()) {
				a.start();
			} else {
				a.update(elapsed);
			}
			if (a.isDone()) {
				a.stop();
				anim.remove(i);
			}
		}
	}
	
	// order of drawing in paint() is important
	// last drawn appears on top
	public void paint() {
		background(25);
		image(grid, playField[0].getX() - 1, playField[0].getY() - 1);			// display offscreen grid buffer image
		currentPiece.draw();

		stroke(0,125);		// black border, mostly opaque
		strokeWeight(3); 		
		for (int x=0; x < gridSizeX; x++) {
			for (int y=0; y < gridSizeY; y++) {
				if (deadGrid[x][y]!=null) deadGrid[x][y].draw();
			}
		}

		image(overlay, playField[0].getX() - 2, playField[0].getY() - 2);
		image(sidebar, playField[1].getX(), blockSize);

		// draw next piece
		pushMatrix();
		translate(playField[1].getX() - (blockSize * 2), blockSize * 2);
		nextPiece.draw();
		popMatrix();
		
		// score text
		fill(255);
		int theScore = score.getScore();
		int scoreWidth = new Integer(theScore).toString().length();		// need this to make alignment pretty
		if (scoreWidth > 2) {
			textFont(visitorFont, 64/(scoreWidth * .45));	// number grows, scale down for pretty display
		} else {
			textFont(visitorFont, 48);
		}
		text(theScore, playField[1].getX() + blockSize * 2 - scoreWidth, playField[0].getY() + blockSize * 11);
		
		// lines done text
		int theLines = score.getLines();
		int linesWidth = new Integer(theLines).toString().length();		// need this to make alignment pretty

		if (linesWidth > 2) {
			textFont(visitorFont, 64/(linesWidth * .45));		// number grows, scale down for pretty display
		} else {
			textFont(visitorFont, 48);
		}
		text(theLines, playField[1].getX() + blockSize * 2 - linesWidth, playField[0].getY() + blockSize * 16);
		
		// level text
		text(level.getLevel(), playField[1].getX() + blockSize * 2 - linesWidth, playField[0].getY() + blockSize * 21);
		
		blend(badge, 0, 0, badge.width, badge.height, width-140, height-40, badge.width, badge.height, SCREEN);
		//image(badge, playField[1].getX(), blockSize);

		// animation & effects
		for (int i=0; i < anim.size(); i++) {
			Animation a = (Animation)anim.get(i);
			a.draw();
		}

		// optional fps display
		if (fpsEnabled) {
			fill(255);
			textFont(smallFont,8);
			text("fps: " + Math.round(fps * .1)/.1,8,8);
		}
	}
	
	public PImage shot() {
		return get();
	}

	public GameState nextState() {
		if (inMenu == true) {
			inMenu = false;
			MenuState menuState = new MenuState();
			menuState.setNextState(this);
			menuState.setScreenshot(this);
			return menuState;
		}

	    if (gameOver == true) {
			GameOverState gameOverState = new GameOverState();
			gameOverState.setScreenshot(this);
			return gameOverState;
	    }
	    else{
	    	return this;
	    }
	
	}

	// TODO: instead of setting X etc, set a variable and let update() move pieces.
	public void keyPressed() {
		
		// left arrow key
		if (keyCode == controlLeft) {
			pressedLeft = true;
			/*
			if (! gridCollideX(currentPiece.getBlocks(), -1)) {
				currentPiece.setX(currentPiece.getX() - blockSize, playField[0].getX());				
			}
			*/
		}

		// right arrow key
		if (keyCode == controlRight) {
			/*
			if (! gridCollideX(currentPiece.getBlocks(), 1)) {
				currentPiece.setX(currentPiece.getX() + blockSize, playField[1].getX());
			}*/
			pressedRight = true;
		}

		// up arrow key
		if (keyCode == controlRotate) {
			// checks collision with grid
			//println("PLAYSTATE THINKS:" + currentPiece.rotateCollide(deadGrid, playField, gridSizeX, gridSizeY));
			pressedRotate = true;
		}

		// down arrow key
		if (keyCode == controlDown) {
			pressedDown = true;
		}
		
		// space bar
		if (keyCode == controlDrop) {
			pressedDrop = true;
			// drop piece sound fx
			if (soundEnabled) dropFx.trigger();
		}
		
		if (key == ESC) {
			inMenu = true;
			key = 0;  // Fools! don't let them escape!
			if (soundEnabled) pauseFx.trigger();
		}
	}
	
	public void keyReleased() {

	}
	
	
	/*
	copyToGrid() kills the current piece and moves it to the dead grid
	it also scans the deadgrid for done rows, this takes many passes.
	 */
	void copyToGrid() {
		if (soundEnabled) downFx.trigger();
		
		// get a temp copy of the current piece to test with
		Block copyBlock[] = currentPiece.getBlocks();
		
		// remember which rows are affected (used later)
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
				// TODO: this should never be hit
				println("!!!  HOLY ASS TEETH !!");
				// catch nothing, I'm doing horrible shit here to test
			}
		}
		
		// mark filled rows (tetrises) into doneRows ArrayList
		// loop through 2 dimensional array without knowing length
		ArrayList doneRows = new ArrayList();
        ArrayList nonEmptyRows = new ArrayList();
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
					//println("ROW " + j + " DONE");				
				}
			}
		}
		
		// now we remove rows if there are any to be done
		if (doneRows.size() > 0) {
			
			score.scoreLines(doneRows.size());
			level.update(score.getLines());
			currentTimer = level.getTimer();
			
			// temp effects for test
			int x = (int)playField[0].getX();								// x start of row flash animation
			int w = (int)playField[1].getX() - (int)playField[0].getX();	// width of row flash animation
			int h = (int)blockSize;											// height of row flash animation
			for (int i=0; i < doneRows.size(); i++) {
				int row = (Integer)doneRows.get(i);
				int y = row * (int)blockSize + (int)playField[0].getY();	// y start of row flash animation
				anim.add(new RowAnimation(tatris, x, y, w, h, row));	
			}


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
				
				// if empty is equal to cols then it's an empty row but there are lots of empty rows
				// so check that the row is one that we cleared (in rowsAffected)
				if (empty == cols && rowsAffected.indexOf(rowsI) > -1 ) {
					emptyRows.add(rowsI);
					//println("empty index" + (rowsAffected.indexOf(rowsI) > -1));				
				} else if (empty < cols) {
					//println("ROW NONEMPTY" + rowsI);
					nonEmptyRows.add(rowsI);
				}
			}
			
			// Loop through all nonEmptyRowNums, then loop through emptyRows
			// If nonEmptyRowNum < emptyRowNum
			// Add 1 to hashMap of nonEmptyRowNum, store "need to fall" in a hashmap.
			// For example 25,26,27,28 get filled with 4 line tetris.
			// 26, 27, 28 are done.  25 gets +1, +1, +1 = 3.  Row 25 needs to move down 3 lines.

			// use TreeMap because it's a sorted HashMap, sort in reverse (rows restack bottom to top)
			TreeMap needToFall = new TreeMap(Collections.reverseOrder());

			// loop through non empty rows
			int nonEmptyRowNum;
			int emptyRowNum;


			for(Iterator i = nonEmptyRows.iterator(); i.hasNext(); ) {
				nonEmptyRowNum = (Integer)i.next();

				for(int j=0; j < emptyRows.size(); j++) {
					emptyRowNum = ((Integer)emptyRows.get(j)).intValue();
					//println("nonEmpty,empty:" + nonEmptyRowNum + "," + emptyRowNum);

					// there is one row below us, add 1 to "need to fall" for this row
					if (nonEmptyRowNum < emptyRowNum) {
						if (needToFall.containsKey(nonEmptyRowNum)) {
							int tmp = ((Integer)needToFall.get(nonEmptyRowNum)).intValue();                                                          
							//println("sure has:" + i);
							needToFall.put(nonEmptyRowNum, ++tmp);
						} else {
							needToFall.put(nonEmptyRowNum, 1);
						}
					}
				}
			}

			//println(needToFall);

			// loop through our needToFall map and make them fall by rows stored
			Iterator ntfi = needToFall.entrySet().iterator();
			while (ntfi.hasNext()) {
				Map.Entry row = (Map.Entry) ntfi.next();
				int rowNum = (Integer)row.getKey();
				//println("moving row:"+rowNum);
				int rowDistance = (Integer)row.getValue();
				// loop through columns
				for (int colNum=0; colNum < cols; colNum++) {
					// skip blank blocks (throws a NPE)
					if (compressedGrid[colNum][rowNum] != null) {
						// get block into variable for easier get() methods later
						Block cgb = compressedGrid[colNum][rowNum];
						// new block because of java memory gotcha, can't just get from trimmedGrid
						Block b = new Block(cgb.getX(), cgb.getY(), cgb.getHeight(), cgb.getFillColor());
						b.setY(b.getY() + (rowDistance * blockSize));
						// copy row above
						compressedGrid[colNum][rowNum+rowDistance] = b;
						//print("C:"+colNum+"RD:"+(rowNum+rowDistance)+" ");
						// delete row above, otherwise it will copy itself all the way down
						compressedGrid[colNum][rowNum] = null;
					}
				}
			}
			// compressedGrid is flattened and removed of done rows
			deadGrid = compressedGrid;
		}

		// test field against nextPiece spawn point
		Block newPieceBlocks[] = nextPiece.getBlocks();
		for (int i=0; i < 4; i++) {
			int npx = (int)((newPieceBlocks[i].getX() - playField[0].getX()) / blockSize);
			int npy = (int)((newPieceBlocks[i].getY() - playField[0].getY()) / blockSize);

			// otherwise, can't spawn, game is over
			if (deadGrid[npx][npy] != null) {
				println("GAME OVER MAN");
				gameOver=true;
			}
		}
		
		// new piece HERE
		//currentPiece = new LPiece(playField[1].getX() / 2, 32.0f);
		//currentPiece = pieceBag.getPiece();
		// if piece doesn't collide with grid set currentPiece to got piece
		currentPiece = nextPiece;
		nextPiece = pieceBag.getPiece();
		
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
	
	/*
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
					//println("testing:" + x + "," + y);
					// we hit something on the grid
					if(deadGrid[x-1][y-1] != null) {
						println("deny left");
						return true;
					}
				}
			}
			
		}

		return false;

	}*/
	
	// check for blocks on X, -1 is left, 1 is right
	boolean gridCollideX(Block checkBlocks[], int direction) {	
		//Block copyBlock[] = currentPiece.getBlocks();
		
		for (int i=0; i < 4; i++) {
			Float fx = (checkBlocks[i].getX() - playField[0].getX()) / blockSize;
			Float fy = (checkBlocks[i].getY() - playField[0].getY()) / blockSize;
			
			//println("block" + i + " " + fx * blockSize + " " + fy * blockSize);
			if (direction > 0) {
				// piece is going to the right, check to the right
				int checkIndexX = fx.intValue() + 1;			
				// limit x to edge of playfield
				if (checkIndexX < gridSizeX - 1) {
					int checkIndexY = fy.intValue();
					// we hit something on the grid
					if(deadGrid[checkIndexX][checkIndexY] != null) {
						//System.out.println("deny right");
						return true;
					}		
				}
				
			} else {
				// piece is going to the left, check to the left
				int checkIndexX = fx.intValue() - 1;
				// limit x to edge of playfield
				if (checkIndexX > 0) {
					int checkIndexY = fy.intValue();
					//println("testing:" + x + "," + y);
					// we hit something on the grid
					if(deadGrid[checkIndexX][checkIndexY] != null) {
						//System.out.println("deny left");
						return true;
					}
				}
			}
			
		}

		return false;

	}
	
	
		
	void offscreenBuffers() {
		
		// border box around playfield, +3 is for interior padding border
		int xlen = (int)(playField[1].getX() - playField[0].getX()) + 3;
		int ylen = (int)(playField[1].getY() - playField[0].getY()) + 3;
		overlay = createGraphics( xlen + 3, ylen + 3, JAVA2D);
		overlay.beginDraw();
		overlay.strokeWeight(1);
  		overlay.stroke(255);
		overlay.line(0, 0, xlen, 0);	// top line
		overlay.line(xlen, 0, xlen, ylen);	// right line
		overlay.line(xlen, ylen, 0, ylen); // bottom line		
		overlay.line(0, ylen, 0, 0); // left line				
		overlay.endDraw();
		
		// grid lines on playfield
		grid = createGraphics( (int)(gridSizeX * blockSize) + 1, (int)(gridSizeY * blockSize) + 1, JAVA2D);
		grid.beginDraw();
		grid.background(0);
		grid.strokeWeight(1);
		grid.stroke(20);
		for (float i=0; i <= gridSizeX; i++) {
			for (float j=0; j <= gridSizeY; j++) {
		    	grid.line(i*blockSize, 0, i*blockSize, gridSizeY*blockSize);
		    	grid.line(0, j*blockSize, gridSizeX*blockSize, j*blockSize);
			}
		}
		grid.endDraw();
		
		xlen = (int)(width - playField[1].getX());
		ylen = (int)(playField[1].getY());
		sidebar = createGraphics(xlen, ylen, JAVA2D);
		sidebar.beginDraw();

		// next box
		sidebar.strokeWeight(1);
		sidebar.stroke(255);
		sidebar.fill(0);
		sidebar.rect(blockSize, playField[0].getY(), blockSize * 6, blockSize * 6);
		sidebar.rect(blockSize, 0, blockSize * 6, blockSize);
		sidebar.textFont(visitorFont, 20);
		sidebar.fill(255);
		// hardcode 18 as textWidth because of weird bug when starting a new game
		sidebar.text("NEXT", (blockSize * 3) - 18, playField[0].getY() - 2);
		
		// score box
		sidebar.fill(0);
		sidebar.rect(blockSize, playField[0].getY() + blockSize * 8, blockSize * 6, blockSize * 3);
		sidebar.rect(blockSize, playField[0].getY() + blockSize * 7, blockSize * 6, blockSize);
		sidebar.textFont(visitorFont, 20);
		sidebar.fill(255);
		sidebar.text("SCORE", (blockSize * 3) - 18, playField[0].getY() + blockSize * 8 - 2);
		
		// lines box
		sidebar.fill(0);
		sidebar.rect(blockSize, playField[0].getY() + blockSize * 13, blockSize * 6, blockSize * 3);
		sidebar.rect(blockSize, playField[0].getY() + blockSize * 12, blockSize * 6, blockSize);
		sidebar.textFont(visitorFont, 20);
		sidebar.fill(255);
		sidebar.text("LINES", (blockSize * 3) - 18, playField[0].getY() + blockSize * 13 - 2);
		
		// level box
		sidebar.fill(0);
		sidebar.rect(blockSize, playField[0].getY() + blockSize * 18, blockSize * 6, blockSize * 3);
		sidebar.rect(blockSize, playField[0].getY() + blockSize * 17, blockSize * 6, blockSize);
		sidebar.textFont(visitorFont, 20);
		sidebar.fill(255);
		sidebar.text("LEVEL", (blockSize * 3) - 18, playField[0].getY() + blockSize * 18 - 2);

		sidebar.endDraw();

		// badge
		badge = createGraphics(300, 48, JAVA2D);
		badge.beginDraw();		
		// badge.background(0, 0);
		// badge.fill(255,255,255,120);
		//badge.rect(25,25,25,25);
		badge.textFont(visitorFont, 32);
		badge.text("TATRIS", 25, 25);
		badge.endDraw();

		
	}
	
	void dropPiece() {
		// get greatest Y values
		Block yBlocks[] = currentPiece.getMaxYBlocks();
		
		int columns[] = new int[yBlocks.length];
		for (int i=0; i < yBlocks.length; i++) {
			columns[i] = (int)((yBlocks[i].getX() - playField[0].getX()) / blockSize);
			//println (columns[i]);
			
			// store the least Y value for yStart later
			//println("YB:" + yBlocks[i].getX() + "," + yBlocks[i].getY());
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
				
				if(deadGrid[(int)columns[col]][row] != null) {
					hitSomething = true;
					
					// this is a point of colision
					hitPoint = deadGrid[(int)columns[col]][row];

					// remember where we hit the grid
					hitPoints.add(hitPoint);

					//println("hitPoints: " + hitPoint.getX() + "," + hitPoint.getY() + "hitsomething=" + hitSomething);
				}
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
			
			// give points for dropping piece
			score.scoreDrop((int)closest);
					
			// the piece might go through the floor even if we checked grid collide, check it again
			//println("new:" + newYPosition + " playY:" + playField[1].getY() + " yb" + currentPiece.getMaxY());
			float heightOffset = currentPiece.getMaxY() - currentPiece.getY();
			if (newYPosition + heightOffset >= playField[1].getY() - playField[0].getY()) {
				float correction = newYPosition - (playField[1].getY() - playField[0].getY()) + heightOffset;
				newYPosition = newYPosition - correction; 
			}
			
			// set x,y of piece minus offset of block
			currentPiece.setY(newYPosition);
			currentPiece.update();
			
			// TODO: why do I have to do this instead of copyToGrid()?
			//timer = 0;
			copyToGrid();		
			
		} else {
			// How long is piece from the center?
			float heightOffset = currentPiece.getMaxY() - currentPiece.getY();
			
			score.scoreDrop((int)(playField[1].getY() - currentPiece.getMaxY()));		
			
			// Nothing below, just drop.  But factor in piece length on Y.
			currentPiece.setY(playField[1].getY() - playField[0].getY() - heightOffset);
			currentPiece.update();

			// TODO: why do I have to do this instead of copyToGrid()?
			//timer = 0;
			copyToGrid();
		}
		
	}
	
	void enableTest(int test) {
		// starting line number to fill
		int tmp = 28;
		String testColor = "#44FF44";

		switch(test) {			
			// ONE LINE TEST
			case 1:
				for (int i=0; i < 11; i++) {
					if (i != 7){
						deadGrid[i][tmp] = new Block(i*blockSize + playField[0].getX(), tmp*blockSize + playField[0].getY(), blockSize, testColor);
					}
				}
				break;

			// TWO LINE TEST			
			case 2:
				for (int i=0; i < 11; i++) {
					if (i != 8){
						deadGrid[i][tmp] = new Block(i*blockSize + playField[0].getX(), tmp*blockSize + playField[0].getY(), blockSize, testColor);
					}
				}
				tmp--;
				for (int i=0; i < 11; i++) {
					if (i != 8){
						deadGrid[i][tmp] = new Block(i*blockSize + playField[0].getX(), tmp*blockSize + playField[0].getY(), blockSize, testColor);
					}
				}
				break;
				
			// 3 LINE TEST
			case 3:
				for (int i=0; i < 11; i++) {
					if (i != 8){
						deadGrid[i][tmp] = new Block(i*blockSize + playField[0].getX(), tmp*blockSize + playField[0].getY(), blockSize, testColor);
					}
				}
				tmp--;
				for (int i=0; i < 11; i++) {
					if (i != 8){
						deadGrid[i][tmp] = new Block(i*blockSize + playField[0].getX(), tmp*blockSize + playField[0].getY(), blockSize, testColor);
					}
				}
				tmp--;
				for (int i=0; i < 11; i++) {
					if (i != 8){
						deadGrid[i][tmp] = new Block(i*blockSize + playField[0].getX(), tmp*blockSize + playField[0].getY(), blockSize, testColor);
					}
				}
			
			
				break;
			
			// ONE LINE, TWO SPACES TO FILL
			case 5:
				for (int i=0; i < 11; i++) {
					if (i != 7 && i != 8){
						deadGrid[i][tmp] = new Block(i*blockSize + playField[0].getX(), tmp*blockSize + playField[0].getY(), blockSize, testColor);
					}
				}
				tmp--;
				for (int i=0; i < 11; i++) {
					if (i != 7 && i != 8){
						deadGrid[i][tmp] = new Block(i*blockSize + playField[0].getX(), tmp*blockSize + playField[0].getY(), blockSize, testColor);
					}
				}
				break;
			
			// BUMPY ROTATE GRID TEST
			case 6:
				for (int i=0; i < 11; i++) {
					if (i != 8){
						deadGrid[i][tmp] = new Block(i*blockSize + playField[0].getX(), tmp*blockSize + playField[0].getY(), blockSize, testColor);
					}
				}
				tmp--;
				for (int i=0; i < 11; i++) {
					if (i != 8){
						deadGrid[i][tmp] = new Block(i*blockSize + playField[0].getX(), tmp*blockSize + playField[0].getY(), blockSize, testColor);
					}
				}
				tmp--;
				for (int i=5; i < 8; i++) {
						deadGrid[i][tmp] = new Block(i*blockSize + playField[0].getX(), tmp*blockSize + playField[0].getY(), blockSize, testColor);
				}
				tmp--;
				deadGrid[7][tmp] = new Block(7*blockSize + playField[0].getX(), tmp*blockSize + playField[0].getY(), blockSize, testColor);
				break;
			
			
			// SINGLE GODDAMN BLOCK TEST -- THROUGH FLOOR BUG
			case 7:
				deadGrid[7][28] = new Block(7*blockSize + playField[0].getX(), 28*blockSize + playField[0].getY(), blockSize, testColor);
				break;
			
			// 2 done, 1 not, 1 done, 1 not, 1 done TEST
			// white lines should be removed
			case 8:
		        tmp = gridSizeY-1;
				for (int i=0; i < gridSizeX; i++) {
					if (i != 8){
						deadGrid[i][tmp] = new Block(i*blockSize + playField[0].getX(), tmp*blockSize + playField[0].getY(), blockSize, "#FFFFFF");
					}
				}
				tmp--;
				for (int i=0; i < gridSizeX; i++) {
					if (i != 8){
						deadGrid[i][tmp] = new Block(i*blockSize + playField[0].getX(), tmp*blockSize + playField[0].getY(), blockSize, "#FFFFFF");
					}
				}
				tmp--;
				for (int i=0; i < gridSizeX; i++) {
					if (i != 8 && i != 7){
						deadGrid[i][tmp] = new Block(i*blockSize + playField[0].getX(), tmp*blockSize + playField[0].getY(), blockSize, "#FF1111");
					}
				}
				tmp--;
				for (int i=0; i < gridSizeX; i++) {
					if (i != 8){
						deadGrid[i][tmp] = new Block(i*blockSize + playField[0].getX(), tmp*blockSize + playField[0].getY(), blockSize, "#FFFFFF");
					}
				}
				tmp--;
				for (int i=0; i < gridSizeX; i++) {
					if (i != 8 && i != 7){
						deadGrid[i][tmp] = new Block(i*blockSize + playField[0].getX(), tmp*blockSize + playField[0].getY(), blockSize, "#FF1111");
					}
				}
				tmp--;
				for (int i=0; i < gridSizeX; i++) {
					if (i != 8){
						deadGrid[i][tmp] = new Block(i*blockSize + playField[0].getX(), tmp*blockSize + playField[0].getY(), blockSize, testColor);
					}
				}
				currentPiece = new IPiece(playField[1].getX()/2, 32.0f);
				break;
			
			// side collision test
			case 9:
			 	tmp = gridSizeY-1;
				for (int k=0; k<8; k++){

					for (int i=0; i < gridSizeX; i++) {
						if (i > 5){
							deadGrid[i][tmp] = new Block(i*blockSize + playField[0].getX(), tmp*blockSize + playField[0].getY(), blockSize, "#44FF44");
						}
					}
					tmp--;
				}
				break;
			
			// reverse side colli test
			case 10:
				int j=11;
				for (int row=29; row > 22; row--){
					j--;
					for (int i=10; i > j; i--) {
						deadGrid[i][row] = new Block(i*blockSize + playField[0].getX(), row*blockSize + playField[0].getY(), blockSize, "#44FF44");
					}
				}
				break;
			
			
		}
		
		/*
		*/
	}
}