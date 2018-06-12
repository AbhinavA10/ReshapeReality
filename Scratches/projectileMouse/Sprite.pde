class Sprite {
  int nX, nY;
  int nW, nH;
  String sFile;
  PImage img;
  PVector vDirBullet;
  PVector vPos;  
  color colorHero = color(0, 255, 0, 220);
  int nDirec=0;
  int[] nDX = new int[5];
  int[] nDY = new int[5];

  Sprite(int _nX, int _nY, int _nW, int _nH) {
    nX = _nX;
    nY = _nY;
    nW = _nW;
    nH = _nH;
    nDX[0]=0;
    nDX[1]=0;
    nDX[2]=-3;
    nDX[3]=0;
    nDX[4]=3;   
    nDY[0]=0;
    nDY[1]=-3;
    nDY[2]=0;
    nDY[3]=3;
    nDY[4]=0;
  }
  Sprite(String _sFile, PVector _vPos, PVector _vDirBullet) {
    sFile = _sFile;
    img = loadImage(sFile);
    img.resize(10, 10);
    this.vPos = _vPos.copy();
    this.vDirBullet = _vDirBullet.copy();
  }
  // to update a Sprite that stores vectors
  public void updateV() {
    vPos.add(vDirBullet);
    //rotate(radians(fDir));
    image(img, vPos.x, vPos.y);
    // update nX and nY for collision detection
    nX = int(vPos.x);
    nY = int(vPos.y);
    println("Bullet X: "+nX+" Bullet Y: "+nY);
  }
  void updateHero() {
    nY+=nDY[nDirec];
    nX+=nDX[nDirec];

    stroke(0);
    rectMode(CENTER);
    fill(colorHero);  
    stroke(255);
    rect (nX, nY, 20, 20);
  }
} 