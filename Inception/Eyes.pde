class Eye {
  /*For this eye we got help from https://processing.org/reference/PVector_normalize_.html,
   https://processing.org/reference/PVector_mult_.html, and
   https://processing.org/reference/PVector_sub_.html*/
  // but these were also on your website...
  PVector vEye = new PVector(width/2, height/2);
  PVector vCenter = new PVector(width/2, height/2);
  // ============== CONSTRUCTOR =============================================
  Eye(int nX, int nY) {
    vCenter = new PVector(nX, nY);
    //vCenter = new PVector(width/2, 35);
  }
  // ============== UPDATE ================================================
  void update() { 
    drawEye();
    calculate();
  }
  // ============== CALCULATE =============================================
  void calculate() {
    vEye.set(sprHero.fX, sprHero.fY);
    vEye.sub(vCenter);
    vEye.normalize();
    vEye.mult(20);
  }
  // ============== DRAW EYE =============================================
  void drawEye() {
    pushMatrix();  
    translate(vCenter.x, vCenter.y);

    //outer blue 'eye'
    noFill();
    stroke(#1EBFF7);
    strokeWeight(3);
    ellipse(0, 0, 60, 60);
    //pink pupil
    noStroke();
    fill(255, 0, 255);
    ellipse(vEye.x, vEye.y, 15, 15);
    //reflection on the pupil
    fill(255);
    ellipse(vEye.x-3, vEye.y-3, 7, 7);

    popMatrix();
  }
}