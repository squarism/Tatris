public class GameOverState implements GameState {
	
	boolean inMenu = false;
	PGraphics gameScreen;
	
	public void update(float elapsed) {

	}
	public void paint() {
		background(0);
		image(gameScreen,0,0);
		fill(255,0,0);
		textFont(crackedFont,48);
		textCentered("GAME OVER", height/4, 255, 0);
		fill(255,255,255);
		textFont(regFont,12);
		textCentered(":(", height/4+24,255, 0);	
	}
	public GameState nextState() {
		if (inMenu) {
			MenuState menuState = new MenuState();
			menuState.setScreenshot(this);
			menuState.setNewGame(true);
			return menuState;
		} else {
			return this;
		}
	}
	
	public void setScreenshot(GameState nextState) {
		PImage shot = ((PlayState)nextState).shot();
		gameScreen = createGraphics(width, height, P2D);
		gameScreen.beginDraw();
		gameScreen.tint(#FFFFFF, 40);	// darken a bit
		gameScreen.image(shot, 0, 0);	// our screenshot of play state
		gameScreen.filter(BLUR, 1);		// now blur
		gameScreen.endDraw();
	}
	
	public PImage shot() {
		return get();
	}
	
	// if they press any key
	public void keyPressed() {
		//if (keyCode == ESC) {
			inMenu = true;
		//	key = 0;  // Fools! don't let them escape!
		//}
		if (keyCode == ESC) {
			key = 0;
		}
	}
	public void keyReleased() {

	}
}

