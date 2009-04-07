public interface GameState {
	public void update(float elapsed);
	public void paint();
	public GameState nextState();
	public void keyPressed();
	public void keyReleased();
	public PImage shot();
}

