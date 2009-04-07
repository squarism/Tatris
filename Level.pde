// contains rules for game speed
public class Level {
	int level = 1;
	HashMap rules = new HashMap();
	
	public Level() {
		int j=0;
		for (float i=1.0f; i > 0.05f; i-=0.05f) {
			float t = Math.round(i * 100.0) / 100.0;
			rules.put(j++, t);
			println("j"+j+"i"+t);
		}
	}
	
	public float getTimer() {
		return (Float)rules.get(this.level);
	}
	
	public int getLevel() {
		return this.level;
	}
	
	public void update(int lines) {
		if (lines < 5) {
			this.level = 1;
		} else if (lines < 95) {
			this.level = (lines / 5) + 1;
		} else {
			this.level = 19;
		}
	}
	
}