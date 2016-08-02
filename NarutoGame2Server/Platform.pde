/**
 * Represents the stationary platforms in the game
 */
class Platform extends MassedBeing {
 
  static final float HEIGHT = 50.0f;              // the platform's height
  final color COLOR = color(125,125,125);  // the platform's color
//  PImage groundTexture = loadImage("ground_grass.png");  // Texturing requires P2D.

  float width;   // width of this platform

  /**
   * makes a Platform with given center and width
   */
  Platform(PVector center, float width) {
    super(new HRectangle(center, width, HEIGHT), HermesMath.zeroVector(), 0.05f, 0);
//    super(new HRectangle(center, width, HEIGHT), HermesMath.zeroVector(), HermesMath.INFINITY, 1);    
    
    this.width = width;
  }
 
  void draw() {
    fill(COLOR);
    rect(0, 0, width, HEIGHT);
    
    

// REQUIRES P2D size setup to texture the ground.
//    beginShape();
//    texture(groundTexture);
//    vertex(0, 0, 0, 0);
//    vertex(groundTexture.width, 0, groundTexture.width, 0);
//    vertex(groundTexture.width, 390, groundTexture.width, 390);
//    vertex(0, 390, 0, 390);
//    endShape();

    
    
  }
 
}
