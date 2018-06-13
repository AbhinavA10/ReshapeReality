class GiveUpButton {
  ArrayList<PImage> alImgMessages = new ArrayList<PImage>(); // all of the images.
  PImage imgButtonDisplayed, imgButtonNormal, imgButtonHover;
  int nX, nY, nMessageY;
  int nCount=0;
  boolean bTimerStarted = false;

  PImage imgMessageDisplayed, imgMessageSheet;
  int  nW = 0, nH = 0; // size of the image
  // ============== CONSTRUCTOR =============================================
  GiveUpButton(int nTempX, int nTempY) {
    imgButtonNormal=loadImage("GiveUp_Button.png");
    imgButtonHover = loadImage("GiveUp_Button_Hover.png");
    imgButtonDisplayed=imgButtonNormal;

    imgMessageSheet=loadImage("all.jpg");
    nW = imgMessageSheet.width;
    nH = imgMessageSheet.height/10;
    for (int y=0; y< 10; y++) {
      nMessageY = y*nH;
      imgMessageDisplayed = imgMessageSheet.get(0, nMessageY, nW, nH); // get the image of a single card from the sprite sheet
      alImgMessages.add(imgMessageDisplayed);
    }
    nX = nTempX;
    nY = nTempY;
    nCount=0;
  }
  // ============== UPDATE =============================================
  void update() { 
    // background(20);
    image(imgButtonDisplayed, nX, nY);
    if (bTimerStarted) {
      image(imgMessageDisplayed, 0, 0);
      if (buttonTimer.isReachedTime()) {
        if (nCount==10) {
          stop();
        } else {
          bTimerStarted=false;
          if (soundMenu.isMuted() == false) {
            soundSoundTrack.loop();
            arSoundMessage[nCount].stop();
          }
        }
      }
    } 
    if (isHitButton(imgButtonHover, nX, nY)) {
      imgButtonDisplayed=imgButtonHover;
      cursor(HAND);
    } else {
      imgButtonDisplayed=imgButtonNormal;
      cursor(ARROW);
    }
  }
  // ============== GIVE UP BUTTON =============================================
  void giveUpButton() {
    if (!giveUpButton.bTimerStarted) {
      nCount++;
      //println(giveUpButton.nCount);
      if (soundMenu.isMuted() == false) {
        soundSoundTrack.pause();
        arSoundMessage[nCount-1].trigger();
      }
      buttonTimer.nTimerLength = arSoundMessage[nCount-1].length();
      buttonTimer.start();
      imgMessageDisplayed = getImage();
      bTimerStarted=true;
    }
  }
  // ============== GET IMAGE =============================================
  PImage getImage() {
    return alImgMessages.get(nCount-1);
  }
}