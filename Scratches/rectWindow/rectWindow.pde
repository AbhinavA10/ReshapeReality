//https://stackoverflow.com/questions/21534545/draw-opposite-of-shape-in-papplet
//https://funprogramming.org/143-Using-PGraphics-as-layers-in-Processing.html
PGraphics mask;
PImage imgBg;
int nWindowX=0, nWindowY=0;
int nPlayerX=100, nPlayerY=100;

int nSizeBoxX=200, nSizeBoxY=200;
static final int STANDARD_BOX_SIZE = 200;
boolean[] edgeLocked = new boolean [4]; // UDLR, 0123.
static final int EDGE_UP = 0, EDGE_DOWN =1, EDGE_LEFT =2, EDGE_RIGHT =3; 
int nXBottomRight, nYBottomRight; // for debugging
//top left corner is (0,0)
int nPlayerSize=20;
void setup() {
  size(700, 500);

  background(255);

  mask = createGraphics(width, height);
  mask.beginDraw();
  mask.background(255);
  mask.noStroke();
  mask.fill(0);
  mask.rect(nWindowX, nWindowY, nSizeBoxX, nSizeBoxY);
  mask.endDraw();
  imgBg = loadImage("bg.png");
  nPlayerX = width/2-nPlayerSize/2;
  nPlayerY = height/2-nPlayerSize/2;
  nWindowX=(nPlayerX+nPlayerSize/2)-nSizeBoxX/2;
  nWindowY=(nPlayerY+nPlayerSize/2)-nSizeBoxY/2;
}

void draw() {
  nXBottomRight = nWindowX+nSizeBoxX;
  nYBottomRight=nWindowY+nSizeBoxY;
  background(#215018); // portion of the mask that is blocked out (non-visible part of the game)
  //mask image
  imgBg.mask(mask);
  rectWindowMask();
  //dispay it 
  image(imgBg, 0, 0);
  rect(nPlayerX, nPlayerY, 20, 20);

  println("      TOPLeft ("+ nWindowX+", "+ nWindowY+")       BottomRight ("+ nXBottomRight+", "+ nYBottomRight+")");
  print("   UP:"+edgeLocked[EDGE_UP]+"   DOWN:"+edgeLocked[EDGE_DOWN]+"  LEFT:"+edgeLocked[EDGE_LEFT]+"   RIGHT:"+edgeLocked[EDGE_RIGHT]);
  //println states of locked edges

  if (keyPressed) {
    checkKeysContinious();
  }
}
void rectWindowMask() {
  mask.beginDraw();
  mask.background(0);
  mask.noStroke();
  mask.fill(255);
  mask.rect(nWindowX, nWindowY, nSizeBoxX, nSizeBoxY);
  mask.endDraw();
}
void checkKeysContinious() {
  // fix down
  if (keyCode == UP) {
    nPlayerY-=5;
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
    nPlayerY+=5; 
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
    nPlayerX+=5;
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
    nPlayerX-=5;
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
  if (nSizeBoxX<=0) nSizeBoxX =0;
  if (nSizeBoxY<=0) nSizeBoxY =0;
}
void keyPressed() {
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
    nWindowX=(nPlayerX+nPlayerSize/2)-nSizeBoxX/2;
    nWindowY=(nPlayerY+nPlayerSize/2)-nSizeBoxY/2;
  }
}
