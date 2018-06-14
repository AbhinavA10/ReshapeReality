// use this class for parallax background for each different level
class BackGround {
  PImage imgMoon, imgCloud1, imgCloud2, imgFog, imgSky, imgWindow;
  // ============== CONSTRUCTOR ========================================
  BackGround() {
    imgMoon = loadImage("moon.png");
    imgCloud1 = loadImage("cloud1.png");    
    imgCloud2 = loadImage("cloud2.png");
    imgFog = loadImage("fog.png");    
    imgSky = loadImage("sky.png");
    imgWindow = loadImage("window.png");
  }
  // ============== UPDATE =============================================
  void update() {
    pushMatrix();
    translate(-nXCamOffset, -nYCamOffset);
    image(imgSky, 997, 148);
    popMatrix();

    pushMatrix();
    translate(-round(nXCamOffset/1.1), -round(nYCamOffset/1.1));
    image(imgMoon, 975, 145);
    popMatrix();

    pushMatrix();
    translate(-round(nXCamOffset/2), -round(nYCamOffset/1.3));
    image(imgCloud1, 695, 180);
    popMatrix();

    pushMatrix();
    translate(-round(nXCamOffset/2.5), -round(nYCamOffset/1.35));
    image(imgFog, 685, 210);
    popMatrix();

    pushMatrix();
    translate(-round(nXCamOffset/3), -round(nYCamOffset/1.45));
    image(imgCloud2, 715, 190);
    popMatrix();

    pushMatrix();
    translate(-nXCamOffset, -nYCamOffset);
    image(imgWindow, 644, 0);
    popMatrix();
  }
}
