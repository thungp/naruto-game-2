/**
 * Represents the player
 */
class Rasengan extends MassedBeing {
  
  public final static float RASENGAN_WIDTH = 16;
  public final static float RASENGAN_HEIGHT = 36;
  final static float RASENGAN_SPEED = 150;
  final static int RASENGAN_LIFE = 3; // controls how many seconds Rasengan should stay alive before dissipating.
  
  SpriteFrame sprite01;

  
  
  // constants used to indicate the direction the Rasengan is traveling
  final static int FACING_LEFT = 1;
  final static int FACING_RIGHT = 2;
  
  // contant used to indicate player 1 or Player 2's Rasengan
  public final static int PLAYER_1 = 1;
  public final static int PLAYER_2 = 2;
  
  
  int direction = FACING_RIGHT; // the direction the Rasengan is traveling 
  
  int rasenganLife = RASENGAN_LIFE ; // in seconds
  
  AnimatedSprite sprite;
  int animIndex;
  
  int playerNum;
  
  Rasengan(float x, float y, int player) {
    super(new HRectangle(HermesMath.makeVector(x, y), RASENGAN_WIDTH, RASENGAN_HEIGHT), HermesMath.zeroVector(), 1.0f, 1.0f);
    playerNum = player;
    
    // load the animated character walk cycle
    sprite = new AnimatedSprite();
    Animation anim = null;
    if(playerNum == PLAYER_1) {
      animIndex = sprite.addAnimation(getRasenganLaunchAnimation());
    } else {
      animIndex = sprite.addAnimation(getWalkAnimation());
    }
    sprite.setActiveAnimation(animIndex);
    sprite.unpause();
  }
  
  Animation getRasenganLaunchAnimation(){
    sprite01  = new SpriteFrame("Naruto_04.png");
    java.util.ArrayList narutoWalkArrayList = sprite01.getFrameStripByRectangle(0, 4150, 500, 4220, 7);
    Animation walkAnim = new Animation(narutoWalkArrayList, 200);
    return walkAnim;
  }
  
  Animation getWalkAnimation(){
    sprite01  = new SpriteFrame("Deidara_Sprites_Look_Right.png");
    java.util.ArrayList walkArrayList = sprite01.getFrameStripByRectangle(2, 895, 398, 965, 6);
    Animation walkAnim = new Animation(walkArrayList, 200);
    return walkAnim;
  }
  
  void draw() {
    
    if(playerNum == PLAYER_1) {
      scale(1.0); // original. 0.2, if you make it .9, needto translate -70, to alight character to platform
                  // for nartuo make 2.0, make translate -20, on y, 
      imageMode(CENTER);
      translate(0,-20);
      // if the character is facing left, invert the image
      if(direction == FACING_LEFT) {
        scale(-1,1);  // I like how they use scale to revers direction.
        translate(0, 0); // the 20 translate to the right helps with jumpiness when turning around.
      }
      image(sprite.animate(), 0, 0); // draw the current animation frame
    } else {
      scale(1.8); // original. 0.2, if you make it .9, needto translate -70, to alight character to platform
                  // for nartuo make 2.0, make translate -20, on y, 
      imageMode(CENTER);
      translate(0,-23);
      // if the character is facing left, invert the image
      if(direction == FACING_LEFT) {
        scale(-1,1);  // I like how they use scale to revers direction.
        translate(0, 0); // the 20 translate to the right helps with jumpiness when turning around.
      }
      image(sprite.animate(), 0, 0); // draw the current animation frame
    }
  }
  
  // when this is called the player can jump again
  void resetJump() {
    //jumped = false;
  }
  
  // we use update() to apply gravity
  void update() {

  }
  
  public int getWidth(){
    HShape shape = getShape();
    HRectangle rectangle = shape.getBoundingBox();
    int beingWidth =  (int) rectangle.getWidth();
    return beingWidth;
  }
  
  void receive(KeyMessage m) {
    int nKey = m.getKeyCode();
   /* if(m.isPressed()) { 
      if(nKey == POCodes.Key.D) {
        getVelocity().x = PLAYER_SPEED;
        direction = FACING_RIGHT;
        if(abs(getVelocity().y) <= 5) sprite.unpause();  
        world.getPostOffice().sendFloat("/" + SYSTEM_NAME + "/" + "setD", 1.0);
      }
      if(nKey == POCodes.Key.A) {
        getVelocity().x = -PLAYER_SPEED;
        direction = FACING_LEFT;
        if(abs(getVelocity().y) <= 5) sprite.unpause();  
        world.getPostOffice().sendFloat("/" + SYSTEM_NAME + "/" + "setA", 1.0);
      }
      if((nKey == POCodes.Key.W) && !jumped) {
        addImpulse(new PVector(0, -PLAYER_SPEED, 0));
        jumped = true;
        if(abs(getVelocity().y) <= 5) sprite.unpause();  
        world.getPostOffice().sendFloat("/" + SYSTEM_NAME + "/" + "setW", 1.0);
      }
      if(nKey == POCodes.Key.S) {
        getVelocity().y = 2*PLAYER_SPEED;
        if(abs(getVelocity().y) <= 5) sprite.unpause();  
        world.getPostOffice().sendFloat("/" + SYSTEM_NAME + "/" + "setS", 1.0);
      }
      
      // Player2
      if(nKey == POCodes.Key.RIGHT) {
        getVelocity().x = RASENGAN_SPEED;
        direction = FACING_RIGHT;
        if(abs(getVelocity().y) <= 5) sprite.unpause();  
        world.getPostOffice().sendFloat("/" + SYSTEM_NAME + "/" + "setRIGHT", 1.0);
      }
      if(nKey == POCodes.Key.LEFT) {
        getVelocity().x = -PLAYER_SPEED;
        direction = FACING_LEFT;
        if(abs(getVelocity().y) <= 5) sprite.unpause();  
        world.getPostOffice().sendFloat("/" + SYSTEM_NAME + "/" + "setLEFT", 1.0);
      }
      if(nKey == POCodes.Key.UP && !jumped) {
        addImpulse(new PVector(0, -PLAYER_SPEED, 0));
        jumped = true;
        if(abs(getVelocity().y) <= 5) sprite.unpause();  
        world.getPostOffice().sendFloat("/" + SYSTEM_NAME + "/" + "setUP", 1.0);
      }
      if(nKey == POCodes.Key.DOWN) {
        getVelocity().y = 2*PLAYER_SPEED;
        if(abs(getVelocity().y) <= 5) sprite.unpause();  
        world.getPostOffice().sendFloat("/" + SYSTEM_NAME + "/" + "setDOWN", 1.0);
      }
      
    } else { // when a key is released, we stop the player
        if(nKey == POCodes.Key.D || nKey == POCodes.Key.A || nKey == POCodes.Key.LEFT || nKey == POCodes.Key.RIGHT) {
          getVelocity().x = 0;
          sprite.pause();
          world.getPostOffice().sendFloat("/" + SYSTEM_NAME + "/" + "stop", 1.0);
        }
    }
    */
  } 
  
   void receive(OscMessage m) {
    String[] msgSplit = m.getAddress().split("/");
    /*
    if (msgSplit[1].equals(SYSTEM_NAME)) {
      if(msgSplit[2].equals("setD")) {
        getVelocity().x = PLAYER_SPEED;
        direction = FACING_RIGHT;
        if(abs(getVelocity().y) <= 5) sprite.unpause();  
      }
      if(msgSplit[2].equals("setA")) {
        getVelocity().x = -PLAYER_SPEED;
        direction = FACING_LEFT;
        if(abs(getVelocity().y) <= 5) sprite.unpause();  
      }
      if(msgSplit[2].equals("setW") && !jumped) {
        addImpulse(new PVector(0, -PLAYER_SPEED, 0));
        jumped = true;
        if(abs(getVelocity().y) <= 5) sprite.unpause();  
      }
      if(msgSplit[2].equals("setS")) {
        getVelocity().y = 2*PLAYER_SPEED;
        if(abs(getVelocity().y) <= 5) sprite.unpause();  
      }
      
      
      //Player2 controls
      if(msgSplit[2].equals("setRIGHT")) {
        getVelocity().x = PLAYER_SPEED;
        direction = FACING_RIGHT;
        if(abs(getVelocity().y) <= 5) sprite.unpause();  
      }
      if(msgSplit[2].equals("setLEFT")) {
        getVelocity().x = -PLAYER_SPEED;
        direction = FACING_LEFT;
        if(abs(getVelocity().y) <= 5) sprite.unpause();  
      }
      if(msgSplit[2].equals("setUP") && !jumped) {
        addImpulse(new PVector(0, -PLAYER_SPEED, 0));
        jumped = true;
        if(abs(getVelocity().y) <= 5) sprite.unpause();  
      }
      if(msgSplit[2].equals("setDOWN")) {
        getVelocity().y = 2*PLAYER_SPEED;
        if(abs(getVelocity().y) <= 5) sprite.unpause();  
      }      
      if(msgSplit[2].equals("stop")) {
        getVelocity().x = 0;
        sprite.pause(); 
      }
    } 
    else { // When the string is stop
      getVelocity().x = 0;
      sprite.pause();
    }
    */
    
  }
  
  
}
