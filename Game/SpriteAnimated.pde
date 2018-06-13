/*For inheritance, we got help from Mr. Grondin, and the following sites:
 https://processing.org/examples/inheritance.html
 https://processing.org/reference/extends.html
 https://processing.org/reference/super.html*/
// this class includes animation
class SpriteAnimated extends Sprite {
  ArrayList<PImage> alImages = new ArrayList<PImage>(); // all of the images.
  PImage imgSpriteSheet;
  int nI = 0;
  int nCount=0;
  int nMaxCount=0;
  int nLastDirec=0; // only needed to keep the animations facing the same way
  int nX=0, nY=0;
  // ============== CONSTRUCTOR =============================================
  SpriteAnimated(float fTempX, float fTempY, float fTempAccel, float fTempVelocity, int nTempVelocityLimit, int nTempDirec, String sTempImgName, int nTempMin, int nTempMax, int nTempGravityDelay, int nTempSpeed, boolean bTempFlipGravity, int nImgsWide, int nImgsHigh, int nTempMaxCount) {
    super(fTempX, fTempY, fTempAccel, fTempVelocity, nTempVelocityLimit, nTempDirec, sTempImgName, nTempMin, nTempMax, nTempGravityDelay, nTempSpeed, bTempFlipGravity);
    this.imgSpriteSheet = loadImage(sImgName);
    if (sImgName.equals("PixelCrab.png")) {
      bActivateGravity=true;
      imgSpriteSheet.resize(240, 33);
    }
    nMaxCount=nTempMaxCount;
    int nW = imgSpriteSheet.width/nImgsWide;
    int nH = imgSpriteSheet.height/nImgsHigh;
    for (int y=0; y< nImgsHigh; y++) {
      for (int x=0; x< nImgsWide; x++) {
        nX = x*nW;        
        nY = y*nH;
        img = imgSpriteSheet.get(nX, nY, nW, nH); // get the image of a single card from the sprite sheet
        alImages.add(img);
      }
    }
  }
  // ============== DISPLAY =============================================
  void display() {
    nCount++;
    if (nCount==nMaxCount) {
      img = getImage();
      nCount = 0;
    }
    pushMatrix();
    translate(vPos.x, vPos.y);
    if (nDirec ==2) {   
      if (bFlipGravity) {
        scale(-1, -1); //flip across y axis
        image(img, -img.width, -img.height);
      } else { 
        // flip across x axis
        scale(-1, 1);
        image(img, -img.width, 0);
      }
    } else if (nDirec ==1) { //1 is right, 2 is left
      if (bFlipGravity) {
        scale(1, -1); //flip across y axis
        image(img, 0, -img.height);
      } else {
        image(img, 0, 0); // original is going right
      }
    } else if (nDirec==0) {      
      img = sprHero.getImage();
      if (nLastDirec==2) {
        if (bFlipGravity) {
          scale(-1, -1); //flip across y axis
          image(img, -img.width, -img.height);
        } else {
          // flip across x axis
          scale(-1, 1);
          image(img, -img.width, 0);
        }
      } else {
        if (bFlipGravity) {
          scale(1, -1); //flip across y axis
          image(img, 0, -img.height);
        } else {
          image(img, 0, 0);
        }
      }
    }    /*
    if (bFlipGravity) {
     scale(1, -1); //flip across y axis
     image(img, 0, -img.height);
     }  */

    popMatrix();
  } 
  // ============== GET IMAGE =============================================
  PImage getImage() {

    if (sImgName.equals("PixelCrab.png")) {    
      nI++;
      if (nDirec==0) {
        nI = 0;
      }    
      if (nI== alImages.size()) {
        nI=0;
      }
    } else if (sImgName.equals("butterfly2.png")) {    
      nI++;
      if (nI== 73) {
        nI=0;
      }
    } else if (sImgName.equals("door.png")) {    
      if (Lvl.isNear(sprHero, this, 15)) { // using 'this' we can use this part of the function for both doors
        nI++;
      } else {      
        nI--;
      }
      if (nI == nMax+1) { // 3, and 7
        nI=nMax;
      } else if (nI <= nMin) { // 0, and 4  // not sure why, but (nI==nMin-1) was throwing an IndexOutOfBounds Exception (-1) so we had to do this instead
        nI=nMin;
      }
    }

    return alImages.get(nI);
  }
}