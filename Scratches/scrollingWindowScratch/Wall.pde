boolean bDrawn = false;
int nLevel = 1;
ArrayList <Wall> alWall = new ArrayList<Wall>();
int i;
class Wall {
  float  fX, fY;
  // color c;
  PImage imgWall;
  Wall( float fTempX, float fTempY) {
    fX = fTempX;
    fY = fTempY;
    imgWall=loadImage("Box_give-up_8Bit_2.png");
  }
  void display() {
    image(imgWall, fX, fY);
    // fill(c);
    // rect( fX, fY, 50, 50);
  }
}