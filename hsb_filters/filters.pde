void hueFilter(PImage img) 
{
  img.loadPixels();
  for (int i = 0; i < img.width * img.height; i++) {
    img.pixels[i] = color(hue(img.pixels[i]), 255, 255);
  }
  img.updatePixels();
}

void satImage(PImage img) 
{
  img.loadPixels();
  for (int i = 0; i < img.width * img.height; i++) {
    img.pixels[i] = color(255, saturation(img.pixels[i]), 255);
  }
  img.updatePixels();
}

void brightImage(PImage img) 
{
  img.loadPixels();
  for (int i = 0; i < img.width * img.height; i++) {
    img.pixels[i] = color(255, 255, brightness(img.pixels[i]));
  }
  img.updatePixels();
}

void saturationFilter(PImage img, float threshold, boolean highPass) {
  img.loadPixels();
  for (int i = 0; i < img.width * img.height; i++) {
    if (highPass) {
      if (saturation(img.pixels[i]) <= threshold)
        img.pixels[i] = color(0, 0, 0);
    }
    else {
      if (saturation(img.pixels[i]) >= threshold)
        img.pixels[i] = color(0, 0, 0);
    }
  }
  img.updatePixels();  
}

void brightnessFilter(PImage img, float threshold, boolean highPass) {
  img.loadPixels();
  for (int i = 0; i < img.width * img.height; i++) {
    if (highPass) {
      if (brightness(img.pixels[i]) <= threshold)
        img.pixels[i] = color(0, 0, 0);
    }
    else {
      if (brightness(img.pixels[i]) >= threshold)
        img.pixels[i] = color(0, 0, 0);
    }
  }
  img.updatePixels();  
}
