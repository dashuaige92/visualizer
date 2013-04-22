import hypermedia.video.*;        //  Imports the OpenCV library
OpenCV opencv;                    //  Creates a new OpenCV Object

int FRAME_HEIGHT = 360;
int FRAME_WIDTH = 480;

PImage webcam_img;
PImage output_img;
PImage blend_img;

void setup()
{
  size(2 * FRAME_WIDTH, 2 * FRAME_HEIGHT);

  // Initialises the OpenCV object
  opencv = new OpenCV(this);
  // Opens a video capture stream
  opencv.capture(FRAME_WIDTH, FRAME_HEIGHT);

  output_img = new PImage(FRAME_WIDTH, FRAME_HEIGHT);
  blend_img = new PImage(FRAME_WIDTH, FRAME_HEIGHT);

  loadTemplates();
}

void draw()
{
  // Get a mirrored webcam frame for intuitive UX.
  opencv.read();
  opencv.flip(OpenCV.FLIP_HORIZONTAL);
  webcam_img = opencv.image();

  // Find the pixel closest to c0 and make it white in output_img
  PVector id = matchColor(webcam_img, blue, FRAME_WIDTH, FRAME_HEIGHT);
  paint(output_img, (int)id.x, (int)id.y, dot);

  blend_img.copy(webcam_img, 0, 0, FRAME_WIDTH, FRAME_HEIGHT,
      0, 0, FRAME_WIDTH, FRAME_HEIGHT);
  blend_img.blend(output_img, 0, 0, FRAME_WIDTH, FRAME_HEIGHT,
      0, 0, FRAME_WIDTH, FRAME_HEIGHT, SCREEN);

  // Display the webcam image
  image(webcam_img, 0 * FRAME_WIDTH, 1 * FRAME_HEIGHT);
  // Display the output image
  image(output_img, 1 * FRAME_WIDTH, 0 * FRAME_HEIGHT);
  image(blend_img, 1 * FRAME_WIDTH, 1 * FRAME_HEIGHT);
}
