import hypermedia.video.*;        //  Imports the OpenCV library
OpenCV opencv;                    //  Creates a new OpenCV Object

import java.awt.Rectangle;
import java.awt.Point;

int FRAME_HEIGHT = 360;
int FRAME_WIDTH = 480;

int threshold = 70;
float distanceWeight = 50;
float maxMovement = 50;

float[] gloveColors = {0, 50, 250, 20, 141};
float[] nearestMatch = {MAX_FLOAT, MAX_FLOAT, MAX_FLOAT, MAX_FLOAT, MAX_FLOAT};
Point[] currPosition = new Point[5];
Point[] lastPosition = new Point[5];

 


void setup()
{
  size(2 * FRAME_WIDTH, 2 * FRAME_HEIGHT);

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
  Blob[] blobs = opencv.blobs(100, 1000, 20, true);
  pushMatrix();
  translate(1 * FRAME_WIDTH, 0 * FRAME_HEIGHT);
  drawBlobs(blobs);
  popMatrix();

  // Hue filter our image and find markers.
  hueFilter(img);
  nearestMatch = new float[] {MAX_FLOAT, MAX_FLOAT, MAX_FLOAT, MAX_FLOAT, MAX_FLOAT};
  for (int i = 0; i < blobs.length; i++)
  {
    Point c = blobs[i].centroid;

    for (int j = 1; j < 5; j++) {
      // Distance is function of distance from lastPosition and hueDist.
      float d = hueDist(img.get(c.x, c.y), gloveColors[j]);

      if (lastPosition[j] != null) {
        Point c0 = lastPosition[j];
        d += map(abs(c.x - c0.x) + abs(c.y - c0.y), 0, FRAME_WIDTH + FRAME_HEIGHT, 0, distanceWeight);
        println(d);
      }
      //if (lastPosition[j] != null) {
        //Point c0 = lastPosition[j];
        //if (abs(c.x - c0.x) + abs(c.y - c0.y) > maxMovement)
          //continue;
      //}

      if (d < nearestMatch[j]) {
        currPosition[j] = c;
        nearestMatch[j] = d;
      }
    }
  }
  for (int i = 1; i < 5; i++) {
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

void mouseDragged() {
  maxMovement = (int) map(mouseX, 0, width, 0, FRAME_WIDTH + FRAME_HEIGHT);
  println("maxMovement\t-> " + maxMovement);
  distanceWeight = (int) map(mouseX, 0, width, 0, FRAME_WIDTH + FRAME_HEIGHT);
  println("distanceWeight\t-> " + distanceWeight);
}

void keyPressed() {
  maxMovement = 50;
  println("maxMovement\t-> " + maxMovement);
  distanceWeight = 50;
  println("distanceWeight\t-> " + distanceWeight);
}
