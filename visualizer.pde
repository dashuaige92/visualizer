import hypermedia.video.*;        //  Imports the OpenCV library
OpenCV opencv;                    //  Creates a new OpenCV Object

import java.awt.Rectangle;
import java.awt.Point;

int FRAME_HEIGHT = 360;
int FRAME_WIDTH = 480;

int threshold = 80;

PVector[] lastPosition = new PVector[1]; // One for each finger

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
  // Get a mirrored webcam frame for intuitive UX.
  opencv.read();
  opencv.flip(OpenCV.FLIP_HORIZONTAL);
  opencv.remember();
  image(opencv.image(), 0 * FRAME_WIDTH, 1 * FRAME_HEIGHT);

  // Process the image so we can perform computer vision on it.
  opencv.threshold(threshold);
  image(opencv.image(), 1 * FRAME_WIDTH, 0 * FRAME_HEIGHT);
  image(opencv.image(), 1 * FRAME_WIDTH, 1 * FRAME_HEIGHT);

  // Find blobs and draw them
  Blob[] blobs = opencv.blobs(100, FRAME_WIDTH * FRAME_HEIGHT / 50, 20, true);
  pushMatrix();
  translate(1 * FRAME_WIDTH, 0 * FRAME_HEIGHT);
  drawBlobs(blobs);
  popMatrix();

  // Show means shift segmentation in top left.
  opencv.restore();
  opencv.flip(OpenCV.FLIP_HORIZONTAL);
  PImage src = opencv.image();
  meanShiftFilter(src, 2, 25, 1);
  image(src, 0 * FRAME_WIDTH, 0 * FRAME_HEIGHT);
}

void mouseDragged() {
  threshold = (int) map(mouseX, 0, width, 0, 255);
  println("threshold\t-> " + threshold);
}

void keyPressed() {
  threshold = 80;
  println("threshold\t-> " + threshold);
}
