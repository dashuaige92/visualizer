color blue = color(0, 0, 255);
color white = color(255, 255, 255);


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
  }
}

//draw ellipses of varying sizes
void variableEllipse(Point current, Point last)
{
   if(current == null || last == null)
  {
    return; 
  }
  float speed = dist(current.x, last.x, current.y, last.y);
  stroke(speed);
  ellipse(current.x, current.y, speed, speed);
}

//draw a line
void continuousLines(Point current, Point last)
{
  if(current == null || last == null)
  {
    return; 
  }
  stroke(255); //will draw white
 
  line(current.x, current.y, last.x, last.y); 
}

//  randomly fills in semi-transparent circles to create a tie dye image
//  size of the circles is dependent on the "cursor" position
//  left = smaller, right = larger
void pointColor(Point current)
{
  if(current == null)
  {
    return; 
  }
  PImage img = loadImage("correcttiedye2.jpg"); 
  int smallPoint = 4;
   int largePoint = 40;
   noStroke();
  
   float pointillize = map(current.x, 0, current.y, smallPoint, largePoint);
   int x = int(random(img.width));
   int y = int(random(img.height));
   color pix = img.get(x, y);
   fill(pix, 128); //128 is the opacity
   ellipse(x, y, pointillize, pointillize);
// ellipse(x, y, 40, 40);
}

//overlay
//  A regular opaque image is stationary. On top of it, there is a translucent 
//  version of the same image which moves with the "cursor"
void overlay(Point current, PImage img)
{
  if(current == null)
  {
    return; 
  }
  
  // PImage img = loadImage("rugby.jpg");
   float offset = 0;
   float offsetY = 0;
   float easing = 0.5;
  
  image(img, 0, 0);  // Display at full opacity
  float dx = (current.x-img.width/2) - offset;
  offset += dx * easing; 
  float dy = (current.y-img.height/2) - offsetY;
  offsetY += dy * easing; 
  tint(255, 126);  // Display at half opacity
  image(img, offset, offsetY); //change 0 to offsetY to move in Y direction also
}

//IN PROGRESS
//squares
void squares(Point current) 
{
 if(current == null)
  {
    return; 
  }
 
  float r1 = map(current.x, 0, 480, 0, 360);
  float r2 = 360-r1;
  
  fill(r1);
  rect(480 + r1, 360, r1, r1);
  
  fill(r2);
  rect(480 - r2, 360, r2, r2);
}


//reset the background at the start of the draw() method in visualizer to have
//the shape follow around the "cursor"
void circleDraw(Point current)
{
  float x = 0;
  float y = 0;
  float easing = 1;

  noStroke();  
  
  float targetX = current.x;
  float dx = targetX - x;
  if(abs(dx) > 1) 
  {
    x += dx * easing;
  }
  
  float targetY = current.y;
  float dy = targetY - y;
  if(abs(dy) > 1) 
  {
    y += dy * easing;
  }
  
  ellipse(x, y, 66, 66);
}

//draw with a square
void squareDraw(Point current)
{
  float x = 0;
  float y = 0;
  float easing = 1;

  noStroke();  
  
  float targetX = current.x;
  float dx = targetX - x;
  if(abs(dx) > 1) 
  {
    x += dx * easing;
  }
  
  float targetY = current.y;
  float dy = targetY - y;
  if(abs(dy) > 1) 
  {
    y += dy * easing;
  }
  
  rect(x, y, 40, 40);
}

//draw with a square with rounded corners
void roundedSquareDraw(Point current)
{
  float x = 0;
  float y = 0;
  float easing = 1;

  noStroke();  
  
  float targetX = current.x;
  float dx = targetX - x;
  if(abs(dx) > 1) 
  {
    x += dx * easing;
  }
  
  float targetY = current.y;
  float dy = targetY - y;
  if(abs(dy) > 1) 
  {
    y += dy * easing;
  }
  
  rect(x, y, 40, 40, 10);
}

//highlighter draw tool
void highlighter(Point current)
{
  float x = 0;
  float y = 0;
  float easing = 1;
  color yellow = color(50,255,255);
  noStroke();  
  
  float targetX = current.x;
  float dx = targetX - x;
  if(abs(dx) > 1) 
  {
    x += dx * easing;
  }
  
  float targetY = current.y;
  float dy = targetY - y;
  if(abs(dy) > 1) 
  {
    y += dy * easing;
  }

  fill(yellow, 180);
  ellipse(x, y, 25, 25);
}


//draw with the American flag
void murica(Point current, PImage img)
{
  if(current == null)
  {
    return; 
  }
  
  float x = 0;
  float y = 0;
  float easing = 1;

  noStroke();  
  
  float targetX = current.x;
  float dx = targetX - x;
  if(abs(dx) > 1) 
  {
    x += dx * easing;
  }
  
  float targetY = current.y;
  float dy = targetY - y;
  if(abs(dy) > 1) 
  {
    y += dy * easing;
  }
  
  image(img, x, y); 
}



