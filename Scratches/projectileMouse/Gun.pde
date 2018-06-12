class Gun {
  boolean bShoot=false;    
  PVector vPosGun = new PVector(40, 40);
  PVector vPosPlayer = new PVector(hero.nX, hero.nY);
  PVector vDirBullet = PVector.sub(vPosPlayer, vPosGun);   
  ArrayList <Sprite> alBullets = new ArrayList <Sprite> ();
  PImage img;
  float angle;
  Gun(int _nX, int _nY) {
    vPosGun = new PVector(_nX, _nY);
    vPosPlayer = new PVector(hero.nX, hero.nY);
    vDirBullet = vPosPlayer.sub(vPosGun);
    img = loadImage("Laser_Gun.png");
    img.resize(0, 30);

    angle = atan2(vPosGun.x-hero.nX, vPosGun.y-hero.nY); // should be  atan2(y-x); but that doesn't work and this does?!
    /*For the rotation of the image, we got help from
     https://forum.processing.org/one/topic/need-help-rotating-an-image-to-face-the-mouse.html 
     and
     https://processing.org/reference/atan2_.html
     This part did take a while to figure out as we are not familiar with fancy trig*/
  }
  void shoot() {
    alBullets.add(new Sprite("bullet.png", vPosGun, vDirBullet)); //(new Sprite("bullet.png", vPosGun, vDirBullet));
    bShoot = true;
  }
  void calc() {    
    vPosPlayer.set(hero.nX, hero.nY);
    vDirBullet = vPosPlayer.sub(vPosGun);
    vDirBullet.normalize();
    vDirBullet.mult(10); //Move speed of bullet
    angle = atan2(vPosGun.x-hero.nX, vPosGun.y-hero.nY);
  }
  void update() {
    pushMatrix();
    translate(gun.vPosGun.x, gun.vPosGun.y);
    calc();
    rotate(-angle-HALF_PI);
    imageMode(CENTER); 
    //rectMode(CORNER);
    fill(#F5572F, 110);
    noStroke();
    rect(nDiag/2, 0, nDiag, 5); // beam
    image(img, img.height/2, 0); // for image, but it doesnt work
    imageMode(CORNER); 
    popMatrix();
    if (bulletTimer.isReachedTime()) {
      gun.shoot();
      bulletTimer.start();
    }
    if (bShoot) {
      for (int nI = 0; nI<alBullets.size(); nI++) {
        Sprite bullet = alBullets.get(nI);
        if (isOutside(bullet)) {
          alBullets.remove(nI);
        } else if (isHit(bullet, hero)) { 
          alBullets.remove(nI);
          hero.colorHero = color(random(255), random(255), random(255), random(255));
        } else {
          bullet.updateV();
        }
      }
    }
  }
}