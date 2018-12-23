
class Sprite {
  String sImgName;
  float fX, fY, fYstart, fXstart;
  float fAccel; //0.8 seems real /// never changes
  float fVelocity, fVelocityLimit;
  int nDirec;
  int nJumpCount = 0;  // we used this instead of canJump just in case we ever wanted to be able to dobule jump
  int nMax, nMin;
  int nMinX, nMaxX, nMinY, nMaxY, nSpeed;
  int nWidth, nHeight; // for collisions in tiled objects
  int nDeg = 0;
  PVector vPos;  
  PVector[] vD = new PVector[9];
  boolean bHasTimerStarted; // used to delay things (like falling platforms and moving onto the next level)
  boolean bChangeDir;
  PImage img;
  int nDeathCount;
  boolean bFlipGravity=false;

  boolean bReachedLR = true;
  boolean bReachedUD = true;  

  boolean bActivateGravity=false;
  int nTimeAtTimerStart, nTimeSinceTimerStarted;
  int nGravityDelay;
  int nSpawnX, nSpawnY; 

  PVector vDirBullet;
  // ============== CONSTRUCTOR =============================================
  Sprite(float fTempX, float fTempY, float fTempAccel, float fTempVelocity, int nTempVelocityLimit, int nTempDirec, String sTempImgName, int nTempMin, int nTempMax, int nTempGravityDelay, int nTempSpeed, boolean bTempFlipGravity) {
    fX = fTempX;
    fY = fTempY;    
    fXstart = fX;
    fYstart = fY;
    vPos = new PVector(fX, fY);
    fAccel = fTempAccel; 
    fVelocity = fTempVelocity;
    fVelocityLimit = nTempVelocityLimit;
    nDirec = nTempDirec;
    nGravityDelay = nTempGravityDelay;
    sImgName = sTempImgName;
    img=loadImage(sImgName);

    nMin=nTempMin;
    nMax=nTempMax;
    nMinX = round(fX-nMin);
    nMaxX = round(fX+nMax);
    nMinY = round(fY-nMin);
    nMaxY = round(fY+nMax);
    nSpeed= abs(nTempSpeed);

    vD[0] = new PVector(0, 0);
    vD[1] = new PVector(nSpeed, 0);
    vD[2] = new PVector(-nSpeed, 0);
    // below is for saws
    // u,d
    vD[3] = new PVector(0, nSpeed);
    vD[4] = new PVector(0, -nSpeed);
    //rd,lu
    vD[5] = new PVector(nSpeed, nSpeed);
    vD[6] = new PVector(-nSpeed, -nSpeed);
    //ru,ld
    vD[7] = new PVector(nSpeed, -nSpeed);
    vD[8] = new PVector(-nSpeed, nSpeed);
    /*    vD[0] = new PVector(0, 0);
     vD[1] = new PVector(6, 0);
     vD[2] = new PVector(-6, 0);
     // below is for saws
     // u,d
     vD[3] = new PVector(0, 6);
     vD[4] = new PVector(0, -6);
     //rd,lu
     vD[5] = new PVector(6, 6);
     vD[6] = new PVector(-6, -6);
     //ru,ld
     vD[7] = new PVector(6, -6);
     vD[8] = new PVector(-6, 6);*/
    nTimeAtTimerStart = millis();
    bHasTimerStarted=false;
    bFlipGravity=bTempFlipGravity;
  }// ============== CONSTRUCTOR FOR TILED OBJECTS =============================================
  Sprite(float fTempX, float fTempY, int n_Width, int n_Height, float fTempAccel, float fTempVelocity, int nTempVelocityLimit, int nTempMin, int nTempMax) {
    fX = fTempX;
    fY = fTempY;    
    fXstart = fX;
    fYstart = fY;
    nWidth = n_Width;
    nHeight = n_Height;
    vPos = new PVector(fX, fY);
    fAccel = fTempAccel; 
    fVelocity = fTempVelocity;
    fVelocityLimit = nTempVelocityLimit;

    nMin=nTempMin;
    nMax=nTempMax;
    nMinX = round(fX-nMin);
    nMaxX = round(fX+nMax);
    nMinY = round(fY-nMin);
    nMaxY = round(fY+nMax);

    nTimeAtTimerStart = millis();
    bHasTimerStarted=false;
  }
  // ============== CONSTRUCTOR FOR BULLETS =============================================
  Sprite(String sTempImgName, PVector _vPos, PVector _vDirBullet) {
    sImgName = sTempImgName;
    img = loadImage(sImgName);
    vPos = _vPos.copy();
    vDirBullet = _vDirBullet.copy();
  }
  // ============== ADVANCE LEVEL =============================================
  void advanceLevel() {
    respawn(); 
    nDeathCount--; // to 'hack' around adding a death in respawn
    Lvl.bDrawn=false; 
    bFlipGravity=false;
    nLevel++;
    if (nLevel==nLastLevel+1) {
      exit();
    }
  }
  // ============== RESPAWN =============================================

  void respawn() {
    background(20);
    bHasTimerStarted=false; 
    nDeathCount++;
    refreshCoord();
    vPos.set(nSpawnX, nSpawnY);
    fVelocity = 0;
    nDirec=0;
    nJumpCount=0;
    Lvl.alBullets.clear();   
    refreshCoord();
  }
  // ============== DISPLAY =============================================
  void display() {
    pushMatrix();
    translate(vPos.x, vPos.y);
    if (sImgName.equals("shurikan.png")) {
      nDeg+=20;
      if (nDeg==360) {
        nDeg=0;
      }
      rotate(radians(-nDeg));
      imageMode(CENTER);
      image(img, 0, 0);
      imageMode(CORNER);
    } else {
      if (bFlipGravity) {
        scale(1, -1); //flip across y axis
        image(img, 0, -img.height);
      } else {
        image(img, 0, 0);
      }
    }
    popMatrix();
  }
  // ============== UPDATE=============================================
  void update() {
    move();
    Lvl.checkLeftRight();
    gravity();
    Lvl.checkSpikes();  
    Lvl.updateBullets();
    Lvl.checkUpDown();
    Lvl.checkForHitDoors();
    display();
  } 
  // ============== UPDATE SIDEKICK =============================================
  void updateSidekick() {
    follow();
    display();
  }
  // ============== MOVE =============================================
  void move() {
    fXstart = vPos.x;
    fYstart = vPos.y;
    vPos.add(vD[nDirec]);
    refreshCoord();
  } 
  // ============== FOLLOW =============================================
  void follow() {
    for (int i = 0; i < 500; i ++) {
      if (i % 100 == 0) {
        if (bReachedLR == false) {
          if (fX < fXstart) {
            vPos.x ++ ;
            // nDirec=1;
          } else if ( fX > fXstart) {
            vPos.x -- ;
            //  nDirec=2;
          } else { //(fX == fXstart)
            bReachedLR = true;
          }
        } else {
          fXstart = round(sprHero.fX) + round(random(-50, 50));
          //println("LR" + fXstart);
          bReachedLR = false;
        } 

        if (bReachedUD == false) {
          if (fY < fYstart) {
            vPos.y ++;
          } else if ( fY > fYstart) {
            vPos.y --;
          } else { //(fY == fYstart)
            bReachedUD = true;
          }
        } else {
          fYstart = round(sprHero.fY) + round(random(-50, 0));
          //println("UD" + fYstart);
          bReachedUD = false;
        }
        refreshCoord();
      }
    }
  }
  // ============== GRAVITY =============================================
  void gravity() {
    if (bActivateGravity && !Lvl.isOutsideLevel(this)) { 
      if (bFlipGravity) {
        fVelocity-=fAccel;
        if (fVelocity<=-fVelocityLimit) {
          fVelocity=-fVelocityLimit;
        }
      } else {
        fVelocity+=fAccel;
        if (fVelocity>=fVelocityLimit) {
          fVelocity=fVelocityLimit;
        }
      }
      vPos.y+=fVelocity;
      refreshCoord();
    }
  }
  // ============== JUMP =============================================
  void jump() {
    if (nJumpCount==0) { // only let's you jump if you haven't jumped yet
      if (soundMenu.isMuted() == false) {
        soundJump.trigger();
      }
      if (bFlipGravity) {
        fVelocity = 21;
      } else {
        fVelocity = -21;
      } // jump // to fix the lag had to change from 15 to 21.49
    }
  }
  // ============== UPDATE BULLET SPRITE =============================================
  void updateV() {
    vPos.add(vDirBullet);
    image(img, vPos.x, vPos.y);
    refreshCoord();
    //println("Bullet X: "+fX+" Bullet Y: "+fY);
  }
  // ============== REFRESH COORDINATES =============================================
  void refreshCoord() {
    fX = vPos.x;
    fY = vPos.y;
  }
}
