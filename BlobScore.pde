class BlobScore implements Comparable
{
  int blobIndex;
  int gloveIndex;
  float d;

  BlobScore(int blobIndex, int gloveIndex, PImage img, Point current, Point last)
  {
    this.blobIndex = blobIndex;
    this.gloveIndex = gloveIndex;

    Point c = current;
    Point c0 = last;
    // Distance is function of distance from lastPosition and hueDist.
    this.d = hueDist(img.get(c.x, c.y), gloveColors[gloveIndex]);
    if (c0 != null)
    {
      float dPosition = map(abs(c.x - c0.x) + abs(c.y - c0.y), maxDistance / 2, maxDistance, 0, distanceWeight);
      dPosition = dPosition < 0 ? 0 : dPosition;
      dPosition = dPosition > distanceWeight ? distanceWeight : dPosition;
      d += dPosition;
    }
  }

  int compareTo(Object o)
  {
    BlobScore b = (BlobScore) o;
    if (d == b.d)
      return 0;
    return (b.d > d) ? -1 : 1;
  }
}
