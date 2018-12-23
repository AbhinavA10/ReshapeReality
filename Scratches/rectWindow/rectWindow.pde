//https://stackoverflow.com/questions/21534545/draw-opposite-of-shape-in-papplet
//https://funprogramming.org/143-Using-PGraphics-as-layers-in-Processing.html
// Ended up using this link to learn colour transparency: https://processing.org/tutorials/color/
/*
We found out image smashing (masking) together won't work in the real game because we need to draw over the badguy
 (look at top right corner when you run this applet)
 */
PImage imgBg;

static final int STANDARD_BOX_SIZE = 200;

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

  background(#40008B); // this will end up being the portion of the mask that is blocked out (non-visible part of the game) -- wont appear on mask
  image(imgBg, 0, 0); // display the image after

  rect(width-100, 50, 20, 20); // "badguy"
  player.show();

  windowmask.updateImgMask();   // update the masking image
  image(windowmask.imgMask, 0, 0); // draw the layer that has transparency in center

  checkKeysContinious();
}
// ========================================================== CHECK KEYS CONTINIOUS ==========================================================================
void checkKeysContinious() {
  if (keyPressed) {
    player.continousPlayer();
  }
}
// ========================================================== KEYPRESSED ==========================================================================
void keyPressed() {
  windowmask.keyPress(); // for the locking and unlocking
  //player.continousPlayer();
}
