class Gun {
  boolean bShoot=false;    
  PVector vPosGun = new PVector(40, 40);
  PVector vPosPlayer = new PVector(mouseX, mouseY);
  PVector vDirBullet = PVector.sub(vPosPlayer, vPosGun);   
  ArrayList <Sprite> alBullets = new ArrayList <Sprite> ();
  PImage img;
  float angle;
  Gun(int _nX, int _nY) {
    vPosGun = new PVector(_nX, _nY);
    vPosPlayer = new PVector(mouseX, mouseY);
    vDirBullet = vPosPlayer.sub(vPosGun);
    img = loadImage("Laser_Gun.png");
    img.resize(0, 30);

    angle = atan2(vPosGun.x-mouseX, vPosGun.y-mouseY);
    /*For above math to calculate angle using arctan, 
     https://forum.processing.org/one/topic/need-help-rotating-an-image-to-face-the-mouse.html 
     */
  }
  void shoot() {
    alBullets.add(new Sprite("bullet.png", vPosGun, vDirBullet));
    bShoot = true;
  }
  void calc() {    
    vPosPlayer.set(mouseX, mouseY);
    vDirBullet = vPosPlayer.sub(vPosGun);
    vDirBullet.normalize();
    vDirBullet.mult(10); //Move speed of bullet
    angle = atan2(vPosGun.x-mouseX, vPosGun.y-mouseY);
  }
  void update() {
    calc();
    rect(gun.vPosGun.x, gun.vPosGun.y, 35, 35);
    if (bShoot) {
      for (int nI = 0; nI<alBullets.size(); nI++) {
        Sprite bullet = alBullets.get(nI);
        if (isOutside(bullet)) {
          alBullets.remove(nI);
        } else {
          bullet.updateV();
        }
      }
    }
  }
}
