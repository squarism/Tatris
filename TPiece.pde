class TPiece extends Piece {
		
	/*
 		 	 #
			###
			441144 (purple)
	*/
		
	public TPiece(float x, float y) {
		blocks[0] = new Block(x,y,blockSize,"#552255");
		blocks[1] = new Block(x-blockSize,y,blockSize,"#441144");
		blocks[2] = new Block(x+blockSize,y,blockSize,"#441144");
		blocks[3] = new Block(x,y-blockSize,blockSize,"#441144");
	}
	
	
	// blocks move together as one set of blocks, offset by shape pattern
	public void setX(float x) {
		blocks[0].setX(x);
		blocks[1].setX(x);
		blocks[2].setX(x+blockSize);
		blocks[3].setX(x+blockSize);
	}
	
	public void setY(float y) {
		blocks[0].setY(y);
		blocks[1].setY(y-blockSize);
		blocks[2].setY(y);
		blocks[3].setY(y-blockSize);
	}
	
	// return arbitrary block as center of piece
	public float getX() {
		return blocks[0].getX();
	}

	// return arbitrary block as center of piece
	public float getY() {
		return blocks[0].getY();
	}

}