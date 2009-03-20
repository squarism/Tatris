import java.util.Random;

public class PieceBag {

	Piece pieceBag[] = new Piece[7];		// a bag of 7 tetris pieces
	//int pieceBag[] = new int[7];
	int pieceBagI;
	
	float x;	// piece origin
	float y;	// piece origin
	
	public PieceBag(float x, float y) {
		this.x = x;
		this.y = y;
		initPieces();
		jumble();
		pieceBagI = 0;
	}

	void initPieces() {
		pieceBag[0] = new LPiece(this.x, this.y);
		pieceBag[1] = new SquarePiece(this.x, this.y);
		pieceBag[2] = new TPiece(this.x, this.y);
		pieceBag[3] = new SPiece(this.x, this.y);
		pieceBag[4] = new ZPiece(this.x, this.y);
		pieceBag[5] = new IPiece(this.x, this.y);
		pieceBag[6] = new JPiece(this.x, this.y);
	}
	
	//pieceBag[0] = new LPiece(playField[1].getX()/2, 32.0f);
	//pieceBag[1] = new LPiece(playField[1].getX()/2, 32.0f);
	//pieceBagI = 0;
	
	public void jumble() {
		//println("JUMBLE");
		Random rng = new Random();   // i.e., java.util.Random.
        int n = pieceBag.length;        // The number of items left to shuffle (loop invariant).
        while (n > 1) 
        {
            int k = rng.nextInt(n);  // 0 <= k < n.
            n--;                     // n is now the last pertinent index;
            Piece temp = pieceBag[n];     // swap array[n] with array[k] (does nothing if k == n).
            pieceBag[n] = pieceBag[k];
            pieceBag[k] = temp;
        }
		
	}
	
	// get piece from bag
	public Piece getPiece() {
		// if we are on piece 7 then jumble the bag again
		if (pieceBagI == pieceBag.length) {
			initPieces();			
			jumble();
			pieceBagI = 0;
		}
		
		Piece piece = pieceBag[pieceBagI];
		pieceBagI++;
		return piece;
	}
	
	public void print() {
		System.out.println("-------------");
		for (int i=0; i<pieceBag.length; i++) {
			System.out.print(pieceBag[i] + " ");
		}
		System.out.println("\n-------------");
	}
	
	/*	
	public static void main(String args[]) {
		PieceBag pg = new PieceBag();
		pg.print();
		System.out.println(pg.getPiece());
		pg.print();
		System.out.println(pg.getPiece());
		System.out.println(pg.getPiece());
		System.out.println(pg.getPiece());
		System.out.println(pg.getPiece());
		System.out.println(pg.getPiece());
		System.out.println(pg.getPiece());		
	}*/

}
