class Box {
  float nX, nY, nSize; 
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
    // the "collision detection" of the player with edges of the viewWindow
    if (nY<=windowmask.fWindowY) nY = windowmask.fWindowY;
    if (nX <= windowmask.fWindowX) nX = windowmask.fWindowX;
    if (nY+nSize>=windowmask.fWindowY+windowmask.fSizeBoxY) nY = windowmask.fWindowY+windowmask.fSizeBoxY-nSize;

    if (nX+nSize>=windowmask.fWindowX+windowmask.fSizeBoxX) nX = windowmask.fWindowX+windowmask.fSizeBoxX-nSize;
  }
  // ========================================================== GET CENTER POINT ==========================================================================
  PVector getCenterPoint() {
    return new PVector((nX+nSize/2), (nY+nSize/2) );
  }
}
