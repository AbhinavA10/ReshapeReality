// scratch for testing aiming of player using mouse to shoot stake at edge
Gun gun;
void setup() {
  size(900, 600);
  gun = new Gun(width/2, height/2);
}
void draw() {    
  background(20); 
  gun.update();
  if (keyPressed) { 
    if (key == 'w') { 
      gun.vPosGun.y-=5;
    } else if (key == 'a') { 
      gun.vPosGun.x-=5;
    } else if (key == 's') { 
      gun.vPosGun.y+=5;
    } else if (key == 'd') { 
      gun.vPosGun.x+=5;
    }
  }
}
void mousePressed() {
  gun.shoot();
}
boolean isOutside(Sprite one) {
  int nX1, nY1;
  nX1 = one.nX;
  nY1 = one.nY; 
  if (nX1>width || nX1<0 || nY1>height|| nY1<0) {
    println("hit edge)");
    return true;
  } else {
    return false;
  }
}
