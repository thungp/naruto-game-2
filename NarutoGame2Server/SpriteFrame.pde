public class SpriteFrame{
  PImage sprite;
  
  
  SpriteFrame(String imgFile){
    sprite = loadImage(imgFile);
    sprite.format = ARGB;
    sprite.loadPixels();
    sprite = transparentizeBackground(sprite, sprite.pixels[0]);
  }
  
  public PImage get(int x, int y, int w, int h){
    return sprite.get(x, y, w, h);
  }
  
  /*
    Takes in a ratio to multiply the individual color values of the pixels of the sprite image.
  */
  void tintSpriteFrame(float r, float g, float b, float a){
   
   sprite = tintImage(sprite, r, g, b, a);
   
  }
  
  public ArrayList<PImage> getFrameStripByRectangle(int topLeftX, int topLeftY, int bottomRightX, int bottomRightY, int numFrames) {
     
    ArrayList<PImage> frameArrayList = new ArrayList();
    
    int individualFrameWidth = (int)((bottomRightX - topLeftX)/numFrames);
    int individualFrameHeight = (int) (bottomRightY - topLeftY);
    
    for (int i = 0; i < numFrames; i++) {
       frameArrayList.add(sprite.get(topLeftX + (individualFrameWidth * i), topLeftY, individualFrameWidth,  individualFrameHeight));  
    }
    
    return frameArrayList;
  } 

}
