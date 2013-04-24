// Draw markers for tracked fingers.
void drawMarkers(PImage img)
{
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
