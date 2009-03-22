class OPiece extends Piece {
		
	/*
		## 01             
	    ## 23 
		990000  (red)
	*/

	float offsetX[] = new float[4];
	float offsetY[] = new float[4];

		
	public OPiece(float x, float y) {

	// offsets are relative to pivotpoint (center)
	// block numbers are in ASCII art at top
	// * is pivot point	


		super.setX(x);
		super.setY(y);
				
		blocks[0] = new Block(x + offsetX[0], y + offsetY[0], blockSize, "#AA1111");
		blocks[1] = new Block(x + offsetX[1], y + offsetY[1], blockSize, "#AA1111");
		blocks[2] = new Block(x + offsetX[2], y + offsetY[2], blockSize, "#AA1111");
		blocks[3] = new Block(x + offsetX[3], y + offsetY[3], blockSize, "#AA1111");

                // call update because our offsets aren't set yet in constructor above
		update();
	}

			
	public void setRotation(float angle) {
        // override and do nothing, square doesn't rotate
	}
	
	/*
	// TODO: refactor cleaner
	public boolean rotateCollideX(int wallStart, int wallWidth) {
                // square doesn't rotate        
  		return false;
	}
	
	public boolean rotateCollideY(int roomStart, int roomWidth) {
                // square doesn't rotate        
  		return false;
	}
	
	public boolean rotateCollide(Block deadGrid[][], Point2d playField[]) {
                // square doesn't rotate
  		return false;
	}*/
	
	
	/* Call this whenever moving or rotating */
	public void update() {

        offsetX[0] = 0;
        offsetY[0] = 0;
                
        offsetX[1] = sin(rotation + radians(90)) * blockSize;
		offsetY[1] = cos(rotation + radians(270)) * blockSize;
  
  		offsetX[2] = sin(rotation + radians(180)) * blockSize;
		offsetY[2] = cos(rotation + radians(0)) * blockSize;

  		offsetX[3] = sin(rotation + radians(135)) * blockSize;
		offsetY[3] = cos(rotation + radians(315)) * blockSize;
		
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
	
}
