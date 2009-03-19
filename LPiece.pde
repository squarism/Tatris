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
	float offset0x;
	float offset0y;
	float offset1x;
	float offset1y;
	float offset2x;
	float offset2y;
	float offset3x;
	float offset3y;

	public LPiece(float x, float y) {	
		super.setX(x);
		super.setY(y);
				
		blocks[0] = new Block(x + offset0x, y + offset0y, blockSize, "#3366CC");
		blocks[1] = new Block(x + offset1x, y + offset1y, blockSize, "#3366CC");
		blocks[2] = new Block(x + offset2x, y + offset2y, blockSize, "#3366CC");
		blocks[3] = new Block(x + offset3x, y + offset3y, blockSize, "#3366CC");

		update();

		// 45 deg pieces don't line up right
		// TODO: figure out math to get rid of this
		super.round(blocks[1]);
		super.round(blocks[3]);
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
				println("nowhere close near east wall");
				return false;
			} else {
				float tmpRotation = rotation + 90.0f;
				float tmpOffset0x = sin(tmpRotation + radians(180)) * blockSize;
				float tmpOffset1x = sin(tmpRotation + radians(225)) * (blockSize + (blockSize / 2));
				float tmpOffset2x = sin(tmpRotation + radians(270)) * blockSize;
				float tmpOffset3x = sin(tmpRotation + radians(315)) * (blockSize + (blockSize / 2));

				if (super.pivotPoint.getX()+tmpOffset0x >= wallWidth) {
					println("denied 0");
					return true;
				} 
				if (super.pivotPoint.getX()+tmpOffset1x >= wallWidth) {
					println("denied 1");
					return true;
				} 
				if (super.pivotPoint.getX()+tmpOffset2x >= wallWidth) {
					println("denied 2");
					return true;
				} 
				if (super.pivotPoint.getX()+tmpOffset3x >= wallWidth) {
					println("denied 3");
					return true;
				}
				println("allowed west");
				return false;
			}
			
		// or are we more left?
		} else {
			if (super.pivotPoint.getX() - blockSize * 2 > wallStart) {
				println("nowhere close near west wall");
				return false;
			} else {
				float tmpRotation = rotation + 90.0f;
				float tmpOffset0x = sin(tmpRotation + radians(180)) * blockSize;
				float tmpOffset1x = sin(tmpRotation + radians(225)) * (blockSize + (blockSize / 2));
				float tmpOffset2x = sin(tmpRotation + radians(270)) * blockSize;
				float tmpOffset3x = sin(tmpRotation + radians(315)) * (blockSize + (blockSize / 2));
				if (super.pivotPoint.getX()+tmpOffset0x < wallStart - blockSize/2) {
					println("denied 0");
					return true;
				} 
				if (super.pivotPoint.getX()+tmpOffset1x < wallStart - blockSize/2) {
					println("denied 1");
					return true;
				} 
				if (super.pivotPoint.getX()+tmpOffset2x < wallStart - blockSize/2) {
					println("denied 2");
					return true;
				} 
				if (super.pivotPoint.getX()+tmpOffset3x < wallStart - blockSize/2) {
					println("denied 3");
					return true;
				}
				println("allowed east");
				return false;
			}
			
		}
		
	}
	
	/* Call this whenever moving or rotating */
	public void update() {
		
		offset0x = sin(rotation + radians(180)) * blockSize;
		offset0y = cos(rotation + radians(0)) * blockSize;

		// corner pieces (45deg) are tricky, have to be rounded
		// TODO: figure out math to place them just right
		offset1x = sin(rotation + radians(225)) * (blockSize + (blockSize / 2));
		offset1y = cos(rotation + radians(45)) * (blockSize + (blockSize / 2));

		offset2x = sin(rotation + radians(270)) * blockSize;
		offset2y = cos(rotation + radians(90)) * blockSize;

		// corner pieces (45deg) are tricky, have to be rounded
		// TODO: figure out math to place them just right
		offset3x = sin(rotation + radians(315)) * (blockSize + (blockSize / 2));
		offset3y = cos(rotation + radians(135)) * (blockSize + (blockSize / 2));
		
		blocks[0].setX(super.pivotPoint.getX() + offset0x);
		blocks[0].setY(super.pivotPoint.getY() + offset0y);
		
		blocks[1].setX(super.pivotPoint.getX() + offset1x);
		blocks[1].setY(super.pivotPoint.getY() + offset1y);

		blocks[2].setX(super.pivotPoint.getX() + offset2x);
		blocks[2].setY(super.pivotPoint.getY() + offset2y);

		blocks[3].setX(super.pivotPoint.getX() + offset3x);
		blocks[3].setY(super.pivotPoint.getY() + offset3y);

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