//https://stackoverflow.com/questions/21534545/draw-opposite-of-shape-in-papplet
//https://funprogramming.org/143-Using-PGraphics-as-layers-in-Processing.html
PGraphics mask, filler;
int nX=0, nY=0;
// create boolean array for edges 

void setup() {
  size(500, 500);

  // initial bg color, the white circle...
  background(255);

  //init both PGraphics
  mask = createGraphics(width, height);
  filler = createGraphics(width, height);

  // draw a circle as a mask
  mask.beginDraw();
  mask.background(255);
  mask.noStroke();
  mask.fill(0);
  mask.rect(nX, nY, 200, 200);
  mask.endDraw();
}

void draw() {
  background(20);

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
  circleMask();
  //dispay it
  image(temp, 0, 0);
  if (keyPressed) {
    if (keyCode == UP)nY-=5;
    if (keyCode == DOWN)nY+=5;
    if (keyCode == RIGHT)nX+=5;
    if (keyCode == LEFT)nX-=5;
  }
}
void circleMask() {
  mask.beginDraw();
  mask.background(0);
  mask.noStroke();
  mask.fill(255);
  mask.rect(nX, nY, 200, 200);
  mask.endDraw();
}
