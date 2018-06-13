class Wall {
  float  fX, fY;
  color c;
  int nSizeX, nSizeY;
  Wall( float fTempX, float fTempY, int tempNsize,int tempNsize2) {
    fX = fTempX;
    fY = fTempY;
    nSizeX = tempNsize;
    nSizeY = tempNsize2;
    c = color(random(255), random(255), random(255), random(255));
  }
  void display() {
    fill(c);
    rect( fX, fY, nSizeX, nSizeY);
  }
}
