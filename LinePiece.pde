class LinePiece extends Piece {
	
	/*
			 #                  
			 #                  
			 #                  
			 #
			 FF6600   (orange)	
	*/
		
	public LinePiece(float x, float y) {
		blocks[0] = new Block(x,y-blockSize*2.0f,blockSize,"#FF6600");
		blocks[1] = new Block(x,y-blockSize,blockSize,"#FF6600");
		blocks[2] = new Block(x,y,blockSize,"#FF7711");
		blocks[3] = new Block(x,y+blockSize,blockSize,"#FF6600");
	}
	
	
	// blocks move together as one set of blocks, offset by shape pattern
	public void setX(float x) {
		blocks[0].setX(x);
		blocks[1].setX(x);
		blocks[2].setX(x);
		blocks[3].setX(x+blockSize);
	}
	
	public void setY(float y) {
		blocks[0].setY(y-blockSize*2.0f);
		blocks[1].setY(y-blockSize);
		blocks[2].setY(y);
		blocks[3].setY(y);
	}
	
	// return arbitrary block as center of piece
	public float getX() {
		return blocks[2].getX();
	}

	// return arbitrary block as center of piece
	public float getY() {
		return blocks[2].getY();
	}

}