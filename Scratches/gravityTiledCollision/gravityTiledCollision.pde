PVector vPos;
PVector vPosStart;
Box box;
ArrayList <Wall> alWall = new ArrayList<Wall>();
int i;
boolean bDrawn = false;
String sDrawDirec="Right";
StringDict wallObjects[];
import ptmx.*;

Ptmx ptmxMap;
void setup() {
  size(576, 480); // 18*32, 15*32
  vPos= new PVector (230, 20);
  vPosStart = new PVector (250, 20);
  box = new Box(vPos, 0.8, 0.3, 8, 0, 25, vPosStart);

  ptmxMap = new Ptmx(this, "walls.tmx");
   ptmxMap.setDrawMode(CORNER);   // origin of each thing is in top left corner like normal
 ptmxMap.setPositionMode("CANVAS"); // all position stuff will be in pixel distances
  wallObjects = ptmxMap.getObjects(2); // check layer index
}
void draw() {
  background(#3D5DA2);
  stroke(0, 255, 0); // lime green line style
  /*
  In TMX file, 
  WallTiledObjects: Layer 2
  wallImages: Layer 1
  BackgroundLayer: Layer 0
  
  */
  println( ptmxMap.mapToCanvas(ptmxMap.getMapSize()).x);
  ptmxMap.draw(1,0,0); // this draws the wall layer,  Visible property in Tiled is ignored when drawing individual layers.
  line(0, 500, 900, 500); // "ground line"
  createBoxes();
  box.update();
  for (i = 0; i<alWall.size(); i++) {
    alWall.get(i).display();
  }
}
// function I need to fix
void createBoxes() {
  if (bDrawn == false) {
    //alWall.add(new Wall(150, 450, 50));
    //alWall.add(new Wall(200, 450, 50));
    //alWall.add(new Wall(250, 450, 50));
    //alWall.add(new Wall(250, 400, 50));
    //alWall.add(new Wall(200, 200, 50));
    bDrawn = true;
  }
}
void keyPressed() {
  if (key == 'w' || key == 'W') {
    box.jump();
  }
  if (key == 'a' || key == 'A') {
    box.nDirec=1;
  }
  if (key == 's' || key == 'S') {
    box.nDirec=4;
  }
  if (key == 'd' || key == 'D') {
    box.nDirec=2;
  }
}


boolean isHitUpDown(float nX1, float nY1, float nX2, float nY2, int nSize1, int nSize2) {
  int nW1 = nSize1;
  int nW2 = nSize2;
  int nH1 = nSize1;
  int nH2 = nSize2;
  if (
    ( ( (nX1 <= nX2) && (nX1+nW1 >= nX2) ) ||
    ( (nX1 >= nX2) && (nX1 <= nX2+nW2) ) )
    &&
    ( ( (nY1 <= nY2) && (nY1+nH1 >= nY2) ) ||
    ( (nY1 >= nY2) && (nY1 <= nY2+nH2) ) )
    )
    return (true) ;
  else
    return(false) ;
}
boolean isHitLeftRight(float nX1, float nY1, float nX2, float nY2, int nSize1, int nSize2) {
  int nW1 = nSize1;
  int nW2 = nSize2;
  int nH1 = nSize1;
  int nH2 = nSize2;
  if (
    ( ( (nX1 <= nX2) && (nX1+nW1 >= nX2) ) ||
    ( (nX1 >= nX2) && (nX1 <= nX2+nW2) ) )
    &&
    ( ( (nY1 <= nY2) && (nY1+nH1 >= nY2) ) ||
    ( (nY1 >= nY2) && (nY1 <= nY2+nH2) ) )
    )
    return (true) ;
  else
    return(false) ;
}