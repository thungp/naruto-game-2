import hermes.animation.*;

public class RasenganHelper {
  /*
  public static void setupAnimations() {
    
    BeingVar.player1RasenganLaunchAnimation = getRasenganLaunchAnimation( initSpriteFrame("Naruto_04.png"));
    BeingVar.player2RasenganLaunchAnimation = getPlayer2RasenganLaunchAnimation(initSpriteFrame("Naruto_04.png")); 
  }
  */

  public static SpriteFrame initSpriteFrame(String fileName) {
   
   return new SpriteFrame(fileName);
  }

//  public static Animation getRasenganLaunchAnimation(){
//    sprite01  = new SpriteFrame("Naruto_04.png");
//    java.util.ArrayList narutoWalkArrayList = sprite01.getFrameStripByRectangle(0, 4150, 500, 4220, 7);
//    Animation walkAnim = new Animation(narutoWalkArrayList, 200);
//    return walkAnim;
//  }
  
  public static Animation getRasenganLaunchAnimation(SpriteFrame sprite01){
    //sprite01  = new SpriteFrame("Naruto_04.png");
    java.util.ArrayList narutoWalkArrayList = sprite01.getFrameStripByRectangle(0, 4150, 500, 4220, 7);
    Animation walkAnim = new Animation(narutoWalkArrayList, 200);
    return walkAnim;
  }
  
//  public static Animation getPlayer2RasenganLaunchAnimation(){
//    sprite01  = new SpriteFrame("Naruto_04.png");
//    sprite01.tintSpriteFrame(5.0, .8, .8, 1);
//    java.util.ArrayList narutoWalkArrayList = sprite01.getFrameStripByRectangle(0, 4150, 500, 4220, 7);
//    Animation walkAnim = new Animation(narutoWalkArrayList, 200);
//    return walkAnim;
//  }
  
  public static Animation getPlayer2RasenganLaunchAnimation(SpriteFrame sprite01){
    //sprite01  = new SpriteFrame("Naruto_04.png");
    sprite01.tintSpriteFrame((float) 5.0, (float) 0.8, (float) 0.8, (float) 1.0);
    java.util.ArrayList narutoWalkArrayList = sprite01.getFrameStripByRectangle(0, 4150, 500, 4220, 7);
    Animation walkAnim = new Animation(narutoWalkArrayList, 200);
    return walkAnim;
  }
  
}
