class Sprite {
  int nX, nY;
  int nW, nH;
  String sFile;
  PImage img;
  PVector vDirBullet;
  PVector vPos;

  Sprite(int _nX, int _nY, int _nW, int _nH) {
    nX = _nX;
    nY = _nY;
    nW = _nW;
    nH = _nH;
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
} 
