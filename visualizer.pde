import hypermedia.video.*;        //  Imports the OpenCV library
OpenCV opencv;                    //  Creates a new OpenCV Object

import java.awt.Rectangle;
import java.awt.Point;

int FRAME_HEIGHT = 360;
int FRAME_WIDTH = 480;

int threshold = 70;
float maxDistance; // Distance at which distance contribution is clamped
float distanceWeight = 255; // Max contribution of distance

float[] gloveColors = {0, 50, 250, 20, 141};
float[] nearestMatch = {MAX_FLOAT, MAX_FLOAT, MAX_FLOAT, MAX_FLOAT, MAX_FLOAT};
Point[] currPosition = new Point[5];
Point[] lastPosition = new Point[5];

 


void setup()
{
  size(2 * FRAME_WIDTH, 2 * FRAME_HEIGHT);
  keyPressed();

  // Initialises the OpenCV object
  opencv = new OpenCV(this);
  // Opens a video capture stream
  opencv.capture(FRAME_WIDTH, FRAME_HEIGHT);
  
 
}

void draw()
{
  colorMode(HSB);
 // background(0);
  


  PImage img;
  // Get a mirrored webcam frame for intuitive UX.
  opencv.read();
  opencv.flip(OpenCV.FLIP_HORIZONTAL);
  img = opencv.image();
  image(img, 0 * FRAME_WIDTH, 1 * FRAME_HEIGHT);

  // Process the image so we can perform computer vision on it.
  saturationFilter(img, threshold, true);
  image(img, 1 * FRAME_WIDTH, 1 * FRAME_HEIGHT);

  // Find blobs and draw them
  image(img, 1 * FRAME_WIDTH, 0 * FRAME_HEIGHT);
  opencv.copy(img);
  Blob[] blobs = opencv.blobs(250, 1000, 20, true);
  pushMatrix();
  translate(1 * FRAME_WIDTH, 0 * FRAME_HEIGHT);
  drawBlobs(blobs);
  popMatrix();

  // Hue filter our image and find markers.
  hueFilter(img);
  nearestMatch = new float[] {MAX_FLOAT, MAX_FLOAT, MAX_FLOAT, MAX_FLOAT, MAX_FLOAT};
  for (int i = 1; i < 5; i++)
  {
    for (int j = 0; j < blobs.length; j++)
    {
      Point c = blobs[j].centroid;
      float d = hueDist(img.get(c.x, c.y), gloveColors[i]);

      // Distance is function of distance from lastPosition and hueDist.
      if (lastPosition[i] != null)
      {
        Point c0 = lastPosition[i];
        float dPosition = map(abs(c.x - c0.x) + abs(c.y - c0.y), 0, maxDistance, 0, distanceWeight);
        dPosition = dPosition > distanceWeight ? distanceWeight : dPosition;
        d += dPosition;
      }

      if (d < nearestMatch[i])
      {
        currPosition[i] = c;
        nearestMatch[i] = d;
      }
    }
  }
  for (int i = 1; i < 5; i++)
  {
    Point c = currPosition[i];
    if (c == null)
      continue;
    stroke(gloveColors[i], 255, 255);
    line(c.x-5, c.y, c.x+5, c.y);
    line(c.x, c.y-5, c.x, c.y+5);
    noStroke();
    text(hue(img.get(c.x, c.y)), c.x+5, c.y+5);
    text(nearestMatch[i], c.x+5, c.y+15);
  }
 
  if(lastPosition[4] == null)
  {
     System.out.println("GOT HERE");
    arrayCopy(currPosition, lastPosition);
  }
   

  continuousLines(currPosition[4], lastPosition[4]);
 
  arrayCopy(currPosition, lastPosition);
}

void mouseDragged()
{
  maxDistance = (int) map(mouseX, 0, width, 0, 100);
  println("maxDistance\t-> " + maxDistance);
  distanceWeight = (int) map(mouseX, 0, width, 0, 1000);
  println("distanceWeight\t-> " + distanceWeight);
}

void keyPressed()
{
  maxDistance = 50;
  println("maxDistance\t-> " + maxDistance);
  distanceWeight = 255;
  println("distanceWeight\t-> " + distanceWeight);
}
