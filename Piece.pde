import java.util.ArrayList;

// blocks move together as one set of blocks, offset by shape pattern
class Piece {
	
	float x;		// center x
	float y;		// center y
	float blockSize=16.0f;	// used as offset, width and height
	float rotation=radians(0.0f);
	Block pivotPoint = new Block(x,y, blockSize, "#AAAAAA"); // for debug
	Block[] blocks = new Block[4];
	
	// offsets are relative to pivotpoint (center)
	// block numbers are in ASCII art at top
	// * is pivot point	
	float offsetX[] = new float[4];
	float offsetY[] = new float[4];
	
	
	float testOffsetX[] = new float[4];
	float testOffsetY[] = new float[4];
	
	float testRotation;
	

	public void setRotation(float angle) {
		//println("super setRotation");
		this.rotation = angle;
	}
	
	public void draw() {
		for (int i=0; i < 4; i++) {
			blocks[i].draw(x,y);
		}
		//pivotPoint.draw(x,y);

	}
	
	public float getRotation() {
		return rotation;
	}
	
	public void setX(float x) {
		pivotPoint.setX(x);
	}
	
	/*
	public void setX(float x, float wall) {
		pivotPoint.setX(x);
	}*/
	
	public void setY(float y) {
		pivotPoint.setY(y);
	}
	
	public float getX() {
		return pivotPoint.getX();
	}
	
	public float getY() {
		return pivotPoint.getY();
	}
	
	public void round(Block block) {
		// TODO: uncomment and refactor this
		/*
		for (int i=0; i < blocks.length; i++) {
			println("rounding" + i);
			blocks[i].setX(Math.round(blocks[i].getX() / blockSize) * blockSize);
			blocks[i].setY(Math.round(blocks[i].getY() / blockSize) * blockSize);
		}*/
		// rounding to line up with grid
		//println("before round x:" + block.getX() + " y:" + block.getY());
		block.setX(Math.round(block.getX() / blockSize) * blockSize);
		block.setY(Math.round(block.getY() / blockSize) * blockSize);
		//println("after round x:" + block.getX() + " y:" + block.getY());
	}
	
	public void update() {
		
	}
	
	public boolean nearGrid(Block deadGrid[][], Point2d playField[], int gridSizeX, int gridSizeY) {
		// center of piece x
		float cx = pivotPoint.getX();
		float cy = pivotPoint.getY();
		
		int bx = (int)((cx - playField[0].getX()) / blockSize);
		int by = (int)((cy - playField[0].getY()) / blockSize);
		
		// TODO: pass this in instead
		//int gridSizeX = (int)((playField[1].getX() - playField[0].getX() ) / blockSize);
		//int gridSizeY = (int)((playField[1].getY() - playField[0].getY() ) / blockSize);
		
		// check for nearby pieces, 2 blocks in each direction, 5x5 total
		boolean nearAnything = false;
		int mx;
		int my;
		for (int ix=-3; ix <= 3; ix++) {
			for (int iy=-3; iy <= 3; iy++) {
				// create temp "marked" blocks for a few tests
				mx = (int)bx+ix;
				my = (int)by+iy;
				// don't test out of bounds
				if ( mx >= 0 && mx < gridSizeX && my >= 0 && my < gridSizeY ) { 
					if (deadGrid[mx][my] != null) {
						// we are near something on the deadGrid
						return true;
					}
				}
			}
		}
		// println("nearGrid thinks false");
		return false;
	}
	
	public boolean rotateCollideX(float wallStart, float wallWidth) {
		// are we more right?
		if (pivotPoint.getX() > wallWidth / 2) {
			if (pivotPoint.getX() + blockSize * 3 < wallWidth) {
				//println("nowhere close near east wall");
				return false;
			} else {
				/*
				float tmpRotation = rotation + radians(90.0f);
				float tmpOffsetX[] = new float[4];
				tmpOffsetX[0] = 0;
				tmpOffsetX[1] = sin(tmpRotation + radians(180)) * blockSize;
				tmpOffsetX[2] = sin(tmpRotation + radians(135)) * (blockSize + (blockSize / 2));
				tmpOffsetX[3] = sin(tmpRotation + radians(0)) * blockSize;
				*/
				
				for (int i=0; i < 4; i++) {
					float testX = pivotPoint.getX()+testOffsetX[i];
					testX = Math.round(testX / blockSize) * blockSize;
					if (testX >= wallWidth) {
						//println("denied " + i);
						return true;
					}
				}
				
				//println("allowed east");
				return false;
			}
			
		// or are we more left?
		} else {
			if (pivotPoint.getX() - blockSize > wallStart) {
				//println("nowhere close near west wall");
				return false;
			} else {
				/*
				float tmpRotation = rotation + radians(90.0f);
				float tmpOffsetX[] = new float[4];
				tmpOffsetX[0] = 0;
				tmpOffsetX[1] = sin(tmpRotation + radians(180)) * blockSize;
				tmpOffsetX[2] = sin(tmpRotation + radians(135)) * (blockSize + (blockSize / 2));
				tmpOffsetX[3] = sin(tmpRotation + radians(0)) * blockSize;
				*/
				
				
				for (int i=0; i < 4; i++) {
					float testX = pivotPoint.getX() + testOffsetX[i];
					//testX = Math.round(testX / blockSize) * blockSize;
					if (testX < wallStart) {
						//println("denied " + i);
						return true;
					}
				}
				
				//println("allowed east");
				return false;
			}	
		}
	}
	
	public boolean rotateCollideY(float roomStart, float roomWidth) {
		return false;
	}
	
	public boolean rotateCollideYHit(float roomStart, float roomWidth) {

		/*
				float tmpRotation = rotation + radians(90.0f);
				float tmpOffsetX[] = new float[4];
				tmpOffsetX[0] = 0;
				tmpOffsetX[1] = sin(tmpRotation + radians(180)) * blockSize;
				tmpOffsetX[2] = sin(tmpRotation + radians(135)) * (blockSize + (blockSize / 2));
				tmpOffsetX[3] = sin(tmpRotation + radians(0)) * blockSize;
				*/
				
				for (int i=0; i < 4; i++) {
					float testX = pivotPoint.getX() + testOffsetX[i];
					testX = Math.round(testX / blockSize) * blockSize;
					if (testX >= roomWidth) {
						//println("denied " + i);
						return true;
					}
				}
				//println("allowed down");
				return false;


	}
	
	public boolean rotateCollide(Block deadGrid[][], Point2d playField[], int gridSizeX, int gridSizeY) {
		// this should never be hit
		return false;
	}
	
	public boolean rotateCollideHit(Block deadGrid[][], int gridSizeX, int gridSizeY, float testOffsetX[], float testOffsetY[], Point2d playField[]) {
		int testX;
		int testY;
		// TODO: take out hit?
		boolean hit = false;
		
		for (int i=0; i<4; i++) {
			testX = (int) ((pivotPoint.getX() - playField[0].getX() + testOffsetX[i]) / blockSize);
			testY = (int) ((pivotPoint.getY() - playField[0].getY() + testOffsetY[i]) / blockSize);
			//println("PIECE TESTOFFSET:" + testOffsetX[i]);
			
			// make sure we don't test past our bounds
			if (testX < gridSizeX && testY < gridSizeY) {		
				// if deadGrid isn't null then some block is there
				if (deadGrid[testX][testY] != null) {
					// TODO: take out hit?
					hit = true;
					//println("rotateCollideHit is TRUE");
					return true;
				}
			} else {
				//println("AT BOTTOM AND NEAR GRID OMG DO NOT ROTATE");
				// we're at the bottom of the screen and we hit grid
				return true;
			}
		}
		return false;
	}
	
	public Block[] getBlocks() {
		return blocks;
	}
	
	// absolute
	public float getMaxX() {
		float greatest = 0;
		for (int i=0; i<4; i++) {
			if (blocks[i].getX() > greatest) {
				greatest = blocks[i].getX() + x;
			}
		}
		return greatest;
	}

	public float getMaxY() {
		float greatest = 0;
		for (int i=0; i<4; i++) {
			if (blocks[i].getY() > greatest) {
				greatest = blocks[i].getY() + y;
			}
		}
		return greatest;	
	}

	// this is used when dropping pieces
	public Block[] getMaxYBlocks() {
		HashMap map = new HashMap();
		
		for (int i=0; i<blocks.length; i++) {
			Block test = (Block)map.get(blocks[i].getX());
			
			if(test != null) {
				if (blocks[i].getY() > test.getY()){
 					map.put(blocks[i].getX(), blocks[i]);					
				}
			} else {
				map.put(blocks[i].getX(), blocks[i]);					
			}

		}

		Block returnBlocks[] = new Block[map.size()];
		int i = 0;

		Set mapset= map.keySet();
		Iterator iter = mapset.iterator();
		while(iter.hasNext()){
			Float currentKey = (Float)iter.next();
			returnBlocks[i++] = (Block)map.get(currentKey);
		}

		return returnBlocks;	
	}
	
	// setx with a wall in mind for collision detect
	public void setX(float x, float wall) {

		boolean wallCollide = false;
		
		float xVector = 0;
		xVector = x-pivotPoint.getX();

		for (int i=0; i < 4; i++) {
			
			// we're going right
			if (xVector > 0 && blocks[i].getX() + xVector >= wall) {
				//println("we're going right");
				wallCollide = true;
			}
			// we're going left
			if (xVector < 0 && blocks[i].getX() + xVector < wall) {
				//println("we're going left");
				wallCollide = true;
			}
		}
		// we didn't hit a wall so set x
		if (!wallCollide){
			pivotPoint.setX(x);
		}
	}
	
		
}