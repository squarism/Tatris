class ZPiece extends Piece {
	
	/*	
	  		 #                
	 		##                
	 		#   
			336633 (green)
	*/
	
	public ZPiece(float x, float y) {
		blocks[0] = new Block(x,y,blockSize,"#447744");
		blocks[1] = new Block(x+blockSize,y,blockSize,"#336633");
		blocks[2] = new Block(x+blockSize,y-blockSize,blockSize,"#336633");
		blocks[3] = new Block(x,y+blockSize,blockSize,"#336633");
	}
	
	
	// blocks move together as one set of blocks, offset by shape pattern
	public void setX(float x) {
		blocks[0].setX(x);
		blocks[1].setX(x+blockSize);
		blocks[2].setX(x);
		blocks[3].setX(x);
	}
	
	public void setY(float y) {
		blocks[0].setY(y);
		blocks[1].setY(y);
		blocks[2].setY(y-blockSize);
		blocks[3].setY(y+blockSize);
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