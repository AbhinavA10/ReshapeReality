//https://stackoverflow.com/questions/21534545/draw-opposite-of-shape-in-papplet
//https://funprogramming.org/143-Using-PGraphics-as-layers-in-Processing.html
// Move checkContinous to other parts of the code
PImage imgBg;

int nPlayerSize=20;

static final int STANDARD_BOX_SIZE = 200;
static final int EDGE_UP = 0, EDGE_DOWN =1, EDGE_LEFT =2, EDGE_RIGHT =3; 

int nXBottomRight, nYBottomRight; // for debugging
//top left corner is (0,0)
Box player;

WindowMask windowmask;
void setup() {
  size(700, 500);
  background(255);
  player = new Box(width/2-nPlayerSize/2, height/2-nPlayerSize/2, nPlayerSize, nPlayerSize);
  windowmask = new WindowMask();
  imgBg = loadImage("bg.png");
}

void draw() {

  background(#215018); // portion of the mask that is blocked out (non-visible part of the game)
  //mask image
  imgBg.mask(windowmask.mask);
  windowmask.rectWindowMask();
  //dispay it 
  image(imgBg, 0, 0);
  player.show();
  if (keyPressed) {
    checkKeysContinious();
  }
}
void checkKeysContinious() {
  player.continousPlayer();
  windowmask.continousWindow();
}
void keyPressed() {
  windowmask.keyPress();
}
