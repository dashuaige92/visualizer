import hypermedia.video.*;
OpenCV opencv;

int w = 240;
int h = 180;
int threshold = 80;
int window = 10;

boolean find=true;

PImage img;

void setup() {

  size( 4*(w+10)+10, 3*(h+10)+10 );

  opencv = new OpenCV( this );
  opencv.capture(w, h);

  println( "Drag mouse inside sketch window to change threshold" );
  println( "Press space bar to record background image" );
}

void draw() {
  colorMode(HSB);
  background(0);
  opencv.read();
  opencv.flip( OpenCV.FLIP_HORIZONTAL );

  image( opencv.image(), 0*(w+10)+10, 0*(h+10)+10 );
  image( opencv.image(OpenCV.GRAY), 0*(w+10)+10, 1*(h+10)+10 );

  img = opencv.image();
  hueFilter(img);
  image( img, 0*(w+10)+10, 2*(h+10)+10 );
  
  img = opencv.image();
  saturationFilter(img, threshold - window, true);
  image( img, 1*(w+10)+10, 0*(h+10)+10 );
  
  img = opencv.image();
  saturationFilter(img, threshold + window, false);
  image( img, 1*(w+10)+10, 1*(h+10)+10 );
  
  img = opencv.image();
  saturationFilter(img, threshold - window, true);
  saturationFilter(img, threshold + window, false);
  image( img, 1*(w+10)+10, 2*(h+10)+10 );
  
  img = opencv.image();
  brightnessFilter(img, threshold - window, true);
  image( img, 2*(w+10)+10, 0*(h+10)+10 );
  
  img = opencv.image();
  brightnessFilter(img, threshold + window, false);
  image( img, 2*(w+10)+10, 1*(h+10)+10 );
  
  img = opencv.image();
  brightnessFilter(img, threshold - window, true);
  brightnessFilter(img, threshold + window, false);
  image( img, 2*(w+10)+10, 2*(h+10)+10 );
}

void mouseDragged() {
  threshold = (int) map(mouseX, 0, width, 0, 255);
  window = (int) map(mouseY, 0, width, 0, 255);
  color c = get(mouseX, mouseY);
  println("thresh\t-> " + threshold + "\t" + window);
  println("color\t-> " + hex(c));
  println("hsb\t-> " + hue(c) + "\t" + saturation(c) + "\t" + brightness(c));
}

void keyPressed() {
  threshold = 80;
  window = 10;
}
