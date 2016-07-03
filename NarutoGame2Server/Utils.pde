

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

