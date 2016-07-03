

// make background transparent
// currently hard coded to look for green color only 
// based on sample
PImage transparentizeBackground(PImage p, color col) {
  PImage p2;
  p.loadPixels();
  
  p2 = p.get(); // changed from copy() as it appears to not exist in 2.x
  p2.loadPixels();
  int pLen = p2.pixels.length;
  
  for(int i = 0; i < pLen; i++){
    int isGreenMatch = (int)green(p2.pixels[i]);
    int isBlueMatch  = (int)blue(p2.pixels[i]);
    int isRedMatch   = (int)red(p2.pixels[i]);
    if(isGreenMatch == (int)green(col) && isBlueMatch == (int)blue(col) && isRedMatch == (int)red(col)) {
      p2.pixels[i] = color(0, 0, 0, 0);
    }
  }
  return p2;
}

// tints the referene passed in of a pImage.
PImage tintImage(PImage p, float redRatio, float greenRatio, float blueRatio, float alphaRatio){
 PImage p2;
  p.loadPixels();
  p2 = p.get();
  p2.loadPixels();
  int pLen = p2.pixels.length;
  
  for (int i = 0; i < pLen; i++) {
    float r = red(p2.pixels[i]);
    float g = green(p2.pixels[i]);
    float b = blue(p2.pixels[i]);
    float a = alpha(p2.pixels[i]); 
    r *= redRatio;
    g *= greenRatio;
    b *= blueRatio;
    a *= alphaRatio;
    p2.pixels[i] = color(r, g, b, a);
  }
  //p2.updatePixels();
  return p2;
} 


interface BeingVar {
  final static int FACING_LEFT = 1;
  final static int FACING_RIGHT = 2;
}
