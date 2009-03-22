class LPiece extends Piece {
	
	/*
			3   #
			0  #           
			12  ##
			
			3366CC (blue)
	*/
	
	// offsets are relative to pivotpoint (center)
	// block numbers are in ASCII art at top
	// * is pivot point	
	float offsetX[] = new float[4];
	float offsetY[] = new float[4];

	public LPiece(float x, float y) {	
		super.setX(x);
		super.setY(y);
				
		blocks[0] = new Block(x + offsetX[0], y + offsetY[0], blockSize, "#3366CC");
		blocks[1] = new Block(x + offsetX[1], y + offsetY[1], blockSize, "#3366CC");
		blocks[2] = new Block(x + offsetX[2], y + offsetY[2], blockSize, "#3366CC");
		blocks[3] = new Block(x + offsetX[3], y + offsetY[3], blockSize, "#3366CC");

		update();

		// 45 deg pieces don't line up right
		// TODO: figure out math to get rid of this		
		super.round(blocks[0]);
		super.round(blocks[1]);
		super.round(blocks[2]);
		super.round(blocks[3]);
	}
		
	// TODO: refactor cleaner
	public boolean rotateCollideX(float wallStart, float wallWidth) {
		
		// are we more right?
		if (super.pivotPoint.getX() > wallWidth / 2) {
			if (super.pivotPoint.getX() + blockSize * 3 < wallWidth) {
				//println("nowhere close near east wall");
				return false;
			} else {
				float tmpRotation = rotation + radians(90.0f);
				float tmpOffsetX[] = new float[4];
				tmpOffsetX[0] = 0;
				tmpOffsetX[1] = sin(tmpRotation + radians(180)) * blockSize;
				tmpOffsetX[2] = sin(tmpRotation + radians(135)) * (blockSize + (blockSize / 2));
				tmpOffsetX[3] = sin(tmpRotation + radians(0)) * blockSize;
				
				for (int i=0; i < 4; i++) {
					float testX = super.pivotPoint.getX()+tmpOffsetX[i];
					testX = Math.round(testX / blockSize) * blockSize;
					if (testX >= wallWidth) {
						println("denied " + i);
						return true;
					}
				}
				
				//println("allowed east");
				return false;
			}
			
		// or are we more left?
		} else {
			if (super.pivotPoint.getX() > wallStart) {
				//println("nowhere close near west wall");
				return false;
			} else {
				float tmpRotation = rotation + radians(90.0f);
				float tmpOffsetX[] = new float[4];
				tmpOffsetX[0] = 0;
				tmpOffsetX[1] = sin(tmpRotation + radians(180)) * blockSize;
				tmpOffsetX[2] = sin(tmpRotation + radians(135)) * (blockSize + (blockSize / 2));
				tmpOffsetX[3] = sin(tmpRotation + radians(0)) * blockSize;
				
				
				for (int i=0; i < 4; i++) {
					float testX = super.pivotPoint.getX() + tmpOffsetX[i];
					testX = Math.round(testX / blockSize) * blockSize;
					if (testX < wallWidth - blockSize / 2) {
						//println("denied " + i);
						return true;
					}
				}
				
				//println("allowed east");
				return false;
			}	
		}
	}
	
	// TODO: refactor cleaner
	public boolean rotateCollideY(float roomStart, float roomWidth) {
		
		// are we near the bottom?
		if (super.pivotPoint.getY() < roomWidth / 2) {
			if (super.pivotPoint.getY() + blockSize * 3 < roomWidth) {
				// we are nowhere near the bottom
				return false;
			} else {
				float tmpRotation = rotation + radians(90.0f);
				float tmpOffsetX[] = new float[4];
				tmpOffsetX[0] = 0;
				tmpOffsetX[1] = sin(tmpRotation + radians(180)) * blockSize;
				tmpOffsetX[2] = sin(tmpRotation + radians(135)) * (blockSize + (blockSize / 2));
				tmpOffsetX[3] = sin(tmpRotation + radians(0)) * blockSize;

				for (int i=0; i < 4; i++) {
					float testX = super.pivotPoint.getX()+tmpOffsetX[i];
					testX = Math.round(testX / blockSize) * blockSize;
					if (testX >= roomWidth) {
						//println("denied " + i);
						return true;
					}
				}

				println("allowed down");
			}
		}

		// default return
		return false;
	}
	
	// TODO: refactor cleaner
	public boolean rotateCollide(Block deadGrid[][], Point2d playField[]) {
		
		// center of piece x
		float cx = super.pivotPoint.getX();
		float cy = super.pivotPoint.getY();
		
		int bx = (int)((cx - playField[0].getX()) / blockSize);
		int by = (int)((cy - playField[0].getY()) / blockSize);
		
		// TODO: pass this in instead
		int gridSizeX = (int)((playField[1].getX() - playField[0].getX() ) / blockSize);
		int gridSizeY = (int)((playField[1].getY() - playField[0].getY() ) / blockSize);
		
		// check for nearby pieces, 2 blocks in each direction, 5x5 total
		boolean nearAnything = false;
		int mx;
		int my;
		for (int ix=-1; ix <= 1; ix++) {
			for (int iy=-1; iy <= 1; iy++) {
				// create temp "marked" blocks for a few tests
				mx = (int)bx+ix;
				my = (int)by+iy;
				// don't test out of bounds
				if ( mx >= 0 && mx < gridSizeX && my >= 0 && my < gridSizeY ) { 
					if (deadGrid[mx][my] != null) {
						// we are near something on the deadGrid
						nearAnything = true;
					}
				}
			}
		}
		
		
		//println("NEAR ANYTHING:" + nearAnything);
		if (nearAnything) {
			float tmpRotation = rotation + radians(90.0f);
			float tmpOffsetX[] = new float[4];
			float tmpOffsetY[] = new float[4];
			tmpOffsetX[0] = 0;
			tmpOffsetX[1] = sin(tmpRotation + radians(180)) * blockSize;
			tmpOffsetX[2] = sin(tmpRotation + radians(135)) * (blockSize + (blockSize / 2));
			tmpOffsetX[3] = sin(tmpRotation + radians(0)) * blockSize;
			
			tmpOffsetY[0] = 0;
			tmpOffsetY[1] = cos(tmpRotation + radians(0)) * blockSize;
			tmpOffsetY[2] = cos(tmpRotation + radians(315)) * (blockSize + (blockSize / 2));
			tmpOffsetY[3] = cos(tmpRotation + radians(180)) * blockSize;
			
			
			int testX;
			int testY;
			// TODO: take out hit?
			boolean hit = false;
			for (int i=0; i<4; i++) {
				testX = (int) ((super.pivotPoint.getX()+tmpOffsetX[i]) / blockSize);
				testY = (int) ((super.pivotPoint.getY()+tmpOffsetY[i]) / blockSize);
				
				// make sure we don't test past our bounds
				if (testX < gridSizeX && testY < gridSizeY) {		
					// if deadGrid isn't null then some block is there
					if (deadGrid[testX][testY] != null) {
						// TODO: take out hit?
						hit = true;
						return true;
					}
				} else {
					println("Disaster averted!");
				}
			}
						
		}
		return false;
	}
	
	/* Call this whenever moving or rotating */
	public void update() {
		
		offsetX[0] = 0;
		offsetY[0] = 0;
		offsetX[1] = sin(rotation + radians(180)) * blockSize;
		offsetY[1] = cos(rotation + radians(0)) * blockSize;
		offsetX[2] = sin(rotation + radians(135)) * (blockSize + (blockSize / 2));
		offsetY[2] = cos(rotation + radians(315)) * (blockSize + (blockSize / 2));
		offsetX[3] = sin(rotation + radians(0)) * blockSize;
		offsetY[3] = cos(rotation + radians(180)) * blockSize;
		
		for (int i=0; i<4; i++) {
			blocks[i].setX(super.pivotPoint.getX() + offsetX[i]);
			blocks[i].setY(super.pivotPoint.getY() + offsetY[i]);
		}

		// rounding to line up with grid
		// TODO: better way?
		//super.round(blocks[0]);
		//super.round(blocks[1]);
		super.round(blocks[2]);
		super.round(blocks[3]);
		
	}
	
}
