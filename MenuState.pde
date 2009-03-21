public class MenuState implements GameState {
	
	boolean inMenu = true;
	GameState nextState;
	
	public void update(float elapsed) {

	}
	public void paint() {
		background(0);
		fill(255,255,255);
		textFont(crackedFont,48);
		background(0);
		textCentered("MENU TIME", height/4, 255, 0);
		fill(255,255,255);
		//textFont(regFont,12);
		//textCentered(":(", height/4+24,255, 0);	
	}
	public GameState nextState() {
		if (inMenu == false) {
			return nextState;
		} else {
			return this;
		}
	}
	
	public void setNextState(GameState nextState) {
		this.nextState = nextState;
	}
	
	public void keyPressed() {
		if (keyCode == ESC) {
			inMenu = false;
			key = 0;  // Fools! don't let them escape!
		}

	}
	public void keyReleased() {

	}
}

