class Box {
  int nX, nY, nSize; 
  // ========================================================== CONSTRUCTOR ==========================================================================
  Box(int x, int y, int w, int h) {
    nX = x;
    nY = y;
    nSize=w;
  }
  // ========================================================== SHOW ==========================================================================
  void show() {

    rect(nX, nY, nSize, nSize);
  }
  // ========================================================== CONTINOUS PLAYER ==========================================================================
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
    if (nY<=windowmask.nWindowY) nY = windowmask.nWindowY;
    if (nX <= windowmask.nWindowX) nX = windowmask.nWindowX;
    if (nY+nSize>=windowmask.nWindowY+windowmask.nSizeBoxY) nY = windowmask.nWindowY+windowmask.nSizeBoxY-nSize;

    if (nX+nSize>=windowmask.nWindowX+windowmask.nSizeBoxX) nX = windowmask.nWindowX+windowmask.nSizeBoxX-nSize;
  }
  // ========================================================== GET CENTER POINT ==========================================================================
  PVector getCenterPoint() {
    return new PVector((nX+nSize/2), (nY+nSize/2) );
  }
}
