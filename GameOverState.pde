public class GameOverState implements GameState {
	public void update(float elapsed) {

	}
	public void paint() {
		background(0);
		fill(255,0,0);
		textFont(crackedFont,48);
		background(0);
		textCentered("GAME OVER", height/4, 255, 0);
		fill(255,255,255);
		textFont(regFont,12);
		textCentered(":(", height/4+24,255, 0);	
	}
	public GameState nextState() {
		return this;
	}
	public void keyPressed() {

	}
	public void keyReleased() {

	}
}

