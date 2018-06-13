class Menu {
  PImage imgSound, imgSoundOff, imgSoundOn;
  float fXSoundButton, fYSoundButton;
  PImage imgMasterMode, imgMasterModeOff, imgMasterModeOn;
  float fXMasterMode, fYMasterMode;
  PImage imgGear;
  float fXGear, fYGear;
  int nAngleGear = 0, nAngleGearCount;
  PImage imgCredits;
  float fXCredits, fYCredits;
  PImage imgBack, imgBackReg, imgBackHover;
  float fXBack, fYBack;
  PImage imgBegin, imgBeginReg, imgBeginHover;
  float fXBegin, fYBegin;
  // ============== CONSTRUCTOR =============================================
  Menu() {
    imgSoundOn = loadImage("soundOn.png");
    imgSoundOff = loadImage("soundOff.png");
    imgSoundOn.resize(35, 35);
    imgSoundOff.resize(35, 35);
    imgSound=imgSoundOn;
    fXSoundButton = width / 8 * 5.5;
    fYSoundButton = (height / 8 * 3.6)-imgSound.height/2 + 3;

    imgMasterModeOn = loadImage("masterModeOn.png");
    imgMasterModeOff = loadImage("masterModeOff.png");
    imgMasterMode=imgMasterModeOff;
    fXMasterMode = width / 8 * 5.5;
    fYMasterMode = (height / 8 * 4.65)-imgSound.height/2-10;

    imgGear=loadImage("gear.png");
    fXGear = width / 8 * 5.5-imgGear.width/2;
    fYGear = height / 2+15-imgGear.height/2-50; // -50 wasn't there before, had to do it so everything moved up.
    //fYGear = (height / 7 * 3.6)-imgSound.height/2 + 3;

    imgCredits=loadImage("credits.png");
    fXCredits = width / 8 * 5.5 -imgCredits.width/2;
    fYCredits = (height / 7 * 4.2)-imgSound.height/2 + 3-50; // -50 wasn't there before, had to do it so everything moved up.

    imgBackReg=loadImage("backButton.png");
    imgBackHover=loadImage("backButtonHover.png");
    imgBack=imgBackReg;
    fXBack = width / 2-imgBack.width/2;
    fYBack = height / 8 * 6.5;

    imgBeginReg=loadImage("beginButton.png");
    imgBeginHover=loadImage("beginButtonHover.png");
    imgBegin=imgBeginReg;
    fXBegin = width / 2-imgBegin.width/2;
    fYBegin = height / 2+105; // orig was +105, but had to -50 so everything moved up.
  }
  // ============== UPDATE=============================================
  void update() { 
    if (nScreen == 0) { // main
      background(20);
      textFont(font8Bit, 42); 
      textAlign(CENTER, CENTER);
      fill(255);
      text("DON'T GIVE UP", width / 2, height /2 - 100); // orig was -50, but had to add -50 so everything moved up.
      textSize(14);
      text("Press 's' for settings", width / 2, height / 2-35); // orig was +15, but had to add -50 so everything moved up.
      text("Press 'c' credits", width / 2, height / 2+5); // orig was +55, but had to add -50 so everything moved up.
      textSize(18);
      text("press ENTER to begin", width / 2, height / 2+55); // orig was +105 but had to add -50 so everything moved up.
      image(imgCredits, fXCredits, fYCredits);

      pushMatrix();
      translate(fXGear+imgGear.width/2, fYGear+imgGear.height/2);
      rotate(radians(nAngleGear));
      imageMode(CENTER);
      image(imgGear, 0, 0);
      imageMode(CORNER);
      popMatrix();

      image(imgBegin, fXBegin, fYBegin);

      if (isHitButton(imgCredits, fXCredits, fYCredits)) {
        noFill();
        stroke(200);
        rect(fXCredits-5, fYCredits-5, imgCredits.width+10, imgCredits.height+10);
        fill(255);
      } else if (isHitButton(imgGear, fXGear, fYGear)) {
        nAngleGear+=10;
        if (nAngleGear>=200) {
          nAngleGear=280;
        }
        noFill();
        stroke(200);
        rect(fXGear-5, fYGear-5, imgGear.width+10, imgGear.height+10);
        fill(255);
      } else {        
        nAngleGear-=10;
        if (nAngleGear<=0) {
          nAngleGear=0;
        }
      }      
      if (isHitButton(imgBegin, fXBegin, fYBegin)) {
        imgBegin=imgBeginHover;
      } else {
        imgBegin=imgBeginReg;
      }
    } else if (nScreen == 1) { // Settings
      background(20);
      textFont(font8Bit, 42);
      fill(255);
      textAlign(CENTER, CENTER);
      text("SETTINGS", width / 2, height / 8 * 2);
      textSize(18);
      textAlign(LEFT, TOP);
      text("TOGGLE MUSIC - PRESS M", width / 3.5, height / 8 * 3.6); 
      textAlign(CENTER, CENTER);
      text("TOGGLE MASTER MODE - PRESS H", width / 2-60, height / 8 * 4.65);
      textSize(24);
      text("Press BACKSPACE to go back", width / 2, height / 8 * 6);
      if (isHitButton(imgSound, fXSoundButton, fYSoundButton)) {
        noFill();
        stroke(200);
        rect(fXSoundButton-5, fYSoundButton-5, imgSound.width+10, imgSound.height+10);
        fill(255);
      } else if (isHitButton(imgMasterMode, fXMasterMode, fYMasterMode)) {
        noFill();
        stroke(200);
        rect(fXMasterMode-5, fYMasterMode-5, imgMasterMode.width+10, imgMasterMode.height+10);
        fill(255);
      } 
      image(imgSound, fXSoundButton, fYSoundButton);
      image(imgMasterMode, fXMasterMode, fYMasterMode);
      updateBackButton();
    } else if (nScreen == 2) { // Credits
      background(20);
      textAlign(CENTER, CENTER);
      textSize(42);
      text("CREDITS", width / 2, height / 8 * 2);
      textSize(18);
      text("By Abhinav Agrahari and Matthew Meade", width / 2, height / 8 * 4.2);
      textSize(24);
      text("Press BACKSPACE to go back", width / 2, height / 8 * 6);
      updateBackButton();
    }
    changeCursor();
  }
  // ============== MOUSE =============================================
  void mouse() {  
    if (nScreen==0) {
      if (isHitButton(imgBegin, fXBegin, fYBegin)) {
        nScreen=3;
      }    
      if (isHitButton(imgGear, fXGear, fYGear)) {
        nScreen=1;
      } 
      if (isHitButton(imgCredits, fXCredits, fYCredits)) {
        nScreen=2;
      }
    } else if (nScreen==1) {
      if (isHitButton(imgSound, fXSoundButton, fYSoundButton)) {
        if (soundMenu.isMuted()) {
          soundMenu.unmute();        
          imgSound=imgSoundOn;
        } else {
          soundMenu.mute();        
          imgSound=imgSoundOff;
        }
      } 
      if (isHitButton(imgMasterMode, fXMasterMode, fYMasterMode)) {
        if (!sprHero.bMasterMode) {
          sprHero.bMasterMode=true;          
          imgMasterMode=imgMasterModeOn;
          println("Master Mode activated");
        } else {
          sprHero.bMasterMode=false;            
          imgMasterMode=imgMasterModeOff;      
          println("MasterMode deactivated");
        }
      }
      if (isHitButton(imgBack, fXBack, fYBack)) {
        nScreen=0;
      }
    } else if (nScreen==2) { 
      if (isHitButton(imgBack, fXBack, fYBack)) {
        nScreen=0;
      }
    }
  }
  // ============== CHANGE CURSOR =============================================
  void changeCursor() {
    if (nScreen==0) { //main
      if (isHitButton(imgCredits, fXCredits, fYCredits)) {
        cursor(HAND);
      } else if (isHitButton(imgGear, fXGear, fYGear)) {
        cursor(HAND);
      } else if (isHitButton(imgBegin, fXBegin, fYBegin)) {     
        cursor(HAND);
      } else {
        cursor(ARROW);
      }
    } else if (nScreen == 1) { // Settings
      if (isHitButton(imgSound, fXSoundButton, fYSoundButton)) {
        cursor(HAND);
      } else if (isHitButton(imgMasterMode, fXMasterMode, fYMasterMode)) {
        cursor(HAND);
      } else if (isHitButton(imgBack, fXBack, fYBack)) {     
        cursor(HAND);
      } else {
        cursor(ARROW);
      }
    } else if (nScreen == 2) { // Credits
      if (isHitButton(imgBack, fXBack, fYBack)) {     
        cursor(HAND);
      } else {
        cursor(ARROW);
      }
    }
  }
  // ============== KEY =============================================
  void key() {    
    if (key == 'm' || key == 'M') {
      if (soundMenu.isMuted()) {
        soundMenu.unmute();        
        imgSound=imgSoundOn;
      } else {
        soundMenu.mute();        
        imgSound=imgSoundOff;
      }
    }
    if (key == 'h' || key == 'H') {
      if (!sprHero.bMasterMode) {
        sprHero.bMasterMode=true;          
        imgMasterMode=imgMasterModeOn;
        println("yes");
      } else {
        sprHero.bMasterMode=false;            
        imgMasterMode=imgMasterModeOff;      
        println("no");
      }
    }
  }
  // ============== UPDATE BACK BUTTON =============================================
  void updateBackButton() {    
    if (isHitButton(imgBack, fXBack, fYBack)) {
      imgBack=imgBackHover;
    } else {
      imgBack=imgBackReg;
    }
    image(imgBack, fXBack, fYBack);
  }
}