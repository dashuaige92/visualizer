import hypermedia.video.*;        //  Imports the OpenCV library
OpenCV opencv;                    //  Creates a new OpenCV Object

import java.util.Arrays;
import java.awt.Rectangle;
import java.awt.Point;

int FRAME_HEIGHT = 360;
int FRAME_WIDTH = 480;

int threshold = 70;
float maxDistance; // Distance at which distance contribution is clamped
float distanceWeight = 255; // Max contribution of distance

float[] gloveColors = {0, 50, 250, 20, 141};
Point[] currPosition = new Point[5];
Point[] lastPosition = new Point[5];

PImage img2;
PImage flag;
PImage backgroundImage;

void setup()
{
  size(3 * FRAME_WIDTH, 3 * FRAME_HEIGHT);
  keyPressed();

  // Initialises the OpenCV object
  opencv = new OpenCV(this);
  // Opens a video capture stream
  opencv.capture(FRAME_WIDTH, FRAME_HEIGHT);
  
  img2 = loadImage("rugby.jpg");
  flag = loadImage("flag.jpg");
  
  opencv.read();
  opencv.flip(OpenCV.FLIP_HORIZONTAL);
  backgroundImage = opencv.image().get();
}

void draw()
{
  colorMode(HSB);
 // background(0); //option: use with any of the SHAPEdraw methods and the shape
                   //will follow around the "cursor"


  PImage img;
  // Get a mirrored webcam frame for intuitive UX.
  opencv.read();
  opencv.flip(OpenCV.FLIP_HORIZONTAL);
  img = opencv.image();
  
  //do background subtraction on img
  
  //this is the raw image
  image(img, 2*FRAME_WIDTH, 0*FRAME_HEIGHT);
  
  //this is the subtracted image
  img = subtract_background(img, backgroundImage);
  image(img, 2*FRAME_WIDTH, 1*FRAME_HEIGHT);
  
  
  
  image(img, 0 * FRAME_WIDTH, 1 * FRAME_HEIGHT);

  // Process the image so we can perform computer vision on it.
  saturationFilter(img, threshold, true);
  image(img, 1 * FRAME_WIDTH, 1 * FRAME_HEIGHT);

  // Find blobs and draw them
  image(img, 1 * FRAME_WIDTH, 0 * FRAME_HEIGHT);
  opencv.copy(img);
  Blob[] blobs = opencv.blobs(FRAME_WIDTH * FRAME_HEIGHT / 1250, FRAME_WIDTH * FRAME_HEIGHT / 50, 20, true);
  pushMatrix();
  translate(1 * FRAME_WIDTH, 0 * FRAME_HEIGHT);
  drawBlobs(blobs);
  popMatrix();

  // Hue filter our image and find markers.
  hueFilter(img);

  findMarkers(blobs, img);


  if(lastPosition[4] == null)
  {
    arrayCopy(currPosition, lastPosition);
  }
   
//EFFECT CHOICES
//  continuousLines(currPosition[4], lastPosition[4]);
// pointColor(currPosition[4]);
// overlay(currPosition[4], img2);
//  variableEllipse(currPosition[4], lastPosition[4]);
// circleDraw(currPosition[4]);
// squareDraw(currPosition[4]);
// roundedSquareDraw(currPosition[4]);
// highlighter(currPosition[4]);
 murica(currPosition[4], flag);
 
 
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

void mousePressed()
{
   opencv.read();
  opencv.flip(OpenCV.FLIP_HORIZONTAL);
  backgroundImage = opencv.image().get(); 
}
