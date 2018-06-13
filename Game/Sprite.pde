class Sprite {
  String sImgName;
  float fX, fY, fYstart, fXstart;
  float fAccel; //0.8 seems real /// never changes
  float fVelocity, fVelocityLimit;
  int nDirec;
  int nJumpCount = 0;  // we used this instead of canJump just in case we ever wanted to be able to dobule jump
  int nMax, nMin;
  int nMinX, nMaxX, nMinY, nMaxY, nSpeed;
  int nDeg = 0;
  PVector vPos;  
  PVector[] vD = new PVector[9];
  boolean bHasTimerStarted; // used to delay things (like falling platforms and moving onto the next level)
  boolean bChangeDir;
  PImage img;
  int nDeathCount;
  boolean bMasterMode=false;
  boolean bFlipGravity=false;

  boolean bReachedLR = true;
  boolean bReachedUD = true;  

  boolean bActivateGravity=false;
  int nTimeAtTimerStart, nTimeSinceTimerStarted;
  int nGravityDelay;

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
    userInfo.updateUserInfo();
  }
  // ============== RESPAWN =============================================
  void respawn() {
    background(20);
    bHasTimerStarted=false; 
    nDeathCount++;
    userInfo.updateUserInfo();
    refreshCoord();
    if (Lvl.alGore.size()>5) { // you see, we would have used an array for Al Gore images, but the naming of the arrayList 'alGore" is just too precious.
      Lvl.alGore.remove(0);
    }
    Lvl.alGore.add(new Sprite(fX, fY, 0, 0, 0, 0, "alGore.png", 0, 0, 0, 0, false));
    vPos.set(nBoxSize + 2, nLevelHeight - nBoxSize - img.height - 2);
    fVelocity = 0;
    nDirec=0;
    nJumpCount=0;
    Lvl.alBullets.clear();   
    refreshCoord();    
    sprSidekick.vPos.set(nBoxSize + 2, nLevelHeight - 3*nBoxSize); // added to remove sprSidekick.respawn in levelBase
    sprSidekick.fXstart = vPos.x;
    sprSidekick.fYstart = vPos.y;
    sprSidekick.refreshCoord();
    for (Sprite nI : Lvl.alFallPlats) {
      nI.vPos.set(nI.fXstart, nI.fYstart);
      nI.bActivateGravity=false;
      nI.bHasTimerStarted=false;
      nI.fVelocity=0;
      nI.refreshCoord();
    }    
    for (Sprite nI : Lvl.alMovingSpikes) {
      nI.vPos.set(nI.fXstart, nI.fYstart);
      nI.bActivateGravity=false;
      nI.fVelocity=0;
      nI.refreshCoord();
    }
  }
  // ============== MASTER MODE =============================================
  void masterMode() {
    if (bMasterMode) {
      nLevel=1;
      Lvl.bDrawn=false;
    }
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
    Lvl.checkSaws();
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
  // ============== UPDATE MOVING SPIKES =============================================
  void updateMovingSpikes() {
    for (Sprite nI : Lvl.alBox) {
      if (Lvl.isHit(this, nI)) {
        round(fY);
        bActivateGravity=false;
      }
    }
    for (Sprite nI : Lvl.alPlat) {
      if (Lvl.isHit(this, nI)) {        
        round(fY);
        bActivateGravity=false;
      }
    }
    gravity();
    if (!bActivateGravity) {
      if (bFlipGravity) { 
        if ( fY<fYstart) {
          vPos.add(vD[nDirec]);
        }
      } else {
        if (fY>fYstart) {
          vPos.add(vD[nDirec]);
        }
      }
    }
    refreshCoord();
    display();
    /*fXstart = vPos.x;
     fYstart = vPos.y;
     gravity();
     refreshCoord();
     for (Sprite nI : Lvl.alBox) {
     if (Lvl.isHit(this, nI)) {
     if (this.bHasTimerStarted==false) {
     this.nTimeAtTimerStart=millis();
     this.bHasTimerStarted=true;
     }  
     vPos.y = fYstart;
     this.nTimeSinceTimerStarted = millis() - this.nTimeAtTimerStart;
     if (this.nTimeSinceTimerStarted >= this.nGravityDelay) {
     move();
     }
     }
     }
     for (Sprite nI : Lvl.alPlat) {
     if (Lvl.isHit(this, nI)) {
     if (this.bHasTimerStarted==false) {
     this.nTimeAtTimerStart=millis();
     this.bHasTimerStarted=true;
     }  
     vPos.y = fYstart;
     this.nTimeSinceTimerStarted = millis() - this.nTimeAtTimerStart;
     if (this.nTimeSinceTimerStarted >= this.nGravityDelay) {
     move();
     }
     }
     }*/
    /*move();
     refreshCoord();
     for (Sprite nI : Lvl.alBox) {
     if (Lvl.isHit(this, nI)) {
     switch(this.nDirec) {
     case 3: 
     this.nDirec=4;
     break;
     case 4: 
     this.nDirec=3;
     break;
     }
     }
     }
     for (Sprite nI : Lvl.alPlat) {
     if (Lvl.isHit(this, nI)) {
     switch(this.nDirec) {
     case 3: 
     this.nDirec=4;
     break;
     case 4: 
     this.nDirec=3;
     break;
     }
     }
     }*/
  }
  // ============== UPDATE SAW =============================================
  void updateSaw() {
    changeSawDirec();
    move();
    display();
  }  
  // ============== CHANGE SAW DIREC =============================================
  void changeSawDirec() {  
    if (Lvl.isHitDirec(this)) {
      switch(this.nDirec) {
      case 1: 
        this.nDirec=2;
        break;
      case 2: 
        this.nDirec=1;
        break;
      case 3: 
        this.nDirec=4;
        break;
      case 4: 
        this.nDirec=3;
        break;
      case 5: 
        this.nDirec=6;
        break;
      case 6: 
        this.nDirec=5;
        break;
      case 7: 
        this.nDirec=8;
        break;
      case 8: 
        this.nDirec=7;
        break;
      }
    }
  }
}