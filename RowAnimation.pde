// Thread Class // 

public class RowAnimation extends Animation implements Runnable { 
  Thread thread; 

  	//int pauseTime;  // Time to wait between loops 
  	float level;
	float levelBase;

	float x;
	float y;
	float w;
	float h;
	float size;

	int id;
	
	float drawX;
	float drawY;
	float drawH;
	float drawW;
	
	float elapsed;

	public RowAnimation(PApplet parent, int x, int y, int w, int h, int id) { 
		parent.registerDispose(this);
		//println("row animation constructor");

		this.level = 150;
		this.levelBase = this.level;
		this.done = false;
		this.id = id;

		this.h = h;
		this.w = w;
		//this.size = 32;		// this is the size
		this.x = x;
		this.y = y;
	} 

	// draw does not contain the elapsed because it's not the update really
	// store it for run()
	public void draw() 
	{
		//println("row animation draw()");
		
		fill(255, 255, 255, (level/levelBase)*255);
		//drawX = x + 255 / level;
		drawX = x;
		drawY = y - ((h / 2) * ((level-levelBase)/levelBase));
		//drawW = w - level / 255;
		drawW = w;
		drawH = h * (level / levelBase);
		rect(drawX, drawY, drawW, drawH);
		//fill(255,125,0, level);
		//text(level, drawX, drawY + drawH + h / 2);
	}
	
	public void update(float elapsed) {
		//println("update() elapsed:" + elapsed + " level:" + level);
		this.elapsed = elapsed;
	}

	public void start() 
	{ 
		thread = new Thread(this);
		//boomCreated();
		thread.start();
		super.started = true;
	} 

	public void run() 
	{ 
	    // do something threaded here 
	    while(this.level > 1) { 
			// level-- plus a little extra for lost time between draws
			this.level = this.level - 1 - this.elapsed;
			try 
			{
				// add random waiting to make each boom different
		      	Thread.sleep( (int)random(1, 10) ); 
			} catch(InterruptedException e)
			{
				// do nothing, to the horror of good coding
			} 
	    }
	
		// while loop finished, level is 0
		super.done = true;
	    //boomDestroyed(id);
	}

	public void stop() 
	{ 
		thread = null; 
	} 

	// this will magically be called by the parent once the user hits stop  
	// this functionality hasn't been tested heavily so if it doesn't work, file a bug  
	public void dispose() { 
		stop(); 
	} 
}

