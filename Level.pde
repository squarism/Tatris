// contains rules for game speed
public class Level {
	// set our initial level
	int level = 1;
	
	// lookup list for rules
	HashMap rules = new HashMap();
	
	public Level() {
		// create level rules that accelerate gameplay
		int j=0;
		for (float i=1.0f; i > 0.00f; i-=0.05f) {
			float t = Math.round(i * 100.0) / 100.0;
			rules.put(j++, t);
			// println("RULES: level"+j+" = speed:"+t);
		}
	}
	
	public float getTimer() {
		if (rules.containsKey(this.level)) {
			return (Float)rules.get(this.level);
		} else {
			// anything beyond max level, just stay at this speed
			return 0.05f;
		}
	}
	
	public int getLevel() {
		return this.level;
	}
	
	public void update(int lines) {
		if (lines < 5) {
			this.level = 1;
		} else if (lines < 100) {
			this.level = (lines / 5) + 1;
		} else {
			this.level = 20;
		}
	}
	
}