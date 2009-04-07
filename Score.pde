public class Score {
	
	int score;
	int lines;
	int lpm;
	
	final int LINEVALUE = 50;
	final int DISTANCEVALUE = 16;	// this should be set to blocksize maybe
	
	public Score() {
		this.score = 0;
		this.lines = 0;
		this.lpm = 0;
	}
	
	public void scoreLines(int lines) {
		// println("scoreLine():" + lines);
		this.lines += lines;
		switch(lines) {
			case 4: score += LINEVALUE * 1.4 * lines; break;
			case 3: score += LINEVALUE * 1.3 * lines; break;
			case 2: score += LINEVALUE * 1.2 * lines; break;
			case 1: score += LINEVALUE; break;
		}		
	}
	
	public void scoreDrop(int distance) {
		// println("scoreDrop():" + distance);
		score += (distance / DISTANCEVALUE) / 4;
	}
	
	public int getScore() {
		return score;
	}
	
	public int getLines() {
		return lines;
	}
	
	public int getLPM() {
		return lpm;
	}
	
}