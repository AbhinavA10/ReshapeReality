class Window {
  /* this class is a window so that our game includes parallax scrolling
   we made this a class so that there wouldn't be all these global images*/
  PImage imgMoon, imgCloud1, imgCloud2, imgFog, imgSky, imgWindow;
  // ============== CONSTRUCTOR ========================================
  Window() {
    imgMoon = loadImage("moon.png");
    imgCloud1 = loadImage("cloud1.png");    
    imgCloud2 = loadImage("cloud2.png");
    imgFog = loadImage("fog.png");    
    imgSky = loadImage("sky.png");
    imgWindow = loadImage("window.png");
  }
  // ============== UPDATE =============================================
  void update() {
    /*x for window with black: 644
     
     actual window:
     x:997
     y:148
     */
    // max offset is 450
    pushMatrix();
    translate(-nXCamOffset, -nYCamOffset);
    image(imgSky, 997, 148);
    popMatrix();

    pushMatrix();
    translate(-round(nXCamOffset/1.1), -round(nYCamOffset/1.1));
    //image(imgMoon, 1000, 143);
    image(imgMoon, 975, 145);
    popMatrix();

    pushMatrix();
    translate(-round(nXCamOffset/2), -round(nYCamOffset/1.3));
    //image(imgCloud1, 672, 180);
    image(imgCloud1, 695, 180);
    popMatrix();

    pushMatrix();
    translate(-round(nXCamOffset/2.5), -round(nYCamOffset/1.35));
    //image(imgFog, 788, 213);
    image(imgFog, 685, 210);
    popMatrix();

    pushMatrix();
    translate(-round(nXCamOffset/3), -round(nYCamOffset/1.45));
    //image(imgCloud2, 538, 185);
    image(imgCloud2, 715, 190);
    popMatrix();

    pushMatrix();
    translate(-nXCamOffset, -nYCamOffset);
    image(imgWindow, 644, 0);
    popMatrix();
  }
}