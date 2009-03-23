class JPiece extends Piece {
	
	/*
			 #      3
			 #      0         
			##     21
			663300 (brown)
	*/
	
	public JPiece(float x, float y) {	
		super.setX(x);
		super.setY(y);
				
		for (int i=0; i<4; i++) {
			blocks[i] = new Block(x + offsetX[i], y + offsetY[i], blockSize, "#663300");
		}

		update();

		// 45 deg pieces don't line up right
		// TODO: figure out math to get rid of this		
		super.round(blocks[0]);
		super.round(blocks[1]);
		super.round(blocks[2]);
		super.round(blocks[3]);
	}
				
	public boolean rotateCollideX(float wallStart, float wallWidth) {	
		// update test coords for coll test
		testUpdate();
		return(super.rotateCollideX(wallStart, wallWidth));
	}
	
	public boolean rotateCollideY(float roomStart, float roomWidth) {
		// are we near the bottom?
		if (super.pivotPoint.getY() < roomWidth / 2) {
			if (super.pivotPoint.getY() + blockSize * 3 < roomWidth) {
				// we are nowhere near the bottom
				return false;
			} else {
				testUpdate();
				return(super.rotateCollideYHit(roomStart, roomWidth));
			}
		}
		// default return
		return false;	
	}
	
	public boolean rotateCollide(Block deadGrid[][], Point2d playField[], int gridSizeX, int gridSizeY) {
		//println("rotateCollide in LPiece");
		// are we near the grid, if not, don't waste cycles
		if (super.nearGrid(deadGrid, playField, gridSizeX, gridSizeY)) {
			testUpdate();
			// call super method to check for hit
			//println("rotateCollide in LPiece");
			return(super.rotateCollideHit(deadGrid, gridSizeX, gridSizeY, testOffsetX, testOffsetY, playField));
		}
		return false;
	}
	
	/* Call this whenever moving or rotating */
	public void update() {
		
		offsetX[0] = 0;
		offsetX[1] = sin(rotation + radians(180)) * blockSize;
		offsetX[2] = sin(rotation + radians(225)) * (blockSize + (blockSize / 2));
		offsetX[3] = sin(rotation + radians(0)) * blockSize;
		
		offsetY[0] = 0;
		offsetY[1] = cos(rotation + radians(0)) * blockSize;
		offsetY[2] = cos(rotation + radians(45)) * (blockSize + (blockSize / 2));
		offsetY[3] = cos(rotation + radians(180)) * blockSize;
		
		for (int i=0; i<4; i++) {
			blocks[i].setX(super.pivotPoint.getX() + offsetX[i]);
			blocks[i].setY(super.pivotPoint.getY() + offsetY[i]);
		}
		
		// rounding to line up with grid
		// TODO: better way?
		super.round(blocks[0]);
		super.round(blocks[1]);
		super.round(blocks[2]);
		super.round(blocks[3]);
		
	}
	
	// this method is called to test collision without updating position, it's like look-ahead
	public void testUpdate() {
		testRotation = rotation + radians(90.0f);
		
		testOffsetX[0] = 0;
		testOffsetX[1] = sin(testRotation + radians(180)) * blockSize;
		testOffsetX[2] = sin(testRotation + radians(225)) * (blockSize + (blockSize / 2));
		testOffsetX[3] = sin(testRotation + radians(0)) * blockSize;

        testOffsetY[0] = 0;
		testOffsetY[1] = cos(testRotation + radians(0)) * blockSize;
		testOffsetY[2] = cos(testRotation + radians(45)) * (blockSize + (blockSize / 2));
		testOffsetY[3] = cos(testRotation + radians(180)) * blockSize;

		// round our test offsets to blocksize
		for (int i=0; i<4; i++) {
			testOffsetX[i] = Math.round(testOffsetX[i] / blockSize) * blockSize;
			testOffsetY[i] = Math.round(testOffsetY[i] / blockSize) * blockSize;
		}
	}
	
	
}