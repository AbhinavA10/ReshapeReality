class WindowMask {
  int nWindowX=0, nWindowY=0;
  PGraphics mask;
  int nSizeBoxX=200, nSizeBoxY=200;
  int minSizeX = 200, minSizeY=200;
  boolean[] edgeLocked = new boolean [4]; // UDLR, 0123.
  WindowMask() {
    mask = createGraphics(width, height);
    mask.beginDraw();
    mask.background(255);
    mask.noStroke();
    mask.fill(0);
    mask.rect(nWindowX, nWindowY, nSizeBoxX, nSizeBoxY);
    mask.endDraw();
    nWindowX=(player.nX+nPlayerSize/2)-nSizeBoxX/2;
    nWindowY=(player.nY+nPlayerSize/2)-nSizeBoxY/2;
  }
  void keyPress() {
    if (key == 'w' || key == 'W') edgeLocked[EDGE_UP] = true;
    if (key == 's' || key == 'S') edgeLocked[EDGE_DOWN] = true;
    if (key == 'a' || key == 'A') edgeLocked[EDGE_LEFT] = true;
    if (key == 'd' || key == 'D') edgeLocked[EDGE_RIGHT] = true;
    if (key=='r'||key=='R') {
      for (int i = 0; i<edgeLocked.length; i++) {
        edgeLocked[i]=false;
      }
      nSizeBoxX=200; 
      nSizeBoxY=200;
      nWindowX=(player.nX+nPlayerSize/2)-nSizeBoxX/2;
      nWindowY=(player.nY+nPlayerSize/2)-nSizeBoxY/2;
    }
  }
  void continousWindow() {
// right and down move when you move towards them even though they are locked
    // fix down
    if (keyCode == UP) {
      if (edgeLocked[EDGE_UP]) {
        if (!edgeLocked[EDGE_DOWN]) { 
          nSizeBoxY-=5;
        }
      } else {
        if (edgeLocked[EDGE_DOWN]) {
          if (nWindowY<=0) nWindowY = 0;
          else {
            nWindowY-=5;
            nSizeBoxY+=5;
          }
        } else {
          if (nWindowY<=0) nWindowY = 0;
          else nWindowY-=5;
        }
      }
    }
    if (keyCode == DOWN) {   
      if (edgeLocked[EDGE_DOWN]) {
        if (!edgeLocked[EDGE_UP]) { 
          nWindowY+=5;
          nSizeBoxY-=5;
        }
      } else {
        if (edgeLocked[EDGE_UP]) {
          if ((nWindowY+nSizeBoxY)>=height) {
            nWindowY = height - nSizeBoxY;
          } else {
            nSizeBoxY+=5;
          }
        } else {
          if ((nWindowY+nSizeBoxY)>=height) {
            nWindowY = height - nSizeBoxY;
          } else {
            nWindowY+=5;
          }
        }
      }
    }
    if (keyCode == RIGHT) {
      /*
      SUDO CODE        
       if the right is locked and left is locked, then don't dont change anything
       if the right is locked and left is unlocked, then increase nX and decrease boxsize
       if right is unlocked and left is locked, then keep nX, increase boxsize
       -----if nX+boxsize is bigger than width, then nx = width - boxsize
       if right is unlocked and left is also unlocked, then increase nX     
       */
      if (edgeLocked[EDGE_RIGHT]) {
        if (!edgeLocked[EDGE_LEFT]) { 
          nWindowX+=5;
          nSizeBoxX-=5;
        }
      } else {
        if (edgeLocked[EDGE_LEFT]) {
          if ((nWindowX+nSizeBoxX)>=width) {
            nWindowX = width - nSizeBoxX;
          } else {
            nSizeBoxX+=5;
          }
        } else {
          if ((nWindowX+nSizeBoxX)>=width) {
            nWindowX = width - nSizeBoxX;
          } else {
            nWindowX+=5;
          }
        }
      }
    }
    if (keyCode == LEFT) {
      if (edgeLocked[EDGE_LEFT]) {
        if (!edgeLocked[EDGE_RIGHT]) {
          nSizeBoxX-=5;
        }
      } else {
        if (edgeLocked[EDGE_RIGHT]) {
          if (nWindowX<=0) {
            nWindowX = 0;
          } else {
            nWindowX-=5;
            nSizeBoxX+=5;
          }
        } else {
          if (nWindowX<=0) {
            nWindowX = 0;
          } else {
            nWindowX-=5;
          }
        }
      }
    }
    if (nSizeBoxX<=minSizeX) nSizeBoxX =minSizeX;
    if (nSizeBoxY<=minSizeY) nSizeBoxY =minSizeY;
  }

  void applyMask() {
    nXBottomRight = nWindowX+nSizeBoxX;
    nYBottomRight=nWindowY+nSizeBoxY;
    mask.beginDraw();
    mask.background(0);
    mask.noStroke();
    mask.fill(255);
    mask.rect(nWindowX, nWindowY, nSizeBoxX, nSizeBoxY);
    mask.endDraw();
    println("      TOPLeft ("+ nWindowX+", "+ nWindowY+")       BottomRight ("+ nXBottomRight+", "+ nYBottomRight+")");
    print("   UP:"+edgeLocked[EDGE_UP]+"   DOWN:"+edgeLocked[EDGE_DOWN]+"  LEFT:"+edgeLocked[EDGE_LEFT]+"   RIGHT:"+edgeLocked[EDGE_RIGHT]);
    //println states of locked edges
  }
}
