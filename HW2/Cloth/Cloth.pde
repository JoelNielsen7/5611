import java.util.Collections;

String projectTitle = "Cloth Checkin";

Camera cam;


//ArrayList<PVector> positions = new ArrayList<PVector>();


void setup() {
  size( 600, 600, P3D );
  cam = new Camera();

}

void keyPressed()
{
  cam.HandleKeyPressed();
}

void keyReleased()
{
  cam.HandleKeyReleased();
}


void draw() {
  float dt = 0.1;
  
  background(255);
  noLights();

  cam.Update( 1.0/frameRate );
  
  // draw six cubes surrounding the origin (front, back, left, right, top, bottom)
  fill( 0, 0, 255 );
  pushMatrix();
  translate( 0, 0, -50 );
  box( 20 );
  popMatrix();
  
  pushMatrix();
  translate( 0, 0, 50 );
  box( 20 );
  popMatrix();
  
  fill( 255, 0, 0 );
  pushMatrix();
  translate( -50, 0, 0 );
  box( 20 );
  popMatrix();
  
  pushMatrix();
  translate( 50, 0, 0 );
  box( 20 );
  popMatrix();
  
  fill( 0, 255, 0 );
  pushMatrix();
  translate( 0, 50, 0 );
  box( 20 );
  popMatrix();
  
  pushMatrix();
  translate( 0, -50, 0 );
  box( 20 );
  popMatrix();
}
