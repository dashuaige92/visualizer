color blue = color(0, 0, 255);
color white = color(255, 255, 255);

PImage dot = new PImage(1, 1);

void loadTemplates()
{
  dot.set(0, 0, white);
}

void paint(PImage dest, int x, int y, PImage src) 
{
  dest.set(x - src.width / 2, y - src.height / 2, src);
}

void variableEllipse(PVector current, PVector last) {
  float speed = dist(current.x, last.x, current.y, last.y);
  stroke(speed);
  ellipse(current.x, current.y, speed, speed);
}
