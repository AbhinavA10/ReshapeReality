//https://stackoverflow.com/questions/21534545/draw-opposite-of-shape-in-papplet
//https://funprogramming.org/143-Using-PGraphics-as-layers-in-Processing.html
PGraphics mask, filler;
int nX=0, nY=0;
//TODO
/*
add vector variables instead
add player in middle so that window unlocks to average area around player
add background image for better visualization
*/
// PVector vPos = new PVector(0,0);  
int nSizeBoxX=200, nSizeBoxY=200;
static final int STANDARD_BOX_SIZE = 200;
boolean[] edgeLocked = new boolean [4]; // UDLR, 0123.
static final int EDGE_UP = 0, EDGE_DOWN =1, EDGE_LEFT =2, EDGE_RIGHT =3; 
int nXBottomRight, nYBottomRight; // for debugging
//top left corner is (0,0)
void setup() {
  size(700, 500);

  background(255);

  //init both PGraphics
  mask = createGraphics(width, height);
  filler = createGraphics(width, height);

  // draw a circle as a mask
  mask.beginDraw();
  mask.background(255);
  mask.noStroke();
  mask.fill(0);
  mask.rect(nX, nY, nSizeBoxX, nSizeBoxY);
  mask.endDraw();
}

void draw() {
  nXBottomRight = nX+nSizeBoxX;
  nYBottomRight=nY+nSizeBoxY;
  println("TOPRight ("+ nX+", "+ nY+")       BottomRight ("+ nXBottomRight+", "+ nYBottomRight+")");
  //println states of locked edges

  background(#215018); // portion of the mask that is blocked out (non-visible part of the game)

  //dynamiaclly draw random rects
  filler.beginDraw();
  filler.noStroke();
  filler.fill(random(255), random(255), random(255));
  filler.rect(random(width), random(height), random(5, 40), random(5, 40));
  filler.endDraw();

  // get an imge out ofthis...
  PImage temp = filler.get();

  //mask image
  temp.mask(mask);
  rectWindowMask();
  //dispay it
  image(temp, 0, 0);
  if (keyPressed) {
    checkKeysContinious();
  }
}
void checkKeysContinious() {
  // fix down
  if (keyCode == UP) {
    if (edgeLocked[EDGE_UP]) {
      if (!edgeLocked[EDGE_DOWN]) { 
        nSizeBoxY-=5;
      }
    } else {
      if (edgeLocked[EDGE_DOWN]) {
        if (nY<=0) nY = 0;
        else {
          nY-=5;
          nSizeBoxY+=5;
        }
      } else {
        if (nY<=0) nY = 0;
        else nY-=5;
      }
    }
  }
  if (keyCode == DOWN) {    
    if (edgeLocked[EDGE_DOWN]) {
      if (!edgeLocked[EDGE_UP]) { 
        nY+=5;
        nSizeBoxY-=5;
      }
    } else {
      if (edgeLocked[EDGE_UP]) {
        if ((nY+nSizeBoxY)>=height) {
          nY = height - nSizeBoxY;
        } else {
          nSizeBoxY+=5;
        }
      } else {
        if ((nY+nSizeBoxY)>=height) {
          nY = height - nSizeBoxY;
        } else {
          nY+=5;
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
        nX+=5;
        nSizeBoxX-=5;
      }
    } else {
      if (edgeLocked[EDGE_LEFT]) {
        if ((nX+nSizeBoxX)>=width) {
          nX = width - nSizeBoxX;
        } else {
          nSizeBoxX+=5;
        }
      } else {
        if ((nX+nSizeBoxX)>=width) {
          nX = width - nSizeBoxX;
        } else {
          nX+=5;
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
        if (nX<=0) {
          nX = 0;
        } else {
          nX-=5;
          nSizeBoxX+=5;
        }
      } else {
        if (nX<=0) {
          nX = 0;
        } else {
          nX-=5;
        }
      }
    }
  }
}
void keyPressed() {
  if (key == 'a' || key == 'A') {
    if (edgeLocked[EDGE_LEFT]) {
      nX = nXBottomRight-STANDARD_BOX_SIZE;
      nSizeBoxX =STANDARD_BOX_SIZE;
      edgeLocked[EDGE_LEFT] = false;
    } else 
    edgeLocked[EDGE_LEFT] = true;
  }
  if (key == 'd' || key == 'D') {
    if (edgeLocked[EDGE_RIGHT]) {
      nSizeBoxX =STANDARD_BOX_SIZE;
      edgeLocked[EDGE_RIGHT] = false;
    } else 
    edgeLocked[EDGE_RIGHT] = true;
  }

  if (key == 'w' || key == 'W') {
    if (edgeLocked[EDGE_UP]) { 
      nY = nYBottomRight-STANDARD_BOX_SIZE;
      nSizeBoxY =STANDARD_BOX_SIZE;
      edgeLocked[EDGE_UP] = false;
    } else 
    edgeLocked[EDGE_UP] = true;
  }
  if (key == 's' || key == 'S') {
    if (edgeLocked[EDGE_DOWN]) {
      nSizeBoxY =STANDARD_BOX_SIZE;
      edgeLocked[EDGE_DOWN] = false;
    } else 
    edgeLocked[EDGE_DOWN] = true;
  }
}
void rectWindowMask() {
  mask.beginDraw();
  mask.background(0);
  mask.noStroke();
  mask.fill(255);
  mask.rect(nX, nY, nSizeBoxX, nSizeBoxY);
  mask.endDraw();
}
