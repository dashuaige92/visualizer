float hueDist(color c1, float h)
{
  float d = abs(hue(c1) - h);
  return min(d, 255 - d);
}

float hueDist(color c1, color c2)
{
  return hueDist(c1, hue(c2));
}

// Edit currPosition with nearest match or null.
void findMarkers(Blob[] blobs, PImage img) {
  int[] matches = {0, 0, 0, 0, 0}; // Look at next best match if conflicted.
  BlobScore[][] scores = new BlobScore[5][];
  for (int i = 1; i < 5; i++)
  {
    if (blobs.length == 0)
      break;

    scores[i] = new BlobScore[blobs.length];
    for (int j = 0; j < blobs.length; j++)
    {
      Point c = blobs[j].centroid;
      scores[i][j] = new BlobScore(j, i, img, c, lastPosition[i]);
    }
    Arrays.sort(scores[i]); // Lowest (best) match at index 0.

    //continue; // Uncomment this line to allow conflicts.
    // Note: Doesn't solve multiple simultaneous conflicts.
    for (int j = 1; j < i; j++)
    {
      if (blobs[scores[i][matches[i]].blobIndex] == blobs[scores[j][matches[j]].blobIndex])
      {
        if (scores[i][matches[i]].compareTo(scores[j][matches[j]]) == 1)
        {
          matches[i] += (matches[i] + 1 == blobs.length) ? 0 : 1;
        }
        else
        {
          matches[j] += (matches[j] + 1 == blobs.length) ? 0 : 1;
        }
      }
    }
  }
  for (int i = 1; i < 5; i++)
  {
    currPosition[i] = blobs[scores[i][matches[i]].blobIndex].centroid;
  }
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
