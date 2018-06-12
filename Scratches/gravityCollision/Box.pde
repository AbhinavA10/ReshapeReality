class Box {
  PVector vPos;
  PVector vPosStart;
  float fAccel; //0.8 seems real /// never changes
  float fVelocity, fLimit;
  boolean canJump;
  int nDirec;
  PImage img;
  int nSize;
  Box(PVector vTempPos, float fTempAccel, float fTempVelocity, int nTempVelocityLimit, boolean canTempJump, int nTempDirec, int tempNsize, PVector vTempPosStart) {
    vPos = vTempPos;
    fAccel = fTempAccel; //0.8 seems real /// never changes
    fVelocity = fTempVelocity;
    fLimit = nTempVelocityLimit;
    canJump = canTempJump;
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
    fill(20, 60, 200);
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
      if (isHitUpDown(box.vPos.x, box.vPos.y, alWall.get(i).fX, alWall.get(i).fY, box.nSize, alWall.get(i).nSize)) {
        fVelocity = 0;  
        vPos.y = vPosStart.y;
      }
    }
  }

  void jump() {
    if (canJump = true) {
      fVelocity = -20;
    }
  }
  void checkLeftRight() {
    for (i = 0; i<alWall.size(); i++) {
      if (isHitLeftRight(box.vPos.x, box.vPos.y, alWall.get(i).fX, alWall.get(i).fY, box.nSize, alWall.get(i).nSize)) {
        box.nDirec=0;
        vPos.x = vPosStart.x;
      }
    }
  }
}