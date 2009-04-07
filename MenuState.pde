public class MenuState implements GameState {
	// 	All this only works for one submenu deep.  Nested submenus requires more code.
	
	boolean inMenu = true;
	GameState nextState;
	int fontSize = 48;
	String[] mainMenu = {"New Game", "Key Setup", "Sound: ", "Music: ", "FPS Display: "};
	String[] keyMenu = {"Left", "Right", "Down One", "Rotate", "Drop"};
	String[] currentMenu = mainMenu;

	int focusY = 0;	// item user is on
	
	boolean waitingForKey=false;	// are we waiting for a keypress?
	int gotKey;
	boolean isNewGame;				// are we in the menu after a lost game?
	
	boolean keyUp = false;
	boolean keyDown = false;
	boolean keyRight = false;
	boolean keyLeft = false;
	boolean keyEsc = false;
	boolean keyEnter = false;
	
	PGraphics gameScreen;	// image to blur for background
	
	public void update(float elapsed) {
		
		if (!waitingForKey) {
		
			if (keyDown) {
				keyDown = false;
				if (focusY < currentMenu.length - 1) {
					focusY++;
				}
			}
		
			if (keyUp) {
				keyUp = false;
				if (focusY > 0) {
					focusY--;
				}
			}
		
			if (keyRight || keyEnter) {
				//println(focusX);
				keyRight = false;
				keyEnter = false;
				
				if (currentMenu == mainMenu) {
					switch(focusY) {
						case 0: println("new game"); nextState = new PlayState(); inMenu = false; break;
						case 1: currentMenu = keyMenu; focusY = 0; break;
						case 2: soundEnabled = !soundEnabled; break;
						case 3: musicEnabled = !musicEnabled; break;
						case 4: fpsEnabled = !fpsEnabled; break;
					}
				} else if (currentMenu == keyMenu) {
					waitingForKey = true;
					/*
					switch(focusY) {
						case 0: println("left"); break;
						case 1: println("right"); break;
						case 2: println("down one"); break;
						case 3: println("rotate"); break;
						case 4: println("drop"); break;
					}*/
				}
			}
		}
		
		if (waitingForKey == true && gotKey != 0) {
			println("GOT KEY:" + gotKey);
			switch(focusY) {
				case 0: println("setting left to:" + gotKey); controlLeft=gotKey; break;
				case 1: println("setting right to:" + gotKey); controlRight=gotKey; break;
				case 2: println("setting DOWN ONE to:" + gotKey); controlDown=gotKey; break;
				case 3: println("setting ROTATE to:" + gotKey); controlRotate=gotKey; break;
				case 4: println("setting DROP to:" + gotKey); controlDrop=gotKey; break;
			}

			waitingForKey = false;
			gotKey = 0;
		}
		
		
		if (keyEsc) {
			keyEsc = false;
			waitingForKey = false;
			if (currentMenu != mainMenu) {
				currentMenu = mainMenu;
				focusY = 0;
			} else {
				if (!isNewGame) {
					inMenu = false;
				}
			}
		}

	}
	
	public void paint() {
		background(0);
		//if (!isNewGame)	
		image(gameScreen, 0, 0 );
		fill(255,255,255);
		//textFont(crackedFont, fontSize);
		textFont(visitorFont, fontSize);
		textCentered("MENU TIME", fontSize, 255, 0);
		fill(255,255,255);
		
		stroke(255);
		fill(20,20,20,220);
		//rectMode(CENTER);
		//println("W:" + width + "Y:" +  (144 + (focusY*48)) + "T:" + textWidth(mainMenu[focusY]) );
		strokeWeight(2);
		rect(width/2 - (textWidth(currentMenu[focusY]) / 2) - 50, 144 + (focusY*fontSize) - (fontSize/2) - 2, textWidth(currentMenu[focusY])+100, fontSize - 16);

		if (waitingForKey) {
			textFont(visitorFont, fontSize/2);
			fill(255,20,20);
			textCentered("Press a key", fontSize*2, 255, 0);
		}


		textFont(visitorFont,fontSize - 16);
		fill(255);
		for (int i=0; i < currentMenu.length; i++) {
			String menuItem = currentMenu[i];
			// check for boolean game options
			if (currentMenu == mainMenu) {
				// sound
				if (i == 2) {
					menuItem = soundEnabled ? menuItem + "On" : menuItem + "Off";
				}
				
				// music
				if (i == 3) {
					menuItem = musicEnabled ? menuItem + "On" : menuItem + "Off";
				}

				// fps
				if (i == 4) {
					menuItem = fpsEnabled ? menuItem + "On" : menuItem + "Off";
				}
			}
			
			if (currentMenu == keyMenu) {
				
				switch(i) {
					case 0: menuItem = menuItem + ": " + getKeyText(controlLeft); break;
					case 1: menuItem = menuItem + ": " + getKeyText(controlRight); break;
					case 2: menuItem = menuItem + ": " + getKeyText(controlDown); break;
					case 3: menuItem = menuItem + ": " + getKeyText(controlRotate); break;
					case 4: menuItem = menuItem + ": " + getKeyText(controlDrop); break;
				}
				
				/*
				if (i == 0) {
					//println("key menu:" + controlLeft);
					//menuItem = menuItem + ":" + controlLeft;
					menuItem = menuItem + ":" + java.awt.event.KeyEvent.getKeyText(controlLeft);
				}*/
			}
			textCentered(menuItem, 144 + (i * fontSize), 255, 0);
		}


		
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
	
	public void setScreenshot(GameState nextState) {
		PImage shot = nextState.shot();
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
	
	public void setNewGame(boolean flag) {
		this.isNewGame = true;
	}
	
	public void keyPressed() {
		
		//println(keyCode);
		
		if (keyCode == ESC) {
			//inMenu = false;
			keyEsc = true;
			key = 0;  // Fools! don't let them escape!
		}
		
		
		if (waitingForKey == true) {
			gotKey = keyCode;
		} else {
			if (keyCode == UP) keyUp = true;
			if (keyCode == DOWN) keyDown = true;
			if (keyCode == LEFT) keyLeft = true;
			if (keyCode == RIGHT) keyRight = true;
			if (keyCode == ENTER) keyEnter = true;
		}

	}
	public void keyReleased() {

	}
}

