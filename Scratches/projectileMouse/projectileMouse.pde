// This is the working laser gun

int nDiag;
Gun gun;
Timer bulletTimer;
Sprite hero;
void setup() {
  size(900, 600);
  hero = new Sprite(100, 100, 20, 20);
  gun = new Gun(30, 30);
  bulletTimer = new Timer(1500);
  bulletTimer.start();
  nDiag = int(sqrt(sq(width)+sq(height)));
}
void draw() {    
  background(20); 
  hero.updateHero();

  gun.update();
}
//=====MOVING=====
void keyPressed() {
  if (key == 'w') { 
    hero.nDirec=1;
  } else if (key == 'a') { 
    hero.nDirec=2;
  } else if (key == 's') { 
    hero.nDirec=3;
  } else if (key == 'd') { 
    hero.nDirec=4;
  }
}
void keyReleased() {
  hero.nDirec=0;
}
//=====IS HIT=====
boolean isHit(Sprite one, Sprite two) {
  int nX1, nY1, nX2, nY2;
  int nH1, nW1, nH2, nW2;
  nX1 = one.nX;
  nY1 = one.nY; 
  nX2 = two.nX;
  nY2 = two.nY;
  nH1 = one.img.height;
  nW1 = one.img.width;
  nH2 = two.nW;
  nW2 = two.nH;
  if (
    ( ( (nX1 <= nX2) && (nX1+nW1 >= nX2) ) ||
    ( (nX1 >= nX2) && (nX1 <= nX2+nW2) ) )
    &&
    ( ( (nY1 <= nY2) && (nY1+nH1 >= nY2) ) ||
    ( (nY1 >= nY2) && (nY1 <= nY2+nH2) ) )
    )
    return (true) ;
  else {
    return false;
  }
}
boolean isOutside(Sprite one) {
  int nX1, nY1;
  nX1 = one.nX;
  nY1 = one.nY; 
  if (nX1>width || nX1<0 || nY1>height|| nY1<0) {
    return true;
  } else {
    return false;
  }
}