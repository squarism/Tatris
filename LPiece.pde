class LPiece extends Piece {
	
	/*
			3   #
			2x  #           
			10  ##
			
			3366CC (blue)
	*/

	public LPiece(float x, float y) {
		
		super.setX(x);
		super.setY(y);
			
		// Rotating a point A around point B by angle C
		// A.x' = (A.x-B.x) * cos(C) - (A.y-B.y) * sin(C) + B.x
		// A.y' = (A.y-B.y) * cos(C) + (A.x-B.x) * sin(C) + B.y

		blocks[0] = new Block(x+(sin(rotation+radians(180))*blockSize),y+(cos(rotation+radians(0))*blockSize),blockSize,"#3366CC");

		blocks[1] = new Block(x+(sin(rotation+radians(225))*(blockSize+(blockSize/2))),y+(cos(rotation+radians(45))*(blockSize+(blockSize/2))),blockSize,"#3366CC");
		super.round(blocks[1]);

		blocks[2] = new Block(x+(sin(rotation+radians(270))*blockSize),y+(cos(rotation+radians(90))*blockSize),blockSize,"#3366CC");
		blocks[3] = new Block(x+(sin(rotation+radians(315))*(blockSize+(blockSize/2))),y+(cos(rotation+radians(135))*(blockSize+(blockSize/2))),blockSize,"#3366CC");
		super.round(blocks[3]);

		//blocks[3] = new Block(x+(cos(rotation)*blockSize),y,blockSize,"#336611");
		
		
		/*
		blocks[0] = new Block(0,0-blockSize*2.0f,blockSize,"#3366CC");
		blocks[1] = new Block(0,0-blockSize,blockSize,"#3366CC");
		blocks[2] = new Block(0,0,blockSize,"#4477DD");
		blocks[3] = new Block(0+blockSize,0,blockSize,"#3366CC");
		*/
		
	}
	
	public void setRotation(float angle) {
		this.rotation = angle;

		float ppx = pivotPoint.getX();		
		float ppy = pivotPoint.getY();
		
		update();

		
		/*
		for (int i=0; i < 4; i++) {
			float x = blocks[i].getX();
			float y = blocks[i].getY();

			// Rotating a point A around point B by angle C
			// A.x' = (A.x-B.x) * cos(C) - (A.y-B.y) * sin(C) + B.x
			// A.y' = (A.y-B.y) * cos(C) + (A.x-B.x) * sin(C) + B.y
			blocks[i].setX((x - ppx * cos(rads) - (y - ppy) * sin(rads) + ppx));
			blocks[i].setY((y - ppy * cos(rads) + (x - ppx) * sin(rads) + y));

		}*/
		



			//x = pivotX + nx;
			//y = pivotY + ny;

			//println("x:" + x + " y:" + y + " nx:" + nx + " ny:" + ny + " pivotX:" + pivotX + " pivotY:" + pivotY);
		
		
	}
	
	void update() {
		blocks[0].setX(super.pivotPoint.getX()+(sin(rotation+radians(180))*blockSize));
		blocks[0].setY(super.pivotPoint.getY()+(cos(rotation+radians(0))*blockSize));
		
		blocks[1].setX(super.pivotPoint.getX()+(sin(rotation+radians(225))*(blockSize+(blockSize/2))));
		blocks[1].setY(super.pivotPoint.getY()+(cos(rotation+radians(45))*(blockSize+(blockSize/2))));

		// rounding to line up with grid
		super.round(blocks[1]);

		blocks[2].setX(super.pivotPoint.getX()+(sin(rotation+radians(270))*blockSize));
		blocks[2].setY(super.pivotPoint.getY()+(cos(rotation+radians(90))*blockSize));

		blocks[3].setX(super.pivotPoint.getX()+(sin(rotation+radians(315))*(blockSize+(blockSize/2))));
		blocks[3].setY(super.pivotPoint.getY()+(cos(rotation+radians(135))*(blockSize+(blockSize/2))));
		super.round(blocks[3]);
		
	}
	

	
	// blocks move together as one set of blocks, offset by shape pattern
	public void setX(float x) {
		/*
		blocks[0].setX(x);
		blocks[1].setX(x);
		blocks[2].setX(x);
		blocks[3].setX(x+blockSize);
		*/
		
		boolean wallCollide = false;
		
		float xVector = 0;
		xVector = x-pivotPoint.getX();

		/*
		} else if (pivotPoint - x > 0) { 
			moveDifference = pivotPoint - x;
		} else {
			moveDifference = 0;
		}*/
		
		
		
		for (int i=0; i < 4; i++) {
			if (blocks[i].getX() + xVector >= width) {
				wallCollide = true;
			}
			if (blocks[i].getX() + xVector < 0) {
				wallCollide = true;
			}
		}
		if (!wallCollide){
				pivotPoint.setX(x);
				update();
			}
	}
	
	public void setY(float y) {
		/*
		blocks[0].setY(y-blockSize*2.0f);
		blocks[1].setY(y-blockSize);
		blocks[2].setY(y);
		blocks[3].setY(y);
		*/
		pivotPoint.setY(y);
		update();
	}
	
}