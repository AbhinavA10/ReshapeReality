class LaserGun {
  PVector vPosGun, vPosPlayer, vDBullet;   
  PImage imgGun;
  float fAngle;
  int nShotDelay;
  int nTimeSinceTimerStarted;
  int nTimeAtTimerStart = millis();
  int nDiag = round(sqrt(sq(nLevelWidth)+sq(nLevelHeight)));
  // ============== CONSTRUCTOR =============================================
  LaserGun(int nTempX, int nTempY, int nTempShotDelay) {
    vPosGun = new PVector(nTempX, nTempY);
    vPosPlayer = new PVector(sprHero.fX, sprHero.fY);
    vDBullet = PVector.sub(vPosPlayer, vPosGun); // original was vDBullet = vPosPlayer.sub(vPosGun); // was really annoying
    imgGun = loadImage("Laser_Gun.png");
    //imgGun.resize(0, 30);
    imgGun.resize(0, 40);
    fAngle = 0; 
    nShotDelay=nTempShotDelay;
    nTimeSinceTimerStarted = millis() - nTimeAtTimerStart;
  }
  // ============== UPDATE =============================================
  void update() {
    calc();
    shoot();
    display();
  }
  // ============== SHOOT =============================================
  void shoot() {
    nTimeSinceTimerStarted = millis() - nTimeAtTimerStart;
    if (nTimeSinceTimerStarted >= nShotDelay) { //bulletTimer.isReachedTime()) {
      nTimeAtTimerStart = millis(); 
      Lvl.alBullets.add(new Sprite("LaserBullet.png", vPosGun, vDBullet));
      if (soundMenu.isMuted() == false) {
        soundShoot.trigger();
      }
    }
  }
  // ============== CALCULATE =============================================
  void calc() {    
    vPosPlayer = new PVector(sprHero.fX+sprHero.img.width/2, sprHero.fY+sprHero.img.height/2);
    vDBullet = PVector.sub(vPosPlayer, vPosGun); 
    vDBullet.normalize();
    vDBullet.mult(10); // speed of bullet
    fAngle = atan2(vPosGun.x-vPosPlayer.x, vPosGun.y-vPosPlayer.y); // should be  atan2(y-x); but that doesn't work and this does?!
    /*For the rotation of the image (Function above), we got help from
     https://forum.processing.org/one/topic/need-help-rotating-an-image-to-face-the-mouse.html 
     and
     https://processing.org/reference/atan2_.html
     This part did take a while to figure out as we are not familiar with 'fancy' trig*/
  }
  // ============== DISPLAY =============================================
  void display() { 
    pushMatrix();
    translate(vPosGun.x, vPosGun.y);
    rotate(-fAngle-HALF_PI); // what the source for atan2() showed us to do
    imageMode(CENTER); 
    //rectMode(CORNER);
    fill(#F5572F, 110);
    noStroke();
    rect(0, -3, nDiag, 3); // beam
    image(imgGun, imgGun.height/2, 0); 
    imageMode(CORNER); 
    popMatrix();
  }
}