import java.util.ArrayList;

class Piece {
	
	float x;		// center x
	float y;		// center y
	float blockSize=24.0f;	// used as offset, width and height
	
	ArrayList blocks = new ArrayList();
	
	String type;

    /* Piece Types

	                 	 #                     #
	##                 	 #                     ##
	## 990000  (red)  	 #                      #  FFCC00  (yellow)
                       	 # FF6600   (orange)
  
      #                   #  3366CC (blue)     #
     ##                   #                    #
     #   336633 (green)   ##                  ##   663300 (brown)

	 #
	###  330033 (purple)

	*/
	
	public Piece(float x, float y, String type) {
		
		this.type = type;

		if (type.equals("square")) {
			blocks.add(new Block(x,y-blockSize,blockSize,"#990000"));
			blocks.add(new Block(x,y,blockSize,"#990000"));
			blocks.add(new Block(x+blockSize,y,blockSize,"#990000"));
			blocks.add(new Block(x+blockSize,y-blockSize,blockSize,"#990000"));			
		}
		
		if (type.equals("s")) {
			blocks.add(new Block(x,y-blockSize,blockSize,"#FFCC00"));
			blocks.add(new Block(x,y,blockSize,"#FFCC00"));
			blocks.add(new Block(x+blockSize,y,blockSize,"#FFCC00"));
			blocks.add(new Block(x+blockSize,y+blockSize,blockSize,"#FFCC00"));			
		}
		
		if (type.equals("z")) {
			blocks.add(new Block(x+blockSize,y-blockSize,blockSize,"#336633"));
			blocks.add(new Block(x,y,blockSize,"#336633"));
			blocks.add(new Block(x+blockSize,y,blockSize,"#336633"));
			blocks.add(new Block(x,y+blockSize,blockSize,"#336633"));			
		}
		
		if (type.equals("l")) {
			blocks.add(new Block(x,y-blockSize*2.0f,blockSize,"#3366CC"));
			blocks.add(new Block(x,y-blockSize,blockSize,"#3366CC"));
			blocks.add(new Block(x,y,blockSize,"#3366CC"));
			blocks.add(new Block(x+blockSize,y,blockSize,"#3366CC"));
		}
		
		if (type.equals("revl")) {
			blocks.add(new Block(x,y-blockSize*2.0f,blockSize,"#663300"));
			blocks.add(new Block(x,y-blockSize,blockSize,"#663300"));
			blocks.add(new Block(x,y,blockSize,"#663300"));
			blocks.add(new Block(x-blockSize,y,blockSize,"#663300"));		
		}
		
		if (type.equals("line")) {
			blocks.add(new Block(x,y-blockSize*2.0f,blockSize,"#FF6600"));
			blocks.add(new Block(x,y-blockSize,blockSize,"#FF6600"));
			blocks.add(new Block(x,y,blockSize,"#FF6600"));
			blocks.add(new Block(x,y+blockSize,blockSize,"#FF6600"));
		}
		
		if (type.equals("t")) {
			blocks.add(new Block(x,y-blockSize,blockSize,"#330033"));
			blocks.add(new Block(x,y,blockSize,"#330033"));
			blocks.add(new Block(x+blockSize,y,blockSize,"#330033"));
			blocks.add(new Block(x-blockSize,y,blockSize,"#330033"));			
		}
		
	}
	
	public void draw() {
		for (int i=0; i < blocks.size(); i++) {
			((Block)blocks.get(i)).draw();
		}
	}
	
	public void setX(float x) {
		for (int i=0; i < blocks.size(); i++) {
			((Block)blocks.get(i)).setX(x);
		}
	}
	
	public void setX(float x) {
		for (int i=0; i < blocks.size(); i++) {
			((Block)blocks.get(i)).setX(x);
		}
	}

}