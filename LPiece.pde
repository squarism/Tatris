class LPiece extends Piece {
	
	/*
			3   #
			2*  #           
			10  ##
			
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
		/*
		super.round(blocks[1]);
		super.round(blocks[3]);
		*/
	}
			
	public void setRotation(float angle) {
		this.rotation = angle;

		float ppx = pivotPoint.getX();		
		float ppy = pivotPoint.getY();
	}
	
	// TODO: refactor cleaner
	public boolean rotateCollide(float wallStart, float wallWidth) {
		
		// are we more right?
		if (super.pivotPoint.getX() > wallWidth / 2) {
			if (super.pivotPoint.getX() + blockSize * 3 < wallWidth) {
				//println("nowhere close near east wall");
				return false;
			} else {
				float tmpRotation = rotation + 90.0f;
				float tmpOffsetX[] = new float[4];
				float tmpOffsetY[] = new float[4];
				tmpOffsetX[0] = sin(tmpRotation + radians(180)) * blockSize;
				tmpOffsetX[1] = sin(tmpRotation + radians(225)) * (blockSize + (blockSize / 2));
				tmpOffsetX[2] = sin(tmpRotation + radians(270)) * blockSize;
				tmpOffsetX[3] = sin(tmpRotation + radians(315)) * (blockSize + (blockSize / 2));

				if (super.pivotPoint.getX()+tmpOffsetX[0] >= wallWidth) {
					//println("denied 0");
					return true;
				} 
				if (super.pivotPoint.getX()+tmpOffsetX[1] >= wallWidth) {
					//println("denied 1");
					return true;
				} 
				if (super.pivotPoint.getX()+tmpOffsetX[2] >= wallWidth) {
					//println("denied 2");
					return true;
				} 
				if (super.pivotPoint.getX()+tmpOffsetX[3] >= wallWidth) {
					//println("denied 3");
					return true;
				}
				//println("allowed west");
				return false;
			}
			
		// or are we more left?
		} else {
			if (super.pivotPoint.getX() - blockSize * 2 > wallStart) {
				//println("nowhere close near west wall");
				return false;
			} else {
				float tmpRotation = rotation + 90.0f;
				float tmpOffsetX[] = new float[4];
				float tmpOffsetY[] = new float[4];
				tmpOffsetX[0] = sin(tmpRotation + radians(180)) * blockSize;
				tmpOffsetX[1] = sin(tmpRotation + radians(225)) * (blockSize + (blockSize / 2));
				tmpOffsetX[2] = sin(tmpRotation + radians(270)) * blockSize;
				tmpOffsetX[3] = sin(tmpRotation + radians(315)) * (blockSize + (blockSize / 2));
				if (super.pivotPoint.getX()+tmpOffsetX[0] < wallStart - blockSize/2) {
					//println("denied 0");
					return true;
				} 
				if (super.pivotPoint.getX()+tmpOffsetX[1] < wallStart - blockSize/2) {
					//println("denied 1");
					return true;
				} 
				if (super.pivotPoint.getX()+tmpOffsetX[2] < wallStart - blockSize/2) {
					//println("denied 2");
					return true;
				} 
				if (super.pivotPoint.getX()+tmpOffsetX[3] < wallStart - blockSize/2) {
					//println("denied 3");
					return true;
				}
				//println("allowed east");
				return false;
			}	
		}
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
		for (int ix=-2; ix <= 2; ix++) {
			for (int iy=-2; iy <= 2; iy++) {
				// TMP, mark some shit
				mx = (int)bx+ix;
				my = (int)by+iy;
				if ( mx >= 0 && mx < gridSizeX && my >= 0 && my < gridSizeY ) { 
					//deadGrid[mx][my] = new Block(mx*blockSize + playField[0].getX(), my*blockSize + playField[0].getY(), blockSize, "#AA0000");
					if (deadGrid[mx][my] != null) {
						// we are near something on the deadGrid
						nearAnything = true;
					}
				}
			}
		}
		
		
		//println("NEAR ANYTHING:" + nearAnything);
		if (nearAnything) {
			float tmpRotation = rotation + 90.0f;
			float tmpOffsetX[] = new float[4];
			float tmpOffsetY[] = new float[4];
			tmpOffsetX[0] = sin(tmpRotation + radians(180)) * blockSize;
			tmpOffsetX[1] = sin(tmpRotation + radians(225)) * (blockSize + (blockSize / 2));
			tmpOffsetX[2] = sin(tmpRotation + radians(270)) * blockSize;
			tmpOffsetX[3] = sin(tmpRotation + radians(315)) * (blockSize + (blockSize / 2));
			
			tmpOffsetY[0] = cos(tmpRotation + radians(0)) * blockSize;
			tmpOffsetY[1] = cos(tmpRotation + radians(45)) * (blockSize + (blockSize / 2));
			tmpOffsetY[2] = cos(tmpRotation + radians(90)) * blockSize;
			tmpOffsetY[3] = cos(tmpRotation + radians(135)) * (blockSize + (blockSize / 2));
			
			
			int testX;
			int testY;
			boolean hit = false;
			for (int i=0; i<4; i++) {
				testX = (int) ((super.pivotPoint.getX()+tmpOffsetX[i]) / blockSize);
				testY = (int) ((super.pivotPoint.getY()+tmpOffsetY[i]) / blockSize);
				
				if (deadGrid[testX][testY] != null) {
					hit = true;
					return true;
				}
			}
						
		}
		
		

		/*
			if (super.pivotPoint.getX() + blockSize * 3 < wallWidth) {
				//println("nowhere close near east wall");
				return false;
			} else {
				float tmpRotation = rotation + 90.0f;
				float tmpOffsetX[] = new float[4];
				float tmpOffsetY[] = new float[4];
				tmpOffsetX[0] = sin(tmpRotation + radians(180)) * blockSize;
				tmpOffsetX[1] = sin(tmpRotation + radians(225)) * (blockSize + (blockSize / 2));
				tmpOffsetX[2] = sin(tmpRotation + radians(270)) * blockSize;
				tmpOffsetX[3] = sin(tmpRotation + radians(315)) * (blockSize + (blockSize / 2));

				if (super.pivotPoint.getX()+tmpOffsetX[0] >= wallWidth) {
					//println("denied 0");
					return true;
				} 
				if (super.pivotPoint.getX()+tmpOffsetX[1] >= wallWidth) {
					//println("denied 1");
					return true;
				} 
				if (super.pivotPoint.getX()+tmpOffsetX[2] >= wallWidth) {
					//println("denied 2");
					return true;
				} 
				if (super.pivotPoint.getX()+tmpOffsetX[3] >= wallWidth) {
					//println("denied 3");
					return true;
				}
				//println("allowed west");
				return false;
			}
			
			*/
			return false;
	}
	
	/* Call this whenever moving or rotating */
	public void update() {
		
		offsetX[0] = sin(rotation + radians(180)) * blockSize;
		offsetY[0] = cos(rotation + radians(0)) * blockSize;

		// corner pieces (45deg) are tricky, have to be rounded
		// TODO: figure out math to place them just right
		offsetX[1] = sin(rotation + radians(225)) * (blockSize + (blockSize / 2));
		offsetY[1] = cos(rotation + radians(45)) * (blockSize + (blockSize / 2));

		offsetX[2] = sin(rotation + radians(270)) * blockSize;
		offsetY[2] = cos(rotation + radians(90)) * blockSize;

		// corner pieces (45deg) are tricky, have to be rounded
		// TODO: figure out math to place them just right
		offsetX[3] = sin(rotation + radians(315)) * (blockSize + (blockSize / 2));
		offsetY[3] = cos(rotation + radians(135)) * (blockSize + (blockSize / 2));
		
		blocks[0].setX(super.pivotPoint.getX() + offsetX[0]);
		blocks[0].setY(super.pivotPoint.getY() + offsetY[0]);
		
		blocks[1].setX(super.pivotPoint.getX() + offsetX[1]);
		blocks[1].setY(super.pivotPoint.getY() + offsetY[1]);

		blocks[2].setX(super.pivotPoint.getX() + offsetX[2]);
		blocks[2].setY(super.pivotPoint.getY() + offsetY[2]);

		blocks[3].setX(super.pivotPoint.getX() + offsetX[3]);
		blocks[3].setY(super.pivotPoint.getY() + offsetY[3]);

		// rounding to line up with grid
		// TODO: better way?
		super.round(blocks[0]);
		super.round(blocks[1]);
		super.round(blocks[2]);
		super.round(blocks[3]);
		
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
	
	// set x unconditionally
	public void setX(float x) {
		pivotPoint.setX(x);
	}
	
	public void setY(float y) {
		/*
		blocks[0].setY(y-blockSize*2.0f);
		blocks[1].setY(y-blockSize);
		blocks[2].setY(y);
		blocks[3].setY(y);
		*/
		pivotPoint.setY(y);
		//update();
	}
	
}