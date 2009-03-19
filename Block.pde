class Block {
	
	float x;		// center x
	float y;		// center y
	float height;	
	float width;
	int[] fillColor = new int[2];	// color in hex
	
	public Block(float x, float y, float size, String fillColor) {
		this.x = x;
		this.y = y;
		this.fillColor = hex2rgb(fillColor);
		this.height = size;
		this.width = size;
	}
	
	public void draw() {
		fill(fillColor[0], fillColor[1], fillColor[2]);
		rect(x,y,height,width);
	}

	int[] hex2rgb(String hex) {
		int red = hexValue(hex.charAt(1))*16 + hexValue(hex.charAt(2));
		int green = hexValue(hex.charAt(3))*16 + hexValue(hex.charAt(4));
		int blue = hexValue(hex.charAt(5))*16 + hexValue(hex.charAt(6));
		
		return new int[]{red,green,blue};
	}
	
	int hexValue(char c) {
	          switch (c) {
	             case '0':
	                return 0;
	             case '1':
	                return 1;
	             case '2':
	                return 2;
	             case '3':
	                return 3;
	             case '4':
	                return 4;
	             case '5':
	                return 5;
	             case '6':
	                return 6;
	             case '7':
	                return 7;
	             case '8':
	                return 8;
	             case '9':
	                return 9;
	             case 'a':
	             case 'A':
	                return 10;
	             case 'b':
	             case 'B':
	                return 11;
	             case 'c':
	             case 'C':
	                return 12;
	             case 'd':
	             case 'D':
	                return 13;
	             case 'e':
	             case 'E':
	                return 14;
	             case 'f':
	             case 'F':
	                return 15;
	             default:
	                return -1;
				}
	}
	
}