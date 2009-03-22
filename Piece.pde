import java.util.ArrayList;

// blocks move together as one set of blocks, offset by shape pattern
class Piece {
	
	float x;		// center x
	float y;		// center y
	float blockSize=16.0f;	// used as offset, width and height
	float rotation=radians(0.0f);
	Block pivotPoint = new Block(x,y, blockSize, "#AAAAAA");;
	Block[] blocks = new Block[4];

	public void setRotation(float angle) {
		this.rotation = angle;
	}
	
	public void draw() {
		for (int i=0; i < 4; i++) {
			blocks[i].draw(x,y);
		}
		//pivotPoint.draw(x,y);

	}
	
	public float getRotation() {
		return rotation;
	}
	
	public void setX(float x) {
		pivotPoint.setX(x);
	}
	
	/*
	public void setX(float x, float wall) {
		pivotPoint.setX(x);
	}*/
	
	public void setY(float y) {
		pivotPoint.setY(y);
	}
	
	public float getX() {
		return pivotPoint.getX();
	}
	
	public float getY() {
		return pivotPoint.getY();
	}
	
	public void round(Block block) {
		// TODO: uncomment and refactor this
		/*
		for (int i=0; i < blocks.length; i++) {
			println("rounding" + i);
			blocks[i].setX(Math.round(blocks[i].getX() / blockSize) * blockSize);
			blocks[i].setY(Math.round(blocks[i].getY() / blockSize) * blockSize);
		}*/
		// rounding to line up with grid
		//println("before round x:" + block.getX() + " y:" + block.getY());
		block.setX(Math.round(block.getX() / blockSize) * blockSize);
		block.setY(Math.round(block.getY() / blockSize) * blockSize);
		//println("after round x:" + block.getX() + " y:" + block.getY());
	}
	
	public void update() {
		
	}
	
	public boolean rotateCollideX(float wallStart, float wallWidth) {
		return false;
	}
	
	public boolean rotateCollideY(float roomStart, float roomWidth) {
		return false;
	}
	
	public boolean rotateCollide(Block deadGrid[][], Point2d playField[]) {
		return false;
	}
	
	public Block[] getBlocks() {
		return blocks;
	}
	
	// absolute
	public float getMaxX() {
		float greatest = 0;
		for (int i=0; i<4; i++) {
			if (blocks[i].getX() > greatest) {
				greatest = blocks[i].getX() + x;
			}
		}
		return greatest;
	}

	public float getMaxY() {
		float greatest = 0;
		for (int i=0; i<4; i++) {
			if (blocks[i].getY() > greatest) {
				greatest = blocks[i].getY() + y;
			}
		}
		return greatest;	
	}

	// this is used when dropping pieces
	public Block[] getMaxYBlocks() {
		HashMap map = new HashMap();
		
		for (int i=0; i<blocks.length; i++) {
			Block test = (Block)map.get(blocks[i].getX());
			
			if(test != null) {
				if (blocks[i].getY() > test.getY()){
 					map.put(blocks[i].getX(), blocks[i]);					
				}
			} else {
				map.put(blocks[i].getX(), blocks[i]);					
			}

		}

		Block returnBlocks[] = new Block[map.size()];
		int i = 0;

		Set mapset= map.keySet();
		Iterator iter = mapset.iterator();
		while(iter.hasNext()){
			Float currentKey = (Float)iter.next();
			returnBlocks[i++] = (Block)map.get(currentKey);
		}

		return returnBlocks;	
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
	
		
}