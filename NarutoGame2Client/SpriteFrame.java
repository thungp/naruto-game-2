import java.util.ArrayList;
import processing.core.*;
import processing.core.PApplet.*;
import hermes.*;


/*
  This class is effectively a duplicate of the original SpriteFrame class in the previous release except that it has been modified
  to live outide of the Processing PPapplet contantainer class.  This was done as a first attempt to solve the
  stuttering issue with Processing where we were tryng to do PImage method calls outside of setup, whichit didn't recommend and had some
  weird side effects. since the code works now, going to check it in.  Later need to refactor to try and live within the construct of PPaplet 
  and not try and use static methods as Processing has issues with that (apparently). The real end goal was to try and load the sprites and creat the 
  animation objects in setup vice from the draw method at runtime. 
  
  Refences: 
  (a) https://processing.org/discourse/beta/num_1232266369.html
  (b) https://processing.org/discourse/beta/num_1255459084.html
  (c) http://processing.github.io/processing-javadocs/core/
  (d) https://processing.org/discourse/beta/num_1263237645.html
  (e) https://github.com/ybakos/proclipsing/tree/master/proclipsingSite/plugins 
  (f) https://vimeo.com/19076476
  Note: Use of jave IDE, and Proclipse plugin was used to help craft this arguably, overkill solution. 
  
  
*/
public class SpriteFrame{
  PImage sprite;
  
  
  SpriteFrame(String imgFile){
    PApplet pApplet = Hermes.getPApplet();
    sprite = pApplet.loadImage(imgFile);
    sprite.format = PConstants.ARGB;
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
  
  PImage tintImage(PImage p, float redRatio, float greenRatio, float blueRatio, float alphaRatio){
    PImage p2;
    PApplet pApplet = Hermes.getPApplet();
    
    p.loadPixels();
    p2 = p.get();
    p2.loadPixels();
    int pLen = p2.pixels.length;
    
    for (int i = 0; i < pLen; i++) {
      float r = pApplet.g.red(p2.pixels[i]);
      float g = pApplet.g.green(p2.pixels[i]);
      float b = pApplet.g.blue(p2.pixels[i]);
      float a = pApplet.g.alpha(p2.pixels[i]); 
      r *= redRatio;
      g *= greenRatio;
      b *= blueRatio;
      a *= alphaRatio;
      p2.pixels[i] = customColor(r, g, b, a);
    }
    p2.updatePixels();
    return p2;
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
  
  /*
     Note: This particular solution involved creating tab  with a .java extension which creates a java class outside of Paplet.
     Because of that, we dont' get Processings preprocessing  which means we need to swap in the unerlying raw Java code in the library.
     ref: 
      (a) https://processing.org/discourse/beta/num_1231042010.html
      (b) http://processing.github.io/processing-javadocs/core/
      
  */
  PImage transparentizeBackground(PImage p, int col) {
    PApplet pApplet = Hermes.getPApplet();
    PImage p2;
    p.loadPixels();
    
    p2 = p.get(); // changed from copy() as it appears to not exist in 2.x
    p2.loadPixels();
    int pLen = p2.pixels.length;
    
    for(int i = 0; i < pLen; i++){
      int isGreenMatch = (int)pApplet.g.green(p2.pixels[i]);
      int isBlueMatch  = (int)pApplet.g.blue(p2.pixels[i]);
      int isRedMatch   = (int)pApplet.g.red(p2.pixels[i]);
      if(isGreenMatch == (int)pApplet.g.green(col) && isBlueMatch == (int)pApplet.g.blue(col) && isRedMatch == (int)pApplet.g.red(col)) {
        
           
        p2.pixels[i] = customColor(0, 0, 0, 0);
      }
    }
    return p2;
  }
  
  /*
    This method was liefted from the processing PApplet class, reanmed to customColor to handle for parameter method
   but is used when outside of the PApplet container.  Note: ideally, we shouldn't need this if
   we get around the concept of static methods inside the Processing framework. 
   Note: this is also dependent upon the Hermes framework.
  */
  public final int customColor(float v1, float v2, float v3, float alpha) {
    PApplet pApplet = Hermes.getPApplet();
    
    if (pApplet.g == null) {
      if (alpha > 255) alpha = 255; else if (alpha < 0) alpha = 0;
      if (v1 > 255) v1 = 255; else if (v1 < 0) v1 = 0;
      if (v2 > 255) v2 = 255; else if (v2 < 0) v2 = 0;
      if (v3 > 255) v3 = 255; else if (v3 < 0) v3 = 0;

      return ((int)alpha << 24) | ((int)v1 << 16) | ((int)v2 << 8) | (int)v3;
    }
    return pApplet.g.color(v1, v2, v3, alpha);
  }
 
}
