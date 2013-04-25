float cDist(color c1, color c2)
{
  return dist(
      hue(c1), hue(c2), 
      saturation(c1), saturation(c2), 
      brightness(c1), brightness(c2)
      );
}

// Look for the pixel whose color is closest to c0 in src
// Returns a PVector containing the xy value of the best pixel
PVector matchColor(PImage src, color c0, int sw, int sh)
{
  int closestY = -1;
  int closestX = -1;
  float closestDist = MAX_FLOAT;

  for(int y = 0; y < sh; y++)
  {
    for(int x = 0; x < sw; x++)
    {
      color c = src.get(x, y);
      float d = cDist(c, c0);
      if(d < closestDist){
        closestDist = d;
        closestY = y;
        closestX = x;
      }
    } 
  }
  return new PVector(closestX, closestY);
}

// Mean shift src with radius r and maximum color distance d based on cDist.
// NOTE: src will be modified
void meanShiftFilter(PImage src, int r, float d, int maxIter)
{
  //  src.filter(GRAY); // Make sure this function is run. Delete later.
  src.loadPixels();

  for (int i = 0; i < maxIter; i++)
  {
    for (int x = 0; x < src.width; x++)
    {
      for (int y = 0; y < src.height; y++)
      {
        color c = src.get(x,y);
        int colorTotalR = 0;
        int colorTotalG = 0;
        int colorTotalB = 0;
        int numColors = 0;
        //look at colors within radius window
        //average colors within distance to center and assign new value to center
        for (int j = x - r; j <= x + r; j++)
        {
          for(int k = y - r;  k <= y + r; k++)
          {
            if(cDist(src.get(j,k),c) < d)  
            {
              // System.out.println("color added"); 
              colorTotalR += red(src.get(j,k));
              colorTotalG += green(src.get(j,k));
              colorTotalB += blue(src.get(j,k));

              numColors++;
            }

          }

        }
        if(numColors != 0)
        {
          int finalR = (int) colorTotalR/numColors;
          int finalG = (int) colorTotalG/numColors;
          int finalB = (int) colorTotalB/numColors;
          color finalC = color(finalR, finalG, finalB);
          src.set(x,y, finalC); 
        }
      }
    }
  }
  src.updatePixels();
}

