public class Point2d {
	
	float x;
	float y;
	
	public Point2d(float x, float y) {
		this.x = x;
		this.y = y;
	}
	
	public Point2d(int x, int y) {
		Integer tx = new Integer(x);
		Integer ty = new Integer(y);
		this.x = tx.floatValue();
		this.y = ty.floatValue();
	}
	
	public float getX() {
		return x;
	}
	
	public float getY() {
		return y;
	}
	
	public void setX(float f) {
		this.x = f;
	}
	
	public void setY(float f) {
		this.y = f;
	}
}