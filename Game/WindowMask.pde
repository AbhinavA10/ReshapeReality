class WindowMask {
  float fWindowX=0, fWindowY=0;
  float fXBottomRight, fYBottomRight;
  PGraphics imgMask;
  float fSizeBoxX=200, fSizeBoxY=200;

  private boolean[] edgeLocked = new boolean [4]; // UDLR, 0123.
  private PVector[] vLockPos = new PVector[2];

  final float MIN_SIZE_X = 200, MIN_SIZE_Y=200;
  final float MIN_DIST_BW_EDGES = 200/2-20;
  static final int EDGE_UP = 0, EDGE_DOWN =1, EDGE_LEFT =2, EDGE_RIGHT =3; // for edge Locked array
  static final int TOP_LEFT_CORNER =0, BOTT_RIGHT_CORNER =1; // for vLockPos array
  // ========================================================== CONSTRUCTOR ==========================================================================
  WindowMask() {
    imgMask = createGraphics(width, height);
    imgMask.beginDraw();
    imgMask.background(255);
    imgMask.noStroke();
    imgMask.fill(0);
    imgMask.rect(fWindowX, fWindowY, fSizeBoxX, fSizeBoxY);
    imgMask.endDraw();
    fWindowX=(sprHero.fX+sprHero.img.width/2)-fSizeBoxX/2;
    fWindowY=(sprHero.fY+sprHero.img.height/2)-fSizeBoxY/2;
    vLockPos[TOP_LEFT_CORNER] = new PVector(0, 0);
    vLockPos[EDGE_DOWN] = new PVector(0, 0);
  }

  // ========================================================== DRAW IMG ==========================================================================
  // the masking image has one transparent square, and everything else fully opaque black
  void updateImgMask() {
    fXBottomRight = fWindowX+fSizeBoxX;
    fYBottomRight=fWindowY+fSizeBoxY;
    continousWindow();
    imgMask.beginDraw();
    imgMask.noStroke();
    imgMask.background(0, 0, 0, 0); // refersh the image by drawing a transparent background

    imgMask.fill(10); // black everything else
    imgMask.rect(0, 0, fWindowX, height);
    imgMask.rect(fWindowX+fSizeBoxX, 0, width, height);
    imgMask.rect(fWindowX, 0, fWindowX+fSizeBoxX, fWindowY);
    imgMask.rect(fWindowX, fWindowY+fSizeBoxY, fWindowX+fSizeBoxX, height);


    imgMask.fill(255, 255, 255, 0); // the square will be filled white    
    imgMask.rect(fWindowX, fWindowY, fSizeBoxX, fSizeBoxY);
    /*
    
     The mask will look like the following ----- = means black space, | is to represent a new rectangle from above
     =======|=======|========
     =======|=======|========
     =======|=======|========
     =======|       |========
     =======|       |========
     =======|       |========
     =======|=======|========
     =======|=======|========
     =======|=======|========     
     */

    imgMask.endDraw();
    println("      TOPLeft ("+ fWindowX+", "+ fWindowY+")       BottomRight ("+ fXBottomRight+", "+ fYBottomRight+")");
    print("   UP:"+edgeLocked[EDGE_UP]+"   DOWN:"+edgeLocked[EDGE_DOWN]+"  LEFT:"+edgeLocked[EDGE_LEFT]+"   RIGHT:"+edgeLocked[EDGE_RIGHT]);
    //println states of locked edges
  }
  // ========================================================== KEY PRESS ==========================================================================
  void keyPress() {
    if (key == 'w' || key == 'W') { 
      edgeLocked[EDGE_UP] = true;
      vLockPos[TOP_LEFT_CORNER].x = fWindowX;
      vLockPos[TOP_LEFT_CORNER].y = fWindowY;
      vLockPos[BOTT_RIGHT_CORNER].x = fWindowX+MIN_SIZE_X;
      vLockPos[BOTT_RIGHT_CORNER].y = fWindowY+MIN_SIZE_Y;
    }
    if (key == 's' || key == 'S') {
      edgeLocked[EDGE_DOWN] = true;
      vLockPos[TOP_LEFT_CORNER].x = fWindowX;
      vLockPos[TOP_LEFT_CORNER].y = fWindowY;
      vLockPos[BOTT_RIGHT_CORNER].x = fWindowX+MIN_SIZE_X;
      vLockPos[BOTT_RIGHT_CORNER].y = fWindowY+MIN_SIZE_Y;
    }
    if (key == 'a' || key == 'A') {
      edgeLocked[EDGE_LEFT] = true;
      vLockPos[TOP_LEFT_CORNER].x = fWindowX;
      vLockPos[TOP_LEFT_CORNER].y = fWindowY;
      vLockPos[BOTT_RIGHT_CORNER].x = fWindowX+MIN_SIZE_X;
      vLockPos[BOTT_RIGHT_CORNER].y = fWindowY+MIN_SIZE_Y;
    }
    if (key == 'd' || key == 'D') {
      edgeLocked[EDGE_RIGHT] = true;
      vLockPos[TOP_LEFT_CORNER].x = fWindowX;
      vLockPos[TOP_LEFT_CORNER].y = fWindowY;
      vLockPos[BOTT_RIGHT_CORNER].x = fWindowX+MIN_SIZE_X;
      vLockPos[BOTT_RIGHT_CORNER].y = fWindowY+MIN_SIZE_Y;
    }
    if (key=='r'||key=='R') {
      resetWindow();
    }
  }
  // ========================================================== CONTINOUS WINDOW ==========================================================================

  // add checks at bounds of screen

  void continousWindow() {

    sprHero.refreshCoord();
    // need to lock such that ex. when moving right and left is locked, dont increase view of right till player is past half of window
    // center point idea doesn't work -- glitches when trying to come back
    // instead implement if distance of edge_moving_away_from to player_edge_closest, > (200/2-10), --> move stuff
    if (edgeLocked[EDGE_UP]&&edgeLocked[EDGE_DOWN]) { // do nothing
    } else if (edgeLocked[EDGE_UP]) {
      // since up is locked we need to keep the distance between the bottom edge of the player, and bottom edge of the window 90 if possible
      float dist = getDistBWEdges("down");
      if (dist!=MIN_DIST_BW_EDGES) {
        //fWindowY= vLockPos[TOP_LEFT_CORNER].y;  // basically what we are doing
        fSizeBoxY = sprHero.img.height+MIN_DIST_BW_EDGES+(sprHero.fY-fWindowY);
        fSizeBoxY = constrain(fSizeBoxY, MIN_SIZE_Y, height-fWindowY);
      }
    } else if (edgeLocked[EDGE_DOWN]) {
      // down is locked so distance between top edge and player needs to be 90, 
      float dist = getDistBWEdges("up");
      if (dist<MIN_DIST_BW_EDGES) { // player is moving up, while the bottom edge is locked
        fWindowY=sprHero.fY-MIN_DIST_BW_EDGES;
        fWindowY = constrain(fWindowY, 0, height-MIN_SIZE_Y);
        fSizeBoxY = vLockPos[BOTT_RIGHT_CORNER].y-fWindowY;
      } else if (dist>MIN_DIST_BW_EDGES) {
        float fYBefore = fWindowY; // need to save the old y location of the window, similar to gravity in the actual game
        fWindowY = sprHero.fY-MIN_DIST_BW_EDGES; // the possible new value
        if ((vLockPos[BOTT_RIGHT_CORNER].y-fWindowY)<MIN_SIZE_Y) fWindowY=fYBefore; // if the size of the window would be less the min size (bottom edge - top edge = size), then set the y value back to the old location 
        fSizeBoxY = vLockPos[BOTT_RIGHT_CORNER].y-fWindowY;
      }
    } else { // up and down free to move
      fWindowY = sprHero.fY-MIN_DIST_BW_EDGES;
      fWindowY = constrain(fWindowY, 0, height-MIN_SIZE_Y);
    }
    if (edgeLocked[EDGE_RIGHT]&&edgeLocked[EDGE_LEFT]) {
    } else if (edgeLocked[EDGE_LEFT]) {
      float dist = getDistBWEdges("right");
      if (dist!=MIN_DIST_BW_EDGES) {
        //fWindowX= vLockPos[TOP_LEFT_CORNER].x; // basically what we are doing
        fSizeBoxX = sprHero.img.width+MIN_DIST_BW_EDGES+(sprHero.fX-fWindowX);
        fSizeBoxX = constrain(fSizeBoxX, MIN_SIZE_X, width-fWindowX);
      }
    } else if (edgeLocked[EDGE_RIGHT]) {
      // right is locked so distance between left edge and player needs to be 90, 
      float dist = getDistBWEdges("left");

      if (dist<MIN_DIST_BW_EDGES) {
        fWindowX=sprHero.fX-MIN_DIST_BW_EDGES;
        fWindowX = constrain(fWindowX, 0, width-MIN_SIZE_X);
        fSizeBoxX = vLockPos[BOTT_RIGHT_CORNER].x-fWindowX;
      } else if (dist>MIN_DIST_BW_EDGES) {
        float fXBefore = fWindowX; // need to save the old y location of the window, similar to gravity in the actual game
        fWindowX = sprHero.fX-MIN_DIST_BW_EDGES; // the possible new value
        if ((vLockPos[BOTT_RIGHT_CORNER].x-fWindowX)<MIN_SIZE_X) fWindowX=fXBefore; // if the size of the window would be less the min size (bottom edge - top edge = size), then set the y value back to the old location 
        fSizeBoxX = vLockPos[BOTT_RIGHT_CORNER].x-fWindowX;
      }
    } else {
      fWindowX = sprHero.fX-MIN_DIST_BW_EDGES;
      fWindowX = constrain(fWindowX, 0, width-MIN_SIZE_Y);
    }

    if (fSizeBoxX<=MIN_SIZE_X) fSizeBoxX =MIN_SIZE_X; // limiting the size of the box to its min
    if (fSizeBoxY<=MIN_SIZE_Y) fSizeBoxY =MIN_SIZE_Y;
  }
  // ========================================================== GET DISTANCE BETWEEN EDGES ==========================================================================
  float getDistBWEdges(String edge) {
    float dist = 0;
    if (edge.equals("left")) {
      dist = sprHero.fX-fWindowX;
    } else if (edge.equals("right")) {
      dist = fWindowX+fSizeBoxX-(sprHero.fX+sprHero.img.width);
    } else if (edge.equals("up")) {
      dist = sprHero.fY-fWindowY;
    } else if (edge.equals("down")) {
      dist = fWindowY+fSizeBoxY-(sprHero.fY+sprHero.img.height);
    }
    return dist;
  }
  // ========================================================== RESET WINDOW ==========================================================================
  // to reset Window every level
  void resetWindow() {

    for (int i = 0; i<edgeLocked.length; i++) {
      edgeLocked[i]=false;
    }
    fSizeBoxX=200; 
    fSizeBoxY=200;
    fWindowX=(sprHero.fX+sprHero.img.width/2)-fSizeBoxX/2;
    fWindowY=(sprHero.fY+sprHero.img.height/2)-fSizeBoxY/2;
    vLockPos[TOP_LEFT_CORNER].set(0, 0);
    vLockPos[BOTT_RIGHT_CORNER].set(0, 0);
  }
}
