//usage: fg is the image you want to subtract bg from. 
PImage subtract_background(PImage fg, PImage bg)
{
  fg.loadPixels();
  bg.loadPixels();
  for(int x = 0; x < bg.pixels.length; x++)
  {
    color fgColor = fg.pixels[x];
    color bgColor = bg.pixels[x];
  //  float diff = saturation(fgColor) - saturation(bgColor);
    /*
    float r1 = red(fgColor);
    float g1 = green(fgColor);
    float b1 = blue(fgColor);
    float r2 = red(bgColor);
    float g2 = green(bgColor);
    float b2 = blue(bgColor);
    
    float diff = dist(r1, g1, b1, r2, g2, b2);
    */
    float diff = compute_difference(fgColor, bgColor);
    if(diff > 50)
    {
      //System.out.println(diff);
      fg.pixels[x] = fgColor;
    }
    else
    {
      fg.pixels[x] = color(0, 0, 0); 
    }
   
  }
  
  fg.updatePixels();
  return fg;
}

float compute_difference(color fgpxl, color bgpxl)
{
   
   float satpart = abs(saturation(fgpxl) - saturation(bgpxl));
   
   float r1 = red(fgpxl);
   float g1 = green(fgpxl);
   float b1 = blue(fgpxl);
   float r2 = red(bgpxl);
   float g2 = green(bgpxl);
   float b2 = blue(bgpxl);
    
   float colorpart = dist(r1, g1, b1, r2, g2, b2);
  
  
   return satpart + colorpart;
}
