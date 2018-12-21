class WindowMask {
  int nWindowX=0, nWindowY=0;
  int nXBottomRight, nYBottomRight;
  PGraphics mask;
  int nSizeBoxX=200, nSizeBoxY=200;
  int minSizeX = 200, minSizeY=200;
  int dist = 200/2-10;
  private boolean[] edgeLocked = new boolean [4]; // UDLR, 0123.
  // ========================================================== CONSTRUCTOR ==========================================================================
  WindowMask() {
    mask = createGraphics(width, height);
    mask.beginDraw();
    mask.background(255);
    mask.noStroke();
    mask.fill(0);
    mask.rect(nWindowX, nWindowY, nSizeBoxX, nSizeBoxY);
    mask.endDraw();
    nWindowX=(player.nX+player.nSize/2)-nSizeBoxX/2;
    nWindowY=(player.nY+player.nSize/2)-nSizeBoxY/2;
  }
  // ========================================================== KEY PRESS ==========================================================================
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
      nWindowX=(player.nX+player.nSize/2)-nSizeBoxX/2;
      nWindowY=(player.nY+player.nSize/2)-nSizeBoxY/2;
    }
  }
  // ========================================================== CONTINOUS WINDOW ==========================================================================
  void continousWindow() {
    // need to lock such that ex. when moving right and left is locked, dont increase view of right till player is past half of window
    // center point idea doesn't work -- glitches when trying to come back
    // instead implement if distance of edge_moving_away_from to player_edge_closest, > (200/2-10), --> move stuff
    if (keyCode == UP && getDistBWEdges("down")>dist) {
      if (edgeLocked[EDGE_UP] && edgeLocked[EDGE_DOWN]);
      else if (edgeLocked[EDGE_UP]) {
        nSizeBoxY-=5; // limit at end
      } else if (edgeLocked[EDGE_DOWN]) {
        if (nWindowY<=0) nWindowY = 0;
        else {
          nWindowY-=5;
          nSizeBoxY+=5;
        }
      } else {
        if (nWindowY<=0) nWindowY = 0;
        else nWindowY-=5;
      }
    }// finish up code

    if (keyCode == DOWN && getDistBWEdges("up")>dist) {  
      if (edgeLocked[EDGE_UP] && edgeLocked[EDGE_DOWN]);
      else if (edgeLocked[EDGE_UP]) {
        if ((nWindowY+nSizeBoxY)>=height) {
          nWindowY = height - nSizeBoxY;
        } else {
          nSizeBoxY+=5;
        }
      } else if (edgeLocked[EDGE_DOWN]) { // fix this one
        if (nSizeBoxY-5>minSizeY) { 
          nWindowY+=5;
          nSizeBoxY-=5;
        }
      } else {
        if ((nWindowY+nSizeBoxY)>=height) {
          nWindowY = height - nSizeBoxY;
        } else {
          nWindowY+=5;
        }
      }
    }

    if (keyCode == RIGHT &&getDistBWEdges("left")>dist) {
      /*
      SUDO CODE        
       if the right is locked and left is locked, then don't dont change anything
       if the right is locked and left is unlocked, then increase nX and decrease boxsize
       if right is unlocked and left is locked, then keep nX, increase boxsize
       -----if nX+boxsize is bigger than width, then nx = width - boxsize
       if right is unlocked and left is also unlocked, then increase nX     
       */
      if (edgeLocked[EDGE_RIGHT]) {
        if (!edgeLocked[EDGE_LEFT] && nSizeBoxX-5>minSizeX) { 
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

    if (keyCode == LEFT && getDistBWEdges("right")>dist) {
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
    if (nSizeBoxX<=minSizeX) nSizeBoxX =minSizeX; // limiting the size of the box to its min
    if (nSizeBoxY<=minSizeY) nSizeBoxY =minSizeY;
  }
  // ========================================================== APPLY MASK ==========================================================================
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
  // ========================================================== GET CENTER POINT ==========================================================================
  PVector getCenterPoint() {
    return new PVector((nWindowX+nSizeBoxX/2), (nWindowY+nSizeBoxY/2) );
  }
  // ========================================================== GET DISTANCE BETWEEN EDGES ==========================================================================
  int getDistBWEdges(String edge) {
    int dist = 0;
    if (edge.equals("left")) {
      dist = player.nX-nWindowX;
    } else if (edge.equals("right")) {
      dist = nWindowX+nSizeBoxX-(player.nX+player.nSize);
    } else if (edge.equals("up")) {
      dist = player.nY-nWindowY;
    } else if (edge.equals("down")) {
      dist = nWindowY+nSizeBoxY-(player.nY+player.nSize);
    }
    return dist;
  }
}
