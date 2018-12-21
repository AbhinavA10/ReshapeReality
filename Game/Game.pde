// BY ABHINAV AGRAHARI. Started off with Don't Give up architecture, and then moved forward
// start implementing rectWindow
/*
 NOTE: You will have to download the Minim/PTMX library:
 At the top of the processing window, click on Sketch -> Import Library
 -> Add Library. Then search for Minim and PTMX and click Install.
 */
import ddf.minim.*;
import ptmx.*;
// ============== MINIM SETUP =========================================================
/* Everything to do with Minim can be found at the following links:
 http://code.compartmental.net/minim/
 http://code.compartmental.net/tools/minim/quickstart/  */
Minim minim;
AudioPlayer soundGame;
AudioSample soundJump;
AudioSample soundShoot;
AudioSample soundHit;
AudioPlayer soundMenu;
AudioSample[] arSoundMessage ;
// ============== GLOBAL VARIABLES =============================================
static final int TILE_SIZE = 32; //width of a tile

int nLevel = 1; // the level number
int nLastLevel = 20;
int nXCamOffset = 0, nYCamOffset = 0; //will translate by this much to give the effect of parallax
PFont font8Bit, font8Bit2;
boolean bGKey=false; // for hotkeys when trying to give up
boolean bCTRLKey=false; // for hotkeys when trying to give up
int nScreen = 0; // 0 = main menu, 1 = settings, 2 = credits, 3 = controls, 4 = game
// ============== CREATE OBJECTS =============================================
Sprite sprEntry; // door
Sprite sprExit; // door
SpriteAnimated sprHero;
Messages messageEye; // messages near the eye
Messages messageLevelNum; // the level message
GiveUpButton giveUpButton;
Timer timer; // a regular timer (the one that displays)
Timer buttonTimer; // for the give up button
Menu menu;
BackGround backgroundParallax;
Level Lvl;
JSONArray jsonArLevels;
JSONObject jsonObjLevels;
Ptmx ptmxMap;
// ============== SETUP =============================================
void setup() {
  frameRate(30); // to fix the lag
  background(20);
  cursor(WAIT);

  size(1024, 640); //fix below line

  font8Bit = loadFont("RetroComputer.vlw");  // this font is bitmapped, and might have to be a multiple of 14 px?
  font8Bit2 = loadFont("pixelmix_smooth.vlw");  // this font is bitmapped, and might have to be a multiple of 6 px?
  Lvl = new Level();

  sprEntry = new SpriteAnimated (TILE_SIZE, height-TILE_SIZE-73, 0, 0, 0, 1, "door.png", 0, 3, 0, 0, false, 4, 2, 3); //75 for height of the door 
  sprExit = new SpriteAnimated (width-TILE_SIZE-84, height-TILE_SIZE-73, 0, 0, 0, 1, "door.png", 4, 7, 0, 0, false, 4, 2, 3); // 48 for width of the door
  sprHero = new SpriteAnimated (TILE_SIZE*4, TILE_SIZE*7, 1.6, 0.6, 16, 0, "PixelCrab.png", 0, 0, 0, 6, false, 4, 1, 5); // to fix the lag had to change from 0.8 to 1.6, 0.3 to 0.6, 8 to 16 

  messageEye = new Messages (int(width/2), (height/2)-(height/4)+5, 0, 0, "eye");
  messageLevelNum = new Messages (width-4*TILE_SIZE, height-TILE_SIZE+5, 4*TILE_SIZE-10, TILE_SIZE-10, "other");

  timer = new Timer(TILE_SIZE/4, height-TILE_SIZE+5, 5*TILE_SIZE-20, TILE_SIZE-10, 1000); // input is in milliseconds 
  buttonTimer = new Timer(0, 0, 0, 0, 3000); // just choose 3000 as a random time, it is later set to the length of the audio

  menu = new Menu();
  backgroundParallax = new BackGround();

  giveUpButton = new GiveUpButton(width/2-85, height-TILE_SIZE+3);
  minim = new Minim(this);
  soundJump = minim.loadSample("jump.wav");
  soundShoot = minim.loadSample("Laser Sound.mp3");
  soundHit = minim.loadSample("hit sound.mp3");
  soundGame = minim.loadFile("Inception Soundtrack-Dream is Collapsing Hans Zimmer.mp3");
  soundMenu = minim.loadFile("Hans Zimmer - Time Inception.mp3");
  soundMenu.setVolume(1);
  soundJump.setGain(9001);
  soundShoot.setGain(9001);
  soundHit.setGain(9001);
  arSoundMessage = new AudioSample[10]; 
  while (giveUpButton.nCount<=9) {
    arSoundMessage[giveUpButton.nCount] = minim.loadSample("soundButton"+str(int(giveUpButton.nCount+1))+".mp3");
    arSoundMessage[giveUpButton.nCount].setGain(9001);
    giveUpButton.nCount++;
  }
  giveUpButton.nCount=0;

  soundMenu.loop();
}
// ============== DRAW =============================================
void draw() {
  //println(millis()); // used for debugging
  //println(frameRate); // used for debugging
  if (nScreen < 4 ) {
    menu.update();
  }
  if (nScreen == 4) {
    if (!giveUpButton.bTimerStarted) {
      background(240);
      updateCameraPosition();  
      backgroundParallax.update();
      //println(giveUpButton.bTimerStarted); // used for debugging
      Lvl.createLevel();
      ptmxMap.draw(0, 0, 0); // draws the tiled layer,  Visible property in Tiled is ignored when drawing individual layers.
      // ptmxMap.draw(3, 0, 0); // drawing object layer is only good for debugging -- black = object, gray = empty space. 
      sprEntry.display();
      sprExit.display();
      sprHero.update();
      messageEye.display();
      messageLevelNum.display();
      timer.display();
    }
    giveUpButton.update();
  }
}
// ============== MOUSEPRESSED =============================================
void mousePressed() {
  if (mouseButton==LEFT) {
    if (nScreen < 3) {  
      menu.mouse();
    } else if (nScreen==3) {
      nScreen=4;
      messageEye.update();
      soundMenu.pause();
      soundGame.loop();
    } else if (nScreen==4) {  
      if (isHitButton(giveUpButton.imgButtonDisplayed, giveUpButton.nX, giveUpButton.nY)) { // reason we needed to test collision here is because the hotkeys use the same function
        giveUpButton.giveUpButton();
      }
    }
  }
}
// ============== KEYPRESSED =============================================
void keyPressed() { 
  //ENTER
  if (key == ENTER || key == RETURN) {
    if (nScreen==0) {
      nScreen = 3;
    }
  }
  //BACKSPACE
  if (key == BACKSPACE) {
    if (nScreen==1||nScreen==2) {
      nScreen=0;
    } else if (nScreen==3) {
    }
  }
  // main menu
  if (nScreen == 0) {
    if (key == 's' || key == 'S') {
      nScreen = 1;
    } else if (key == 'c' || key == 'C') {
      nScreen = 2;
    }
  } 
  // settings
  else if (nScreen == 1) {
    menu.key();
  }
  // game
  else if (nScreen == 4) {
    if (!giveUpButton.bTimerStarted) {
      if (key == 'w' || key == 'W'||keyCode==UP) {
        sprHero.jump();
        sprHero.nJumpCount++;
      }
      if (key == 'd' || key == 'D'||keyCode==RIGHT) {
        sprHero.nDirec=1; //right
        sprHero.nLastDirec=1; // needed for animations to face the same way after stopping
      }
      if (key == 'a' || key == 'A'||keyCode==LEFT) {
        sprHero.nDirec=2; //left'
        sprHero.nLastDirec=2; // needed for animations to face the same way after stopping
      }
      if (key=='g'||key=='G') {
        bGKey=true;
      }
      if (keyCode==CONTROL) {
        bCTRLKey=true;
      }
      if (bCTRLKey && bGKey) {
        giveUpButton.giveUpButton();
      }
    }
  }
}
// ============== KEY RELEASED =============================================
void keyReleased() { // smoother movement
  if (nScreen == 4) {
    if ((key=='d'||key=='D')||(key=='a'||key=='A')||keyCode==RIGHT||keyCode==LEFT) {
      sprHero.nDirec=0;
    }
    if (key=='g'||key=='G') {
      bGKey=false;
    }
    if (keyCode==CONTROL) {
      bCTRLKey=false;
    }
  }
}
// ============== UPDATE CAMERA POSITION =============================================
/* From platformer example // http://www.hobbygamedev.com/int/platformer-game-source-in-processing/
 used the concept from this source code after understanding how it worked.
 did add the scrolling along the Y axis.
 */
void updateCameraPosition() {
  nXCamOffset = round(sprHero.fX-width/2); // the camera offset = position of the player subtract half the width of the level to center the player in the window
  nYCamOffset = round(sprHero.fY-height/2); // the camera offset = position of the player subtract half the height of the level to center the player in the window

  /*Earthquakes' will take place on certain levels by adding random camera movements.*/
  if (Lvl.bEarthquakeMode) { 
    nXCamOffset += round(random(-20, 20));
    int nRand = round(random(10)); // for making the next line more likely
    if (nRand>2) {
      nYCamOffset += round(random(-40, -5));
    } else {
      nYCamOffset += round(random(0, 10));
    }
  } 

  nXCamOffset = constrain(nXCamOffset, 0, width);
  nYCamOffset = constrain(nYCamOffset, 0, 100); // rando num
} 
// ============== IS HIT BUTTON =============================================
boolean isHitButton(PImage img, float fX, float fY) {
  int nH, nW;
  nH = img.height;
  nW = img.width;
  if (mouseX >= fX && mouseX <= fX+nW 
    && 
    mouseY >= fY && mouseY <= fY + nH) {
    return true;
  } else {
    return false;
  }
} 
// ============== STOP =============================================
void stop() {
  giveUpButton.nCount=0;
  while (giveUpButton.nCount<=9) {
    arSoundMessage[giveUpButton.nCount].close();
    giveUpButton.nCount++;
  }
  minim.stop();
  super.stop();
}

void loadPtmxlevel(String levelName) {
  ptmxMap = new Ptmx(this, levelName);
  ptmxMap.setDrawMode(CORNER);   // origin of each thing is in top left corner like normal
  ptmxMap.setPositionMode("CANVAS"); // all position stuff will be in pixel distances
}
