import java.util.ArrayList;

// blocks move together as one set of blocks, offset by shape pattern
class Piece implements Cloneable {
	
	float x;		// center x
	float y;		// center y
	float blockSize=16.0f;	// used as offset, width and height
	float rotation=radians(0.0f);
	Block pivotPoint = new Block(x,y, blockSize, "#AAAAAA");;
	Block[] blocks = new Block[4];

	public void setRotation(float angle) {
		
	}
	
	public Object clone() {  
		try {  
			return super.clone();  
		} catch (Exception e) {  
			return null;  
		}  	
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
	
	public void setX(float x, float wall) {
		pivotPoint.setX(x);
	}
	
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
		// rounding to line up with grid
		block.setX(Math.round(block.getX() / blockSize) * blockSize);
		block.setY(Math.round(block.getY() / blockSize) * blockSize);
	}
	
	public void update() {
		
	}
	
	public boolean rotateCollide(float wallStart, float wallWidth) {
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

	
	
}