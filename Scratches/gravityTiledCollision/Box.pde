class Box {
  PVector vPos;
  PVector vPosStart;
  float fAccel; //0.8 seems real /// never changes
  float fVelocity, fLimit;
  int nDirec;
  PImage img;
  int nSize;
  Box(PVector vTempPos, float fTempAccel, float fTempVelocity, int nTempVelocityLimit, int nTempDirec, int tempNsize, PVector vTempPosStart) {
    vPos = vTempPos;
    fAccel = fTempAccel; //0.8 seems real /// never changes
    fVelocity = fTempVelocity;
    fLimit = nTempVelocityLimit;
    nDirec = nTempDirec;
    nSize = tempNsize;
    vPosStart = vTempPosStart;
  }

  void update() {
    move();
    checkLeftRight();
    gravity();
    checkUpDown();
    display();
  }

  void display() {
    fill(#FF2747);
    rect(vPos.x, vPos.y, nSize, nSize);
  }

  void move() {
    vPosStart.x = vPos.x;
    vPosStart.y = vPos.y;
    if (nDirec==1) {
      vPos.x-=2;
    }
    if (nDirec==2) {
      vPos.x+=2;
    }
    if (nDirec==3) {
      vPos.y-=2;
    }
    if (nDirec==4) {
      vPos.y+=2;
    }
  }
  void gravity() {
    fVelocity+=fAccel;
    if (fVelocity>=fLimit) {
      fVelocity=fLimit;
    }
    vPos.y+=fVelocity;
  }
  void checkUpDown() {
    for (i = 0; i<alWall.size(); i++) {
      if (isHitUpDown(box.vPos.x, box.vPos.y, alWall.get(i).fX, alWall.get(i).fY, box.nSize, box.nSize, alWall.get(i).nSizeX, alWall.get(i).nSizeY)) {
        fVelocity = 0;  
        vPos.y = vPosStart.y;
      }
    }
  }

  void jump() {
    fVelocity = -20;
  }
  void checkLeftRight() {
    for (i = 0; i<alWall.size(); i++) {
      if (isHitLeftRight(box.vPos.x, box.vPos.y, alWall.get(i).fX, alWall.get(i).fY, box.nSize, box.nSize, alWall.get(i).nSizeX, alWall.get(i).nSizeY)) {
        box.nDirec=0;
        vPos.x = vPosStart.x;
      }
    }
  }
}
