Camera camera;

//Create Window
void setup() {
  //size(400, 500, P3D);
  size(1000,1000, P3D);
  camera = new Camera();
  surface.setTitle("Cloth");
  //for(int i = 0; i < numX; i++){
  //  for(int j = 0; j < numY; j++){
  //    Vel[i][j] = new PVector(0,0,0);
  //    VelNew[i][j] = new PVector(0,0,0);
  //    Pos[i][j] = new PVector(stringTopX + ((i+1)*(restLen)), stringTopY+(5*j), stringTopZ + (50*j));
  //  }
  for(int i = 0; i < numX; i++){
    for(int j = 0; j  < numY; j++){
      Vel[i][j] = new PVector(0,0,0);
      VelNew[i][j] = new PVector(0,0,0);
      Pos[i][j] = new PVector(stringTopX + (i*restLen), stringTopY, stringTopZ + (j*restLen));
    }
  }
  
  for(int i = 0; i < numX;i++){
    for(int j = 0; j < numY; j++){
      Tear[i][j] = 1;
  }
  }
  //for(int i = 2; i < 15; i++){
  //  for(int j = 4; j <30s; j++){
  //    Tear[i][j] = 0;
  //  }
  //}
  //for(int i = 2; i < numX; i++){
  // Tear[10][i] = 0;
  // Tear[15][i] = 0;
  //}
  //for(int i = 10;  i < 15; i++){
  // Tear[i][2] = 0; 
  //}
}

//Simulation Parameters
int flag = 0;
float floor = 500;
float gravity = 5;
float radius =10;
float stringTopX = 0;
float stringTopY = 0;
float stringTopZ = 0;
float restLen = 10;
float mass = 1; //TRY-IT: How does changing mass affect resting length?
float k = 9000; //TRY-IT: How does changing k affect resting length?
float kv = 800;
//float kv = 500;
int numX = 30;
int numY = 30;
float fluid_density = .01;
float drag = .1;
float tear_len = 50;

PVector wind_speed = new PVector(0, 0, 100);

PVector[][]Pos = new PVector[numX][numY];
PVector[][]Vel = new PVector[numX][numY];
PVector[][]VelNew = new PVector[numX][numY];

int[][]Tear = new int[numX][numY];

float sphereX = 160;
float sphereY = 150;
float sphereZ = 120;

float bounce_const = -2;

PVector spherePos = new PVector(sphereX, sphereY, sphereZ);

boolean i_press = false;
boolean k_press = false;
boolean j_press = false;
boolean l_press = false;
boolean u_press = false;
boolean o_press = false;


void update(float dt){
  float xlen = 0, ylen = 0, zlen = 0, len = 0, force = 0, v1 = 0, v2 = 0;
  
  Vel = VelNew;
  
  PVector diff;
  for(int i = 0; i < numX -1; i++){
    for(int j = 0; j < numY; j++){
      if(Tear[i][j] == 1){
      diff = Pos[i+1][j].copy().sub(Pos[i][j]);
      len = diff.mag();
      if(len > tear_len){
        Tear[i][j] = 0;
      }
      diff.normalize();
      v1 = diff.dot(Vel[i][j]);
      v2 = diff.dot(Vel[i+1][j]);
    
      force = (-k*(restLen - len)) - (kv*(v1-v2));
      
      VelNew[i][j].add(diff.copy().mult(force*dt));
      VelNew[i+1][j].sub(diff.copy().mult(force*dt));
      }
    }
  }
  
  
  
  for(int i = 0; i < numX; i++){
    for(int j = 0; j < numY-1; j++){
      if(Tear[i][j] == 1){
    diff = Pos[i][j+1].copy().sub(Pos[i][j]);
      len = diff.mag();
      if(len > tear_len){
        Tear[i][j] = 0;
      }
      diff.normalize();
      v1 = diff.dot(Vel[i][j]);
      v2 = diff.dot(Vel[i][j+1]);
    
      force = (-k*(restLen - len)) - (kv*(v1-v2));
      
      VelNew[i][j].add(diff.copy().mult(force*dt));
      VelNew[i][j+1].sub(diff.copy().mult(force*dt));
      }
    }
  }
  
  float area = 0;
  PVector n1, drag_force, tmp3, vel;
  for(int i = 0; i < numX-1; i++){
     for(int j = 0; j < numY-1;j++){
       if(Tear[i][j] == 1){
        n1 = Pos[i+1][j].copy().sub(Pos[i][j]).cross(Pos[i][j+1].copy().sub(Pos[i][j]));
        area = n1.mag();
        n1.div(area);
        area *= 0.5;
        vel = Vel[i][j].copy().add(Vel[i+1][j]).add(Vel[i][j+1]).div(3);
        vel.sub(wind_speed);
        //print("Bsefore:", VelNew[i][j]);
        area = (area*(vel.dot(n1)))/(vel.mag());
        n1.mult(fluid_density*vel.mag()*vel.mag()*drag*area).div(-2).mult(dt);
        VelNew[i][j].add(n1);
        //println("AFter:", VelNew[i][j]);
       }
     }
  }
  
  
  
  float dist = 0;
    for(int i = 0; i < numX; i++){
      for(int j = 0; j < numY; j++){
        dist = spherePos.dist(Pos[i][j]);
        //println(spherePos);
        if (dist < radius + 4){
          Tear[i][j] = 0;
          //println("Collide");
          PVector n = (spherePos.copy().sub(Pos[i][j]).mult(-1));
          n.normalize();
          PVector bounce = n.copy().mult(n.dot(Vel[i][j]));
          //println(bounce.copy().mult(bounce_const));
          VelNew[i][j].add(bounce.mult(bounce_const));
          Pos[i][j].add(n.mult(4 + radius - dist));
          //Pos[i][j].set(spherePos.copy().add(n.mult(radius+4)));
       }
      }
    }
  
  
  for(int j = 0; j < numX; j++){
    VelNew[j][0].set(0,0,0);
    for(int k = 1; k < numY; k++){
      VelNew[j][k].add(new PVector(0, gravity, 0));
      Pos[j][k].add(VelNew[j][k].copy().mult(dt));
    }
  }
  
  //for(int i = 0; i < numY; i++){
  //  VelNew[0][i].set(0,0,0);
  //  for(int j = 1; j < numX;j++){
  //    VelNew[j][i].add(new PVector(0, gravity, 0));
  //    Pos[j][i].add(VelNew[j][i].copy().mult(dt));
  //  }
  //  }
 }
  
  void drawSphere(){
  noStroke();
  fill(227, 120, 14);
  //translate(58, 48, 0);
  if(i_press){
    spherePos.y -= 2; 
  }
  else if (k_press){
   spherePos.y += 2; 
  }
  else if (j_press){
    spherePos.z += 2;
  }
  else if (l_press){
    spherePos.z -= 2;
  }
  else if (o_press){
    spherePos.x -= 2;
  }
  else if (u_press){
    spherePos.x += 2;
  }
  translate(spherePos.x, spherePos.y, spherePos.z);
  box(radius);
}

//Draw the scene: one sphere per mass, one line connecting each pair
void draw() {
  background(255,255,255);
  //for(int i = 0; i < 10; i++){
  //update(.001); //We're using a fixed, large dt -- this is a bad idea!!
  //}
  camera.Update(1.0/frameRate);
  for (int i = 0; i < 10; i++){
    //camera.Update( 1.0/frameRate );
    //update(1/(10.0*frameRate));
    update(0.001);
    //camera.Update(0.1);k
    
  }
  
  //float dt = 0.01;
  //update(dt);
  //camera.Update(1/frameRate);
  fill(0,0,0);
  
  fill(0, 255, 0);
  noStroke();
  
  for (int i = 0; i < numX-1; i++){
    for(int j = 0; j < numY-1; j++){
      //fill(0,0,0);
      //pushMatrix();
      //translate(Pos[i][j].x, Pos[i][j].y, Pos[i][j].z);
      //sphere(10);
      //popMatrix();
      
      if(j%2 == 0){
      fill(0,255,0);
      }
      else{
        fill(0, 255, 0);
      }
      if(Tear[i][j] == 1 && Tear[i][j+1] == 1 && Tear[i+1][j] == 1){
      beginShape();
      vertex(Pos[i][j].x, Pos[i][j].y, Pos[i][j].z);
      vertex(Pos[i+1][j].x, Pos[i+1][j].y, Pos[i+1][j].z);
      vertex(Pos[i][j+1].x, Pos[i][j+1].y, Pos[i][j+1].z);
      endShape();
      beginShape();
      vertex(Pos[i+1][j+1].x, Pos[i+1][j+1].y, Pos[i+1][j+1].z);
      vertex(Pos[i+1][j].x, Pos[i+1][j].y, Pos[i+1][j].z);
      vertex(Pos[i][j+1].x, Pos[i][j+1].y, Pos[i][j+1].z);
      endShape();
      }
    }
  }
  drawSphere();
  println(frameRate);
  //fill(255, 0, 0);
  //pushMatrix();
  //translate(sphereX, sphereY, sphereZ);
  //sphere(radius);
  //popMatrix();
}

class Camera
{
  Camera()
  {
    position      = spherePos.copy();//new PVector (0, 0, 0);//( 0, 0, 0 ); // initial position
    theta         = 0; // rotation around Y axis. Starts with forward direction as ( 0, 0, -1 )
    phi           = 0; // rotation around X axis. Starts with up direction as ( 0, 1, 0 )
    moveSpeed     = 500;
    turnSpeed     = 1.57; // radians/sec
    
    // dont need to change these
    negativeMovement = new PVector( 0, 0, 0 );
    positiveMovement = new PVector( 0, 0, 0 );
    negativeTurn     = new PVector( 0, 0 ); // .x for theta, .y for phi
    positiveTurn     = new PVector( 0, 0 );
    fovy             = PI / 4;
    aspectRatio      = width / (float) height;
    nearPlane        = 0.1;
    farPlane         = 10000;
  }
  
  void Update( float dt )
  {
    theta += turnSpeed * (negativeTurn.x + positiveTurn.x) * dt;
    
    // cap the rotation about the X axis to be less than 90 degrees to avoid gimble lock
    float maxAngleInRadians = 85 * PI / 180;
    phi = min( maxAngleInRadians, max( -maxAngleInRadians, phi + turnSpeed * ( negativeTurn.y + positiveTurn.y ) * dt ) );
    
    // re-orienting the angles to match the wikipedia formulas: https://en.wikipedia.org/wiki/Spherical_coordinate_system
    // except that their theta and phi are named opposite
    float t = theta + PI / 2;
    float p = phi + PI / 2;
    PVector forwardDir = new PVector( sin( p ) * cos( t ),   cos( p ),   -sin( p ) * sin ( t ) );
    PVector upDir      = new PVector( sin( phi ) * cos( t ), cos( phi ), -sin( t ) * sin( phi ) );
    PVector rightDir   = new PVector( cos( theta ), 0, -sin( theta ) );
    PVector velocity   = new PVector( negativeMovement.x + positiveMovement.x, negativeMovement.y + positiveMovement.y, negativeMovement.z + positiveMovement.z );
    position.add( PVector.mult( forwardDir, moveSpeed * velocity.z * dt ) );
    position.add( PVector.mult( upDir,      moveSpeed * velocity.y * dt ) );
    position.add( PVector.mult( rightDir,   moveSpeed * velocity.x * dt ) );
    
    aspectRatio = width / (float) height;
    perspective( fovy, aspectRatio, nearPlane, farPlane );
    camera( position.x, position.y, position.z,
            position.x + forwardDir.x, position.y + forwardDir.y, position.z + forwardDir.z,
            upDir.x, upDir.y, upDir.z );
  }
  
  // only need to change if you want difrent keys for the controls
  void HandleKeyPressed()
  {
    if ( key == 'w' ) positiveMovement.z = 1;
    if ( key == 's' ) negativeMovement.z = -1;
    if ( key == 'a' ) negativeMovement.x = -1;
    if ( key == 'd' ) positiveMovement.x = 1;
    if ( key == 'q' ) positiveMovement.y = 1;
    if ( key == 'e' ) negativeMovement.y = -1;
    
    if ( keyCode == LEFT )  negativeTurn.x = 1;
    if ( keyCode == RIGHT ) positiveTurn.x = -1;
    if ( keyCode == UP )    positiveTurn.y = 1;
    if ( keyCode == DOWN )  negativeTurn.y = -1;
    
    if (key == 'i') {
    i_press = true;
  }
  else if (key == 'k'){
    k_press = true;
  }
  else if (key == 'j'){
    j_press = true;
  }
  else if (key == 'l'){
    l_press = true;
  }
  else if (key == 'u'){
    u_press = true;
  }
  else if (key == 'o'){
    o_press = true;
  }
  else if(key == ' '){
    wind_speed.z += 100;
    wind_speed.x += 100;
    wind_speed.y += 20;
  }
  }
  
  // only need to change if you want difrent keys for the controls
  void HandleKeyReleased()
  {
    if ( key == 'w' ) positiveMovement.z = 0;
    if ( key == 'q' ) positiveMovement.y = 0;
    if ( key == 'd' ) positiveMovement.x = 0;
    if ( key == 'a' ) negativeMovement.x = 0;
    if ( key == 's' ) negativeMovement.z = 0;
    if ( key == 'e' ) negativeMovement.y = 0;
    
    if ( keyCode == LEFT  ) negativeTurn.x = 0;
    if ( keyCode == RIGHT ) positiveTurn.x = 0;
    if ( keyCode == UP    ) positiveTurn.y = 0;
    if ( keyCode == DOWN  ) negativeTurn.y = 0;
    if (key == 'i') {
    i_press = false;
  }
  else if (key == 'k'){
    k_press = false;
  }
  else if (key == 'j'){
    j_press = false;
  }
  else if (key == 'l'){
    l_press = false;
  }
  else if (key == 'u'){
    u_press = false;
  }
  else if (key == 'o'){
    o_press = false;
  }
  }
  
  // only necessary to change if you want different start position, orientation, or speeds
  PVector position;
  float theta;
  float phi;
  float moveSpeed;
  float turnSpeed;
  
  // probably don't need / want to change any of the below variables
  float fovy;
  float aspectRatio;
  float nearPlane;
  float farPlane;  
  PVector negativeMovement;
  PVector positiveMovement;
  PVector negativeTurn;
  PVector positiveTurn;
};

void keyPressed()
{
  camera.HandleKeyPressed();
}

void keyReleased()
{
  camera.HandleKeyReleased();
}
