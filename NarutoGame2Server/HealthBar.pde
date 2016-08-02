class HealthBar extends Being {
  final static int   HEALTH_BAR_WIDTH = 250;
  
  Player owner;
  int x, y;
  
  HealthBar(Player owner, int x, int y){
    super(new HRectangle(new PVector((float)(x), (float)(y), 0), x, y));
    this.owner = owner;
    this.x = x;
    this.y = y;
    
  }
  
  // the HRectangle defining the sector at this position
  HRectangle rectOfHealth(int x, int y) {
    return new HRectangle(new PVector((float)(x), (float)(y), 0), x, y);
  }
  
  void draw() {
  
    if (owner.getHealth() < 25)
    {  
      fill(255, 0, 0);
    }    
    else if (owner.getHealth() < 50)
    {  
      fill(255, 200, 0);
    }  
    else
    {  
      fill(0, 255, 0);
    }
    // Draw bar
    noStroke();
    // Get fraction 0->1 and multiply it by width of bar
    float drawWidth = (owner.getHealth() / owner.MAX_HEALTH) * HEALTH_BAR_WIDTH;
    rect(x, y, drawWidth, 25);  
     
    // Outline
    stroke(0);
    noFill();  
    rect(x, y, HEALTH_BAR_WIDTH, 25);
    
    println(player.getPosition().x);
    println(player.getPosition().y);
  }
  
  
}
