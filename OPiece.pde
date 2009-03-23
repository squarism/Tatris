class OPiece extends Piece {
		
	/*
		## 01             
	    ## 23 
		990000  (red)
	*/
		
	public OPiece(float x, float y) {
		super.setX(x);
		super.setY(y);

		for (int i=0; i<4; i++) {
			blocks[i] = new Block(x + offsetX[i], y + offsetY[i], blockSize, "#AA1111");
		}
		update();
		
		super.round(blocks[0]);
		super.round(blocks[1]);
		super.round(blocks[2]);
		super.round(blocks[3]);
	}
	
	/* Call this whenever moving or rotating */
	public void update() {

        offsetX[0] = 0;
        offsetX[1] = sin(rotation + radians(90)) * blockSize;
  		offsetX[2] = sin(rotation + radians(180)) * blockSize;
  		offsetX[3] = sin(rotation + radians(135)) * blockSize;

        offsetY[0] = 0;
		offsetY[1] = cos(rotation + radians(270)) * blockSize;
		offsetY[2] = cos(rotation + radians(0)) * blockSize;
		offsetY[3] = cos(rotation + radians(315)) * blockSize;
		
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
		testOffsetX[1] = sin(testRotation + radians(90)) * blockSize;
		testOffsetX[2] = sin(testRotation + radians(180)) * blockSize;
		testOffsetX[3] = sin(testRotation + radians(135)) * blockSize;

        testOffsetY[0] = 0;
		testOffsetY[1] = cos(testRotation + radians(270)) * blockSize;
		testOffsetY[2] = cos(testRotation + radians(0)) * blockSize;
		testOffsetY[3] = cos(testRotation + radians(315)) * blockSize;

		// round our test offsets to blocksize
		for (int i=0; i<4; i++) {
			testOffsetX[i] = Math.round(testOffsetX[i] / blockSize) * blockSize;
			testOffsetY[i] = Math.round(testOffsetY[i] / blockSize) * blockSize;
		}
	}
	
	
	
}
