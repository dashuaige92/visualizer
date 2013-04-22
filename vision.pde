// Look for the pixel whose color is closest to c0 in src
// Returns a PVector containing the xy value of the best pixel
PVector matchColor(PImage src, color c0, int sw, int sh){
  int closestY = -1;
  int closestX = -1;
  float closestDist = MAX_FLOAT;
  
  for(int y = 0; y < sh; y++)
  {
    for(int x = 0; x < sw; x++)
    {
      color c = src.get(x, y);
      float d = dist(
        hue(c), hue(c0), 
        saturation(c), saturation(c0), 
        brightness(c), brightness(c0)
        );
      if(d < closestDist){
        closestDist = d;
        closestY = y;
        closestX = x;
      }
    } 
  }
  
  return new PVector(closestX, closestY);
   
}
