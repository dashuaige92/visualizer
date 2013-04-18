import hypermedia.video.*;        //  Imports the OpenCV library
OpenCV opencv;                    //  Creates a new OpenCV Object

int FRAME_HEIGHT = 240;
int FRAME_WIDTH = 320;

PImage webcam_img;
PImage output_img;

void setup()
{
  size(2 * FRAME_WIDTH, 2 * FRAME_HEIGHT);

  // Initialises the OpenCV object
  opencv = new OpenCV(this);
  // Opens a video capture stream
  opencv.capture(FRAME_WIDTH, FRAME_HEIGHT);

  output_img = new PImage(FRAME_WIDTH, FRAME_HEIGHT);
}

void draw()
{

  opencv.read();
  webcam_img = opencv.image();

  // Find the pixel closest to c0 and make it white in output_img
  color c0 = color(0, 0, 255); // blue
  int closest_idx = -1;
  float closest_dist = MAX_FLOAT;

  webcam_img.loadPixels();
  for (int i = 0; i < FRAME_WIDTH * FRAME_HEIGHT; i++) {
    color c = webcam_img.pixels[i];
    float d = dist(hue(c), hue(c0), saturation(c), saturation(c0), brightness(c), brightness(c0));
    if (d < closest_dist) {
      closest_dist = d;
      closest_idx = i;
    }
  }
  output_img.loadPixels();
  output_img.pixels[closest_idx] = color(255, 255, 255);
  output_img.updatePixels();

  // Display the webcam image
  image(webcam_img, 0 * FRAME_WIDTH, 0 * FRAME_HEIGHT);
  // Display the output image
  image(output_img, 1 * FRAME_WIDTH, 0 * FRAME_HEIGHT);

  // Display some OpenCV effects
  opencv.copy(webcam_img);
  opencv.threshold(80, 255, opencv.THRESH_BINARY);
  image(opencv.image(), 0 * FRAME_WIDTH, 1 * FRAME_HEIGHT);
  opencv.copy(webcam_img);
  opencv.convert(opencv.GRAY);
  image(opencv.image(), 1 * FRAME_WIDTH, 1 * FRAME_HEIGHT);
}
