class Box {
  int nX, nY, nSize; 


  Box(int x, int y, int w, int h) {
    nX = x;
    nY = y;
    nSize=w;
  }
  void show() {

    rect(nX, nY, 20, 20);
  }
  void continousPlayer() {
    if (keyCode == UP) {
      nY-=5;
    }
    if (keyCode == DOWN) {   
      nY+=5;
    }
    if (keyCode == RIGHT) {
      nX+=5;
    }
    if (keyCode == LEFT) {
      nX-=5;
    }
  }
}
