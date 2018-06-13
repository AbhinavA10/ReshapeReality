class Messages {
  int nX, nY;
  String sMessageChoice, sLevel; //, sHitEntry, sHitExit;
  int nRectWidth, nRectHeight; // a rectangular "background" for the level display
  String[] sMessage = new String[nLastLevel+1];
  String sType; // to distingush between the eye and level messages
  // ============== CONSTRUCTOR =============================================
  Messages(int nTempX, int nTempY, int nTempRectWidth, int nTempRectHeight, String sTempType) {
    nX=nTempX;
    nY=nTempY; 
    nRectWidth = nTempRectWidth;
    nRectHeight = nTempRectHeight;
    sType=sTempType;
  }
  // ============== DISPLAY =============================================
  void display() {
    /*One way to center the text, is that we can use "textAlign()", 
     which is found on: https://processing.org/reference/textAlign_.html*/
    textAlign(CENTER, CENTER);
    if (sType=="eye") {    
      /*  Bad attempt at making a text box thing:
       fill(40, 150);
       strokeWeight(3);
       stroke(#989595, 150);
       rect(eyeL.vCenter.x-30, eyeL.vCenter.y+35, (eyeR.vCenter.x-eyeL.vCenter.x)+50, 50);*/

      fill (255);  
      textFont(font8Bit2, 18); 
      textLeading(25); 
      /* for multi-line messages, we wanted to adjust the default line 
       spacing so we used textLeading() which we got from here: 
       https://processing.org/reference/textLeading_.html*/
      text(sMessage[nLevel-1], nX, nY);
    } else {
      textFont(font8Bit, 28); 
      fill(0, 255, 0, 200);
      stroke(0);
      strokeWeight(1.5);
      rect(nX, nY, nRectWidth, nRectHeight); // a rectangular "background" for the level display
      fill (0);
      sLevel = "Level "+str(nLevel); // convert nLevel to a string for displaying
      text(sLevel, nX+nRectWidth/2, nY+nRectHeight/2);
    }
    //sLevelTextWidth = textWidth(sLevel); //needed if using textWidth();

    /*if (sMessageChoice == "HitEntry") {
     text(sHitEntry, nX, nY);
     //text(sHitEntry, nX-fHitEntryTextWidth/2, nY); //needed if using textWidth();
     }
     if (sMessageChoice == "HitExit") {
     text(sHitExit, nX, nY);
     // text(sHitExit, nX-fHitExitTextWidth/2, nY); //needed if using textWidth();
     } */
  }
  // ============== UPDATE=============================================
  void update() { 
    /* Below is a shorter way to "if/else" that works w/ strings
     basically works like this - (expression) ? statement1 : statement2; 
     https://www.processing.org/discourse/alpha/board_Syntax_action_display_num_1087808386.html
     https://processing.org/reference/conditional.html*/
    // "\n" is for a new line
    sMessage[0] = userInfo.bNameIsThere? "Back for more "+userInfo.sName+"?":"Hello there "+userInfo.sName+".";
    sMessage[1] = userInfo.bNameIsThere? "It's good to see you again.":"I like meeting new people.";
    sMessage[2] = "This level is pretty tricky.";
    sMessage[3] = "You can do it!";
    sMessage[4] = "Wow! Great job!";
    sMessage[5] = "You're so good at this game! \n I bet you can beat it!";
    sMessage[6] = "Sometimes things are not \n as hard as they seem.";
    sMessage[7] = "Sometimes things are not \n as easy as they seem. \n (141-312-121)"; //sppppspppsppspps
    sMessage[8] = "Even I couldn't beat that last one!";
    sMessage[9] = "One day I want to be as good at this as you.";
    sMessage[10] = "You're already on the eleventh level?!?! \n You are flying through this game!"; 
    sMessage[11] = "I'm having trouble thinking of more \n inspirational things, sorry about that.";
    sMessage[12] = "You see, people usually give up, \n and I never have to say this much.";
    sMessage[13] = "Good work!";
    sMessage[14] = "I'm sorry, I panicked \n on the last one.";
    sMessage[15] = "I just don't think me rambling on about \n having nothing to say is helping anyone.";
    sMessage[16] = "You can do it!";
    sMessage[17] = "I'm really sorry, I just can't \n seem to help myself sometimes...";
    sMessage[18] = "Last level! \n BEAT THE GAME!";
    sMessage[19] = "Wow. You made it. \n I don't believe it!' ";
    sMessage[20] = " ";
  }
}