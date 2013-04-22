
// Get X coordinate from index to pixels[]
int getX(int index, PImage p) {
  return index % p.width;
}

// Get Y coordinate from index to pixels[]
int getY(int index, PImage p) {
  return index / p.width;
}
