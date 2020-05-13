PImage p;

void setup() 
{
    size(400, 700);
}

void draw() { 
  background(255, 255, 255);
  int i = 0;
    //p = loadImage("prop3/22a4822319c141abe418f71d9a511f02EvPG1Cp4riOLsjet-0.png");
    p = loadImage("prop4/ccaf7d760bde4774e927bb7064d2cf584EK5EpdiLbBz0SD8-0.png");
  //background(0,0,0);
  imageMode(CENTER);
  image(p, 100, 300, 13, 9);
  noSmooth();
  
    
  //stroke(0,0,0);
  //P.update(.13);
  //fill(255,255,255);
  //drawPlayer();
  //fill(0,0,0);
  //drawPlatforms();
  //drawJetpacks();
  //fill(255, 255, 255);
  //drawProp();
  //h1.update(); 
  //h2.update();  
} 
