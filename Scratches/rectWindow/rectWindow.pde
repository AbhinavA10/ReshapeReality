//https://stackoverflow.com/questions/21534545/draw-opposite-of-shape-in-papplet
//https://funprogramming.org/143-Using-PGraphics-as-layers-in-Processing.html
// Completed
PImage imgBg;

static final int STANDARD_BOX_SIZE = 200;
static final int EDGE_UP = 0, EDGE_DOWN =1, EDGE_LEFT =2, EDGE_RIGHT =3; 

//top left corner is (0,0)
Box player;
WindowMask windowmask;
// ========================================================== SETUP ==========================================================================
void setup() {
  size(700, 500);
  background(255);

  int nPlayerSize=20;
  player = new Box(width/2-nPlayerSize/2, height/2-nPlayerSize/2, nPlayerSize, nPlayerSize);
  windowmask = new WindowMask();
  imgBg = loadImage("bg.png");
}
// ========================================================== DRAW ==========================================================================
void draw() {

  background(#215018); // portion of the mask that is blocked out (non-visible part of the game)
  imgBg.mask(windowmask.mask);//mask image
  windowmask.applyMask();  
  image(imgBg, 0, 0); // display the image
  player.show();
  checkKeysContinious();
}
// ========================================================== CHECK KEYS CONTINIOUS ==========================================================================
void checkKeysContinious() {
  if (keyPressed) {
    player.continousPlayer();
    windowmask.continousWindow();
  }
}
// ========================================================== KEYPRESSED ==========================================================================
void keyPressed() {
  windowmask.keyPress(); // for the locking and unlocking
}
