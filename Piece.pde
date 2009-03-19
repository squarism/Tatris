import java.util.ArrayList;

class Piece {
	
	float x;		// center x
	float y;		// center y
	float blockSize=16.0f;	// used as offset, width and height
	float rotation=radians(0.0f);
	Block pivotPoint = new Block(x,y, blockSize, "#AAAAAA");;
	
	Block[] blocks = new Block[4];
	
	public void setRotation(float angle) {
		
	}
	
	public void draw() {
		for (int i=0; i < 4; i++) {
			blocks[i].draw(x,y);
		}
		pivotPoint.draw(x,y);	
	}
	
	public float getRotation() {
		return rotation;
	}
	
	public void setX(float x) {
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
	
	
}