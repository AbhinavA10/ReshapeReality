class Wall {
  float  fX, fY;
  color c;
  int nSize;
  Wall( float fTempX, float fTempY, int tempNsize) {
    fX = fTempX;
    fY = fTempY;
    nSize = tempNsize;
    c = color(random(255), random(255), random(255), random(255));
  }
  void display() {
    fill(c);
    rect( fX, fY, nSize, nSize);
  }
}