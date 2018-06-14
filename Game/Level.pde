class Level extends PApplet {
  ArrayList <Sprite> alBox = new ArrayList<Sprite>(); 
  ArrayList <Sprite> alPlat = new ArrayList<Sprite>(); // nId = 1
  ArrayList <Sprite> alFallPlats = new ArrayList <Sprite>(); // nId = 2
  ArrayList <Sprite> alSpikes = new ArrayList<Sprite>(); // nId = 3
  ArrayList <LaserGun> alLaserGuns = new ArrayList <LaserGun> (); // nId = 7
  ArrayList <Sprite> alBullets = new ArrayList <Sprite> ();

  boolean bDrawn = false;// needed for multiple levels and to stop continously adding more boxes/spikes
  boolean bSkip = false; // used for bullets
  boolean bEarthquakeMode=false;

  String[] arSFileNames = new String[nLastLevel+1]; // names of the JSON files

  StringDict tiledObjects[]; // to store all the boxes from tiled
  // ============== CONSTRUCTOR =============================================
  Level() {

    for (int i = 0; i<nLastLevel; i++) {
      arSFileNames[i] = "data/Levels/Level"+ str(i+1)+".tmx";
    }
  }
  // ============== CREATE LEVEL =============================================
  void createLevel() { // also make a change level function or something
    /*
  NOTES
     In TMX file, 
     Plat/WallObject: Layer 3
     DoorEndObject: Layer 2
     DoorStartObject: Layer 1
     BackgroundLayer: Layer 0
     */
    //println(ptmxMap.getMapSize());
    //println( ptmxMap.mapToCanvas(ptmxMap.getMapSize()).x); // mapToCanvas doesn't work for my tiled map settings. Messes something up
    //println(ptmxMap.getName(2));
    //println(ptmxMap.getType(0));
    //println(ptmxMap.getTileSize());
    if (!bDrawn) {
      clearAllAL();
      tiledObjects = ptmxMap.getObjects(3); // get all objects in a certain layer (in this case #2). returns as  a string dictionary (kind of like a hash map)
      // above line gets the wall/platformer layer
      if (tiledObjects==null) {
        println("no objects here bois");
      } else {
        for (int i = 0; i<tiledObjects.length; i++) {
          println(tiledObjects[i]);
          int nX = parseInt(tiledObjects[i].get("x"));
          int nY = parseInt(tiledObjects[i].get("y"));
          int nWidth = parseInt(tiledObjects[i].get("width"));
          int nHeight = parseInt(tiledObjects[i].get("height"));
          alPlat.add(new Sprite (nX, nY, fAccel, fVelocity, nVelocityLimit, nDirec, sImgName, nMin, nMax, nGravityDelay, nSpeed, bFlipGravity));
        }
      }
      bDrawn = true;
    }
    if (nLevel==14) {
      sprHero.bFlipGravity=true;
      bEarthquakeMode=true;
    }
  }
  // ================================== ADD OBJECT TO LEVEL =============================================
  //StringDict size=6 { "object": "rectangle", "id": "19", "x": "512", "y": "128", "width": "32", "height": "32" }
  /*void addObjectToLevel() {
   (parseInt(tiledObjects[i].get("x")), parseInt(tiledObjects[i].get("y")), parseInt(tiledObjects[i].get("width")), parseInt(tiledObjects[i].get("height"))));
   
   the stuff below will have to be accounted for somewhere else
   int nId = jsonObjLevels.getInt("ID");
   float fX = 0;//jsonObjLevels.getString("X");;
   float fY = 0;//fDetermineCoord(sY, sYType);
   float fAccel = jsonObjLevels.getFloat("Accel");
   float fVelocity = jsonObjLevels.getFloat("Velocity");
   int nVelocityLimit = jsonObjLevels.getInt("Velocity Limit");
   int nDirec = jsonObjLevels.getInt("Direc");
   String sImgName = jsonObjLevels.getString("Image Name");
   int nMin = jsonObjLevels.getInt("Min");
   int nMax = jsonObjLevels.getInt("Max");
   int nGravityDelay = jsonObjLevels.getInt("Gravity Delay");
   int nSpeed = jsonObjLevels.getInt("Speed");
   boolean bFlipGravity  = jsonObjLevels.getBoolean("Flip Gravity");
   int nTimer = jsonObjLevels.getInt("Timer");
   switch(nId) {
   case 1: 
   alPlat.add(new Sprite (fX, fY, fAccel, fVelocity, nVelocityLimit, nDirec, sImgName, nMin, nMax, nGravityDelay, nSpeed, bFlipGravity));
   break;
   case 2: 
   alFallPlats.add(new Sprite (fX, fY, fAccel, fVelocity, nVelocityLimit, nDirec, sImgName, nMin, nMax, nGravityDelay, nSpeed, bFlipGravity));
   break;
   case 3: 
   alSpikes.add(new Sprite (fX, fY, fAccel, fVelocity, nVelocityLimit, nDirec, sImgName, nMin, nMax, nGravityDelay, nSpeed, bFlipGravity));
   break;
   case 7: 
   alLaserGuns.add(new LaserGun(round(fX), round(fY), nTimer));
   break;
   }
   }*/
  // ============== CLEAR ALL ARRAYLISTS =============================================
  void clearAllAL() {
    // Clear function for the ArrayLists were found here: https://processing.org/reference/IntList_clear_.html
    alPlat.clear();
    alSpikes.clear();
    alLaserGuns.clear();
    alBullets.clear();
    alFallPlats.clear();
  }
  // ============== CHECK-UP-DOWN =============================================
  void checkUpDown() {
    for (Sprite nI : alBox) {
      if (isHit(sprHero, nI)) {
        sprHero.fVelocity = 0; // reset velocity
        sprHero.nJumpCount=0; // if you hit the top or bottom of the box, it resets the jump amount
        sprHero.vPos.y = sprHero.fYstart;
      }
    }
    for (Sprite nI : alPlat) {
      if (isHit(sprHero, nI)) {
        sprHero.fVelocity = 0; // reset velocity
        sprHero.nJumpCount=0; // if you hit the top or bottom of the box, it resets the jump amount
        sprHero.vPos.y = sprHero.fYstart;
      }
    }
    for (Sprite nI : alFallPlats) {
      if (isHit(sprHero, nI)) {
        if (nI.bHasTimerStarted==false) {
          nI.nTimeAtTimerStart=millis();
          nI.bHasTimerStarted=true;
        }  
        nI.nTimeSinceTimerStarted = millis() - nI.nTimeAtTimerStart;
        if (nI.nTimeSinceTimerStarted >= nI.nGravityDelay) {
          nI.bActivateGravity=true;
        }
        sprHero.vPos.y = sprHero.fYstart;
        sprHero.nJumpCount=0; // if you hit the top or bottom of the box, it resets the jump amount
      }
    }
  }
  // ============== CHECK-LEFT-RIGHT =============================================
  void checkLeftRight() { 
    for (Sprite nI : alBox) {
      if (isHit(sprHero, nI)) {
        sprHero.vPos.x = sprHero.fXstart;
      }
    }
    for (Sprite nI : alPlat) {
      if (isHit(sprHero, nI)) {
        sprHero.vPos.x = sprHero.fXstart;
      }
    }
    for (Sprite nI : alFallPlats) {
      if (isHit(sprHero, nI)) {
        sprHero.vPos.x = sprHero.fXstart;
      }
    }
  }
  // ============== CHECK-SPIKES =============================================
  void checkSpikes() {
    for (Sprite nI : alSpikes) {
      if (isHit(sprHero, nI)) {
        sprHero.respawn();
      }
    }
  }
  // ============== CHECK-FOR-HIT-DOORS =============================================
  void checkForHitDoors() {
    if (isHit(sprHero, sprExit)) {
      if (!sprHero.bHasTimerStarted) {      
        timer.start();
        sprHero.bHasTimerStarted=true;
      }
      if (timer.isReachedTime()) {
        sprHero.advanceLevel();
      }
    }
  }
  // ============== UPDATE BULLETS =============================================
  void updateBullets() {
    // needed the bSkip Variable for skiping the rest of the function if a bullet was removed (avoids an IndexOutOfBounds Error)
    if (alBullets.size()!=0) {
      for (int nI = alBullets.size()-1; nI>=0; nI--) {
        bSkip=false;
        alBullets.get(nI).updateV();
        if (isHit(alBullets.get(nI), sprHero)) {
          alBullets.remove(nI);
          if (soundMenu.isMuted() == false) {
            soundHit.trigger();
          }
          sprHero.respawn();
          alBullets = null;
          alBullets = new ArrayList <Sprite> ();
          break;
        }
        // fixed
        if (alBullets.size()!=0) {
          for (int nJ = 0; nJ<alPlat.size(); nJ ++) {
            if (isHit(alBullets.get(nI), alPlat.get(nJ))) {
              alBullets.remove(nI);
              bSkip=true;
              // nI--;
              break;
            }
          }
        } 
        if (!bSkip) {
          if (alBullets.size()!=0) {
            for (int nK = 0; nK<alSpikes.size(); nK ++) {
              if (isHit(alBullets.get(nI), alSpikes.get(nK))) {
                alBullets.remove(nI);
                //nI--;
                bSkip=true;
                break;
              }
            }
          }
        }    
        if (!bSkip) {
          if (alBullets.size()!=0) {
          }
        }
        if (!bSkip) {
          if (alBullets.size()!=0) {
            for (int nM = 0; nM<alBox.size(); nM ++) {
              if (isHit(alBullets.get(nI), alBox.get(nM))) {
                alBullets.remove(nI);
                //nI--;
                break;
              }
            }
          }
        }
      }
    }
  }
  // ============== IS-HIT =============================================
  // original isHit(float nX1, float nY1, float nX2, float nY2, int nH1, int nW1, int nH2, int nW2) { 
  boolean isHit(Sprite one, Sprite two) {
    float fX1, fY1, fX2, fY2;
    int nH1, nW1, nH2, nW2;
    fX1 = one.fX;
    fY1 = one.fY; 
    fX2 = two.fX;
    fY2 = two.fY;
    nH1 = one.img.height;
    nW1 = one.img.width;
    nH2 = two.img.height;
    nW2 = two.img.width;
    if (
      ( ( (fX1 <= fX2) && (fX1+nW1 >= fX2) ) ||
      ( (fX1 >= fX2) && (fX1 <= fX2+nW2) ) )
      &&
      ( ( (fY1 <= fY2) && (fY1+nH1 >= fY2) ) ||
      ( (fY1 >= fY2) && (fY1 <= fY2+nH2) ) )
      ) {
      return (true) ;
    } else {
      return(false) ;
    }
  }
  // ============== IS NEAR =============================================
  boolean isNear(Sprite one, Sprite two, int nRange) { // needed for  animating the door
    float fX1, fY1, fX2, fY2;
    int nH1, nW1, nH2, nW2;
    fX1 = one.fX-nRange;
    fY1 = one.fY-nRange; 
    fX2 = two.fX-nRange;
    fY2 = two.fY-nRange;
    nH1 = one.img.height+nRange*2;
    nW1 = one.img.width+nRange*2;
    nH2 = two.img.height+nRange*2;
    nW2 = two.img.width+nRange*2;
    if (
      ( ( (fX1 <= fX2) && (fX1+nW1 >= fX2) ) ||
      ( (fX1 >= fX2) && (fX1 <= fX2+nW2) ) )
      &&
      ( ( (fY1 <= fY2) && (fY1+nH1 >= fY2) ) ||
      ( (fY1 >= fY2) && (fY1 <= fY2+nH2) ) )
      ) {
      return (true) ;
    } else {
      return(false) ;
    }
  }
  // ============== IS OVER =============================================
  boolean isOver(Sprite one, Sprite two, int nRange) { // needed for moving spikes
    float fX1, fX2;
    int nW1, nW2;
    fX1 = one.fX-nRange;
    fX2 = two.fX-nRange;
    nW1 = one.img.width+nRange*2;
    nW2 = two.img.width+nRange*2;
    if (
      ( ( (fX1 <= fX2) && (fX1+nW1 >= fX2) ) ||
      ( (fX1 >= fX2) && (fX1 <= fX2+nW2) ) )
      ) {
      return (true) ;
    } else {
      return(false) ;
    }
  }
  // ============== IS OUTSIDE LEVEL =============================================
  boolean isOutsideLevel(Sprite one) { // needed mostly to stop the game from calling gravity on falling platforms once they are outside the level
    float fX1, fY1;
    int nH1, nW1;
    fX1 = one.fX;
    fY1 = one.fY;
    nH1 = one.img.height;
    nW1 = one.img.width;
    if (
      ((fX1+nW1 <= 0) ||(fX1 >= nLevelWidth) )
      ||
      ((fY1+nH1 <= 0) ||(fY1 >= nLevelHeight) )
      ) {
      return (true) ;
    } else {
      return(false) ;
    }
  }
}
