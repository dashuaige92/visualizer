// Look for the pixel whose color is closest to c0 in src
// Returns the index in src.pixels[]
int matchColor(PImage src, color c0, int sw, int sh) {
  int closest_idx = -1;
  float closest_dist = MAX_FLOAT;

  src.loadPixels();
  for (int i = 0; i < sw * sh; i++) {
    color c = src.pixels[i];
    float d = dist(
        hue(c), hue(c0),
        saturation(c), saturation(c0),
        brightness(c), brightness(c0)
        );
    if (d < closest_dist) {
      closest_dist = d;
      closest_idx = i;
    }
  }

  return closest_idx;
}
