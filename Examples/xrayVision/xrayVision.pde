//https://stackoverflow.com/questions/21534545/draw-opposite-of-shape-in-papplet
PGraphics mask, front, back;
int x;

void setup(){
  size(400,400);

  background(0);

  //init both PGraphics
  mask = createGraphics(width, height);
  front = createGraphics(width, height);
  back = createGraphics(width, height);
}

void draw(){

  float x = random(width);
  float y = random(height);
  float sx = random(5, 40);

  // draw a circle as a mask      
  mask.beginDraw();
  mask.background(255);
  mask.noStroke();
  mask.fill(100);
  mask.ellipse(mouseX, mouseY, 200, 200);
  mask.endDraw();

  //dinamiaclly draw random colored rects to PG
  front.beginDraw();
  front.noStroke();
  front.fill(random(255), random(255), random(255));
  front.rect(x, y, sx, sx);
  front.endDraw();


 //dinamiaclly  draw random gray rects to display
  back.beginDraw();
  back.stroke(200);
  back.fill(0, 100);
  back.rect(x, y, sx, sx);
  back.endDraw();

  // get an imge out ofthis...
  PImage temp = front.get();

  //mask image
  temp.mask(mask);

  //dispay it
  image(back,0,0);
  image(temp, 0, 0);

}
