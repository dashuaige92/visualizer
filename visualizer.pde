import hypermedia.video.*;        //  Imports the OpenCV library
OpenCV opencv;                    //  Creates a new OpenCV Object

import java.util.Arrays;
import java.awt.Rectangle;
import java.awt.Point;

int FRAME_HEIGHT = 240;
int FRAME_WIDTH = 320;

int threshold = 70;
float maxDistance; // Distance at which distance contribution is clamped
float distanceWeight; // Max contribution of distance

float[] gloveColors = {0, 50, 250, 20, 141};
Point[] currPosition = new Point[5];
Point[] lastPosition = new Point[5];

PImage lastFrame;
PImage img2;
PImage flag;
PImage backgroundImage;

void setup()
{
  size(3 * FRAME_WIDTH, 2 * FRAME_HEIGHT);

  // Reset parameters
  key = 'r';
  keyPressed();

  // Initialises the OpenCV object
  opencv = new OpenCV(this);
  // Opens a video capture stream
  opencv.capture(FRAME_WIDTH, FRAME_HEIGHT);

  lastFrame = new PImage(FRAME_WIDTH, FRAME_HEIGHT);
  img2 = loadImage("rugby.jpg");
  flag = loadImage("flag.jpg");
  
  opencv.read();
  opencv.flip(OpenCV.FLIP_HORIZONTAL);
  backgroundImage = opencv.image().get();
}

void draw()
{
  colorMode(HSB);
  set(0, 0, lastFrame);

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
  findMarkers(blobs, img); // Match fingers to blob locations in currPosition
  pruneMarkers(); // If a blob is believed to be a mismatch, null it

  if(lastPosition[4] == null)
  {
    arrayCopy(currPosition, lastPosition);
  }

  switch (key) {
    case '1':
      continuousLines(currPosition[4], lastPosition[4]);
      break;
    case '2':
      pointColor(currPosition[4]);
      break;
    case '3':
      overlay(currPosition[4], img2);
      break;
    case '4':
      variableEllipse(currPosition[4], lastPosition[4]);
      break;
    case '5':
      circleDraw(currPosition[4]);
      break;
    case '6':
      squareDraw(currPosition[4]);
      break;
    case '7':
      roundedSquareDraw(currPosition[4]);
      break;
    case '8':
      highlighter(currPosition[4]);
      break;
    case '9':
      murica(currPosition[4], flag);
      break;
  }

  lastFrame = get(0, 0, FRAME_WIDTH, FRAME_HEIGHT);
  drawMarkers(img);
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
  switch (key) {
    case 'c':
      opencv.read();
      opencv.flip(OpenCV.FLIP_HORIZONTAL);
      backgroundImage = opencv.image().get(); 
      break;
    case 'r':
      maxDistance = 100;
      println("maxDistance\t-> " + maxDistance);
      distanceWeight = 40;
      println("distanceWeight\t-> " + distanceWeight);
      break;
    default:
      lastFrame = new PImage(FRAME_WIDTH, FRAME_HEIGHT);
  }
}
