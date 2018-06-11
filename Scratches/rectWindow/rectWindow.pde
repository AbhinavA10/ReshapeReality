//https://stackoverflow.com/questions/21534545/draw-opposite-of-shape-in-papplet
//https://funprogramming.org/143-Using-PGraphics-as-layers-in-Processing.html
PGraphics mask, filler;
int nX=0, nY=0;
int nSizeBoxX=200, nSizeBoxY=200;
boolean[] edgeLocked = new boolean [4]; // UDLR, 0123.

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
  background(255);

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

    if (keyCode == UP)nY-=5;
    if (keyCode == DOWN)nY+=5;
    if (keyCode == RIGHT) {
      if (!edgeLocked[2]&& (nX+nSizeBoxX)>=width) {
        nX = width-nSizeBoxX;
      } else if (edgeLocked[2]) nSizeBoxX+=5;
      else {
        if (edgeLocked[3])nSizeBoxX+=5;
        else nX+=5;
      }
    }
    if (keyCode == LEFT) {
      if (!edgeLocked[3]&& (nX<=0)) {
        nX = 0;
      } else if (edgeLocked[3]) {
        nSizeBoxX+=5;
        nX-=5;
      } else {
        if (edgeLocked[2])nSizeBoxX-=5;
        else nX-=5;
      }
    }
  }
}
void keyPressed() {
  if (key == 'a' || key == 'A') {
    edgeLocked[2] = (edgeLocked[2]) ? false: true;
  }
  if (key == 'd' || key == 'D') {
    edgeLocked[3] = (edgeLocked[3]) ? false: true;
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
