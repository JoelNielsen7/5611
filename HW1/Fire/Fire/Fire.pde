import java.util.Collections;
import peasy.*;
// Created for CSCI 5611

// Here is a simple processing program that demonstrates the central math used in the check-in
// to create a bouncing ball. The ball is integrated with basic Eulerian integration.
// The ball is subject to a simple PDE of constant downward acceleration  (by default, 
// down is the positive y direction).

// If you are new to processing, you can find an excellent tutorial that will quickly
// introduce the key features here: https://processing.org/tutorials/p3d/

String projectTitle = "Particle System";

//Animation Principle: Store object & world state in external variables that are used by both
//                     the drawing code and simulation code.

ArrayList<PVector> positions = new ArrayList<PVector>();
ArrayList<PVector> velocities = new ArrayList<PVector>();
ArrayList<PVector> colors = new ArrayList<PVector>();
ArrayList<Float> lifespans = new<Float> ArrayList();
ArrayList<Boolean> bounced = new<Boolean> ArrayList();



float genRate = 1800; 
float spawn_radius = 2;
int x_vel_low = 20;
int x_vel_high = 30;
int y_vel_low = -30;
int y_vel_high = -20;
int z_vel_low = -10;
int z_vel_high = 10;
float max_life = 12;

int sphere_radius = 15;


float y_damp_min = -0.4;
float y_damp_max = -0.2;


int floor = 50;

PVector accel = new PVector(0, 10, 0);
PVector origin = new PVector(-155, -69, 0);

PVector sphere = new PVector(-120, -100, -40);

PVector normal = new PVector(0,0,0);

PeasyCam cam;

PShape s;

boolean w_press = false;
boolean s_press = false;
boolean a_press = false;
boolean d_press = false;
boolean q_press = false;
boolean e_press = false;

//Creates a 600x600 window for 3D graphics 
void setup() {
 size(1000, 1000, P3D);
 //noStroke(); //Question: What does this do?
  cam = new PeasyCam(this, 0, 0, 0, 250);
  //cam.rotateX(PI/6);
  cam.rotateY(PI/6);
  //cam.rotateZ(PI/4);
  //cam = new PeasyCam(this, -170, 60, 0, 300);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(500);
 //s = loadShape("faucet-svgrepo-com.svg");
 //print(s);
}


void spawnParticles(float dt){
  int numParticles = int(dt*genRate);
  if (random(1) < dt*genRate){
    numParticles += 1;
  }
  for (int i = 0; i < numParticles; i++){
    float r = spawn_radius * sqrt(random(1));
    float theta = 2*PI*random(1);
    float x = r*sin(theta) + origin.x;
    float y = r*cos(theta) + origin.y;
    float z = r*cos(theta) + origin.z;
    float x_velocity = random(x_vel_low, x_vel_high);
    float y_velocity = random(y_vel_low, y_vel_high);
    float z_velocity = random(z_vel_low, z_vel_high);
    
    positions.add(new PVector(x, y, z));
    velocities.add(new PVector(x_velocity, y_velocity, z_velocity));
    colors.add(new PVector(0, 0, 255));
    lifespans.add(0.0);
    bounced.add(false);
  }
} 


void moveParticles(float dt){
  //println(positions.size());
  //ArrayList<Integer> removes = new<Integer> ArrayList();
  int tmp = positions.size();
  for(int i = 0; i < tmp; i++){
    positions.set(i, positions.get(i).add(velocities.get(i).copy().mult(dt)));
    lifespans.set(i, lifespans.get(i) + dt);
    velocities.set(i, velocities.get(i).add(accel.copy().mult(dt)));
    if (!bounced.get(i)){
    colors.set(i, new PVector(0, 0, (lifespans.get(i)*60) + 100));
    }
    
    if(positions.get(i).y > floor){
      positions.get(i).y = floor;
      velocities.get(i).y *= random(y_damp_min, y_damp_max);
      velocities.get(i).x *= 0.3;
      colors.set(i, new PVector(255, 255, 255));
      bounced.set(i, true);
    }
    
    if(positions.get(i).dist(sphere) < sphere_radius){
      //println("Sphere collision");
      normal = positions.get(i).sub(sphere);
      normal.normalize();
      positions.set(i, sphere.copy().add(normal.copy().mult(sphere_radius*1.01)));
      float vel = velocities.get(i).mag();
      velocities.set(i, normal.mult(vel*0.2));
      //colors.set(i, new PVector(255, 255, 255));
      //bounced.set(i, true);
    }
    
    
    if(lifespans.get(i) > max_life){
      //println("Removing");
      //removes.add(i);
      positions.remove(i);
      velocities.remove(i);
      colors.remove(i);
      lifespans.remove(i);
      i -= 1;
      tmp -= 1;
    }
  }
}
  

void drawBackground(){
  //background(12, 42, 89);
  //background(0, 0, 0);
  background(125, 123, 121);
  fill(125, 167, 232);
  pushMatrix();
  translate(0, floor, 0);
  rotateX(PI/2);
  rect(-1000, -1000, 2000, 2000);
  popMatrix();
  fill(62, 122, 51);
  pushMatrix();
  rotateZ(PI/4);
  rect(-170, 60, 20, 50);
  popMatrix();
}

void drawParticles(){
  //background(160,160,160);
  fill(255, 0, 0);
  //shape(s, 100, 100, 100, 100);
  //noStroke();
  noSmooth();
  //fill(0,0,0);
  //rect(0,floor, 600, 600);
  //fill(0, 0, 0);
  //rect(290, 320, 20, 80);
  //triangle(290, 320, 310, 320, 300, 300);
  
  
  for(int i = 0; i < positions.size(); i++){
    //fill(colors.get(i).x, colors.get(i).y, colors.get(i).z);
    stroke(colors.get(i).x, colors.get(i).y, colors.get(i).z);
    //pushMatrix();
    //translate(0, 0, positions.get(i).z);
    //circle(positions.get(i).x, positions.get(i).y, 1);
    point(positions.get(i).x, positions.get(i).y, positions.get(i).z);
    //popMatrix();
  }
}

void drawSphere(){
  noStroke();
  fill(227, 120, 14);
  //translate(58, 48, 0);
  if(w_press){
    sphere.y -= 2; 
  }
  else if (s_press){
   sphere.y += 2; 
  }
  else if (a_press){
    sphere.z += 2;
  }
  else if (d_press){
    sphere.z -= 2;
  }
  else if (q_press){
    sphere.x -= 2;
  }
  else if (e_press){
    sphere.x += 2;
  }
  translate(sphere.x, sphere.y, sphere.z);
  sphere(sphere_radius);
}

void keyPressed() {
  if (key == 'w') {
    w_press = true;
  }
  else if (key == 's'){
    s_press = true;
  }
  else if (key == 'a'){
    a_press = true;
  }
  else if (key == 'd'){
    d_press = true;
  }
  else if (key == 'q'){
    q_press = true;
  }
  else if (key == 'e'){
    e_press = true;
  }
}

void keyReleased() {
  if (key == 'w') {
    w_press = false;
  }
  else if (key == 's'){
    s_press = false;
  }
  else if (key == 'a'){
    a_press = false;
  }
  else if (key == 'd'){
    d_press = false;
  }
  else if (key == 'q'){
    q_press = false;
  }
  else if (key == 'e'){
    e_press = false;
  }
}


void draw() {
  float dt = 0.1;
  float startFrame = millis();
  spawnParticles(dt);
  //Compute the physics update
  moveParticles(dt); 
  float endPhysics = millis();
  
  //Draw the scene
  drawBackground();
  drawParticles();
  drawSphere();
  float endFrame = millis();
  
  String runtimeReport = "Frame: "+str(endFrame-startFrame)+"ms,"+
        " Physics: "+ str(endPhysics-startFrame)+"ms,"+
        " FPS: "+ str(round(frameRate)) +"\n";
  surface.setTitle(projectTitle+ "  -  " +runtimeReport);
  //print(runtimeReport);
}
