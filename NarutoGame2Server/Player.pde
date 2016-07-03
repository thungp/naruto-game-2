/**
 * Represents the player
 */
class Player extends MassedBeing implements BeingVar {
  
  final static float PLAYER_WIDTH = 50;
  final static float PLAYER_HEIGHT = 39;
  final static float PLAYER_SPEED = 150;
  SpriteFrame sprite01;

  Rasengan rasengan;
  
  // constants used to indicate the direction the player is facing
  //final static int FACING_LEFT = 1;
  //final static int FACING_RIGHT = 2;
  
  // contant used to indicate player 1 or Player 2
  public final static int PLAYER_1 = 1;
  public final static int PLAYER_2 = 2;
  
  // fudge factors
  final int rasegnanDistance = 20;
  
  int direction = FACING_RIGHT; // the direction the player is facing
  boolean jumped = false;       // whether the player can jump
  
  boolean rasenganActive = false;
  
  AnimatedSprite sprite;
  int animIndex;
  
  int playerNum;
  
  Player(float x, float y, int player) {
    super(new HRectangle(HermesMath.makeVector(x, y), PLAYER_WIDTH, PLAYER_HEIGHT), HermesMath.zeroVector(), 1.0f, 1.0f);
    playerNum = player;
    
    // load the animated character walk cycle
    sprite = new AnimatedSprite();
    Animation anim = new Animation("skeilert_walk_final", 1, 24, ".png", (int)(1000.0f / 24.0f));
    //animIndex = sprite.addAnimation(anim);
    if(playerNum == PLAYER_1) {
      animIndex = sprite.addAnimation(getNarutoWalkAnimation());
    } else {
      animIndex = sprite.addAnimation(getWalkAnimation());
    }
    sprite.setActiveAnimation(animIndex);
    sprite.pause();
  }
  
  Animation getNarutoWalkAnimation(){
    sprite01  = new SpriteFrame("Naruto_04.png");
    java.util.ArrayList narutoWalkArrayList = sprite01.getFrameStripByRectangle(224, 524, 404, 584, 6);
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
      scale(2.0); // original. 0.2, if you make it .9, needto translate -70, to alight character to platform
                  // for nartuo make 2.0, make translate -20, on y, 
      imageMode(CENTER);
      translate(0,-20);
      // if the character is facing left, invert the image
      if(direction == FACING_LEFT) {
        scale(-1,1);  // I like how they use scale to revers direction.
        translate(0, 0); // the dasd20 translate to the right helps with jumpiness when turning around.
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
    jumped = false;
  }
  
  // we use update() to apply gravity
  void update() {
    addForce(new PVector(0, -GRAVITY * getMass(), 0));
    if(abs(getVelocity().y) >= 5)
      sprite.pause();
  }

  int getRasenganPositionX() {
    int rasenganX = 0;
    if (direction == FACING_RIGHT) {
      if(rasengan != null) {
        rasenganX = (int) (getX() + (getWidth()/2) + (rasengan.getWidth()/2) - rasegnanDistance);
        println(" I want want to see this");
      } else {
        rasenganX = (int) (getX() + (getWidth()/2) + (rasengan.RASENGAN_WIDTH/2) - rasegnanDistance);
        println(" I don't want to see this");
      }
    } else {
      if(rasengan != null) {
        rasenganX = (int) (getX() - (getWidth()/2) - (rasengan.getWidth()/2) + rasegnanDistance);
      } else {
        rasenganX = (int) (getX() - (getWidth()/2) - (rasengan.RASENGAN_WIDTH/2) + rasegnanDistance);
      }
      
    }
   
   return rasenganX; 
  }
  
  int getRasenganPostionY() {
   return (int) getY(); 
  }
  
  public int getWidth(){
    HShape shape = getShape();
    HRectangle rectangle = shape.getBoundingBox();
    int beingWidth =  (int) rectangle.getWidth();
    return beingWidth;
  }
  
  void receive(KeyMessage m) {
    int nKey = m.getKeyCode();
    if(m.isPressed()) { 
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
      if(nKey == POCodes.Key.G) {
        // Create Rasengan
        if(!isRasenganActive()){
          setRasenganActive(true);
          rasengan = player1Rasengan = new Rasengan(getRasenganPositionX(), getRasenganPostionY(), Rasengan.PLAYER_1, direction);
          rasengan.setOwner(this);
          world.register(player1Rasengan, true);
          if(this == player) {
            world.register(player2, rasengan, playerRasenganCollider);
          } else {
            world.register(player, rasengan, playerRasenganCollider);
          }
        } else {
         // don't do anything, only allow one rasengan active at a time. 
        }
        
        world.getPostOffice().sendFloat("/" + SYSTEM_NAME + "/" + "setL", 1.0);
      }
      
      
      
      // Player2
      if(nKey == POCodes.Key.RIGHT) {
        getVelocity().x = PLAYER_SPEED;
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
      
      if(nKey == POCodes.Key.L) {
        // Create Rasengan
        if(!isRasenganActive()){
          println("about to create rasengan"); //<>//
          setRasenganActive(true);
          rasengan = player2Rasengan = new Rasengan(getRasenganPositionX(), getRasenganPostionY(), Rasengan.PLAYER_2, direction);
          rasengan.setOwner(this);
          world.register(player2Rasengan, true);
          if(this == player) {
            world.register(player2, rasengan, playerRasenganCollider);
          } else {
            world.register(player, rasengan, playerRasenganCollider);
          }
        } else {
           // don't allow more than one rasengan at a time. 
        }
        
        world.getPostOffice().sendFloat("/" + SYSTEM_NAME + "/" + "setL", 1.0);
      }
      
      
    } else { // when a key is released, we stop the player
        if(nKey == POCodes.Key.D || nKey == POCodes.Key.A || nKey == POCodes.Key.LEFT || nKey == POCodes.Key.RIGHT) {
          getVelocity().x = 0;
          sprite.pause();
          world.getPostOffice().sendFloat("/" + SYSTEM_NAME + "/" + "stop", 1.0);
        }
    }
  } 
  
   void receive(OscMessage m) {
    String[] msgSplit = m.getAddress().split("/");
    
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
  }
  
  public boolean isRasenganActive() {
    return rasenganActive; 
  }
  
  public void setRasenganActive(boolean val){
    rasenganActive = val;
  }
  
}
