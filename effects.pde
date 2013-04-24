color blue = color(0, 0, 255);
color white = color(255, 255, 255);

void paint(PImage dest, int x, int y, PImage src) 
{
  dest.set(x - src.width / 2, y - src.height / 2, src);
}

//draw ellipses that whose sizes depend on speed of "cursor"
void variableEllipse(PVector current, PVector last)
{
  float speed = dist(current.x, last.x, current.y, last.y);
  stroke(speed);
  ellipse(current.x, current.y, speed, speed);
}

//draw a line
void continuousLines(Point current, Point last)
{
  stroke(255); //will draw white
  System.out.println("LINE FROM: " + current.x + "," + current.y + " TO " + last.x + "," + last.y);
  line(current.x, current.y, last.x, last.y); 
}

//will change to tiedye most likely
void pointFlag(PVector current)
{
   PImage img = loadImage("flag.jpg");
   int smallPoint = 4;
   int largePoint = 40;
   imageMode(CENTER);
   noStroke();
  
   float pointillize = map(current.x, 0, current.y, smallPoint, largePoint);
   int x = int(random(img.width));
   int y = int(random(img.height));
   color pix = img.get(x, y);
   fill(pix, 128); //128 is the opacity
 //  ellipse(x, y, pointillize, pointillize);
 ellipse(x, y, 40, 40);
}
