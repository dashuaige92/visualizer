float hueDist(color c1, float h)
{
  float d = abs(hue(c1) - h);
  return min(d, 255 - d);
}

float hueDist(color c1, color c2)
{
  return hueDist(c1, hue(c2));
}

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

// Code taken from OpenCV blobs example.
void drawBlobs(Blob[] blobs)
{
  for (int i = 0; i < blobs.length; i++)
  {
    Rectangle bounding_rect	= blobs[i].rectangle;
    float area = blobs[i].area;
    float circumference = blobs[i].length;
    Point centroid = blobs[i].centroid;
    Point[] points = blobs[i].points;

    // rectangle
    noFill();
    stroke( blobs[i].isHole ? 128 : 64 );
    rect( bounding_rect.x, bounding_rect.y, bounding_rect.width, bounding_rect.height );


    // centroid
    stroke(0,0,255);
    line( centroid.x-5, centroid.y, centroid.x+5, centroid.y );
    line( centroid.x, centroid.y-5, centroid.x, centroid.y+5 );
    noStroke();
    fill(0,0,255);
    text( area,centroid.x+5, centroid.y+5 );


    fill(255,0,255,64);
    stroke(255,0,255);
    if ( points.length>0 )
    {
      beginShape();
      for( int j=0; j<points.length; j++ )
      {
        vertex( points[j].x, points[j].y );
      }
      endShape(CLOSE);
    }

    noStroke();
    fill(255,0,255);
    text( circumference, centroid.x+5, centroid.y+15 );

  }
}
