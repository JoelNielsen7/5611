import java.util.Collections;
import peasy.*;

String projectTitle = "Fire";
color b1, b2, c1, c2, c3, c4;

PeasyCam cam;

ArrayList<PVector> positions = new ArrayList<PVector>();
ArrayList<PVector> velocities = new ArrayList<PVector>();
ArrayList<PVector> colors = new ArrayList<PVector>();
ArrayList<Float> lifespans = new<Float> ArrayList();

PVector normal = new PVector(0,0,0);
float genRate = 1200; 
float spawn_radius = 60;
int x_vel_low = -5;
int x_vel_high = 5;
int y_vel_low = -20;
int y_vel_high = -10;
int z_vel_low = -5;
int z_vel_high = 5;
float max_life = 20;

int smoke_y = 520; //411
int smoke_x = 508;

int color_transition = 620;
int sun_radius = 50;
int sphere_radius = 30;

PVector accel = new PVector(0, -2, 0);

PVector left_accel = new PVector(2, -1, 0);
PVector right_accel = new PVector(-2, -1, 0);
PVector origin = new PVector(501, 739, 0);
PVector smoke_point = new PVector(smoke_x, smoke_y, 0);
PVector diff = new PVector(0,0,0);

PVector sun = new PVector(508, 430, -100);
PVector sphere = new PVector(508, 550, 0);
void setup() {
  //size(1000, 1000);
  size(1000, 1000, P3D);
  cam = new PeasyCam(this, 500, 500, 0,300);
  //cam.setMinimumDistance(50);
  //cam.setMaximumDistance(1000);

  // Define colors
  b1 = color(255);
  b2 = color(0);
  c1 = color(204, 102, 0);
  c2 = color(4, 4, 61);//color(0, 102, 153);
  c3 = color(26, 82, 34);
  c4 = color(1, 36, 6);

  //noLoop();
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
    //float y = r*cos(theta) + origin.y;
    float y = origin.y;
    float z = r*cos(theta) + origin.z;
    float x_velocity = random(x_vel_low, x_vel_high);
    float y_velocity = random(y_vel_low, y_vel_high);
    float z_velocity = random(z_vel_low, z_vel_high);
    
    positions.add(new PVector(x, y, z));
    velocities.add(new PVector(x_velocity, y_velocity, z_velocity));
    colors.add(new PVector(255, 0, 0));
    lifespans.add(0.0);
  }
} 


void moveParticles(float dt){
  //println(positions.size());
  //ArrayList<Integer> removes = new<Integer> ArrayList();
  int tmp = positions.size();
  for(int i = 0; i < tmp; i++){
    positions.set(i, positions.get(i).add(velocities.get(i).copy().mult(dt)));
    lifespans.set(i, lifespans.get(i) + dt);
    
    if(positions.get(i).dist(sphere) < sphere_radius){
      //println("Sphere collision");
      normal = positions.get(i).sub(sphere);
      normal.normalize();
      positions.set(i, sphere.copy().add(normal.copy().mult(sphere_radius*1.4)));
      //float vel = velocities.get(i).mag();
      //velocities.set(i, normal.mult(vel*0.2));
      //colors.set(i, new PVector(255, 255, 255));
      //bounced.set(i, true);
    }
    
    
    
    if (positions.get(i).y > smoke_y){
      if (positions.get(i).x < smoke_x){
       velocities.set(i, velocities.get(i).add(left_accel.copy().mult(dt))); 
      }
      else{
        velocities.set(i, velocities.get(i).add(right_accel.copy().mult(dt))); 
      }
      if(positions.get(i).y > color_transition){
        colors.set(i, new PVector(255-(lifespans.get(i)*17), lifespans.get(i)*17, 0));
      }
      else{
        velocities.get(i).x += random(-1, 1);
        colors.set(i, new PVector(100 + lifespans.get(i), 100 + lifespans.get(i),100 + lifespans.get(i)));
      }
      
    }
    else{
      velocities.get(i).x += random(-2, 2);
      velocities.get(i).y -= random(-0.2, 0);
     colors.set(i, new PVector(110 + lifespans.get(i), 110 + lifespans.get(i), 110 + lifespans.get(i)));
    }
    
    
    if(lifespans.get(i) > max_life){
      positions.remove(i);
      velocities.remove(i);
      colors.remove(i);
      lifespans.remove(i);
      i -= 1;
      tmp -= 1;
    }
  }
}




void setGradient(int x, int y, float w, float h, color c1, color c2) {

  noFill();
  pushMatrix();
  translate(0, 0, -100);
  for (int i = y; i <= y+h; i++) {
    float inter = map(i, y, y+h, 0, 1);
    color c = lerpColor(c1, c2, inter);
    stroke(c);
    line(x, i, x+w, i);
  }

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
    if (positions.get(i).y > color_transition){
       stroke(colors.get(i).x, colors.get(i).y, colors.get(i).z);
    }
    else{
      stroke(colors.get(i).x, colors.get(i).y, colors.get(i).z, 150);
    }
    //pushMatrix();
    //translate(0, 0, positions.get(i).z);
    //circle(positions.get(i).x, positions.get(i).y, 1);
    point(positions.get(i).x, positions.get(i).y, positions.get(i).z);
    //popMatrix();
  }
}


void drawContext(){
  pushMatrix();
  translate(500, 700, 50); 
  rotateY(-PI/2);
  rotateZ(PI/4);
  //noFill();
  fill(79, 51, 37);
  box(100, 20, 20);
  popMatrix();
  
  pushMatrix();
  translate(540, 700, 15); 
  //rotateX(1);
  rotateY(.5);
  rotateZ(PI/4);
  //noFill();
  fill(79, 51, 37);
  box(100, 20, 20);
  popMatrix();
  
  pushMatrix();
  translate(470, 700, 15); 
  //rotateX(1);
  //rotateY(1);
  rotateZ(-PI/3);
  //noFill();
  fill(79, 51, 37);
  box(100, 20, 20);
  popMatrix();
  
  
  //fill(0,0,0);
  //stroke(0,0,0);
  //arc(200, 500, 100, 100, -PI, 0);
}

void drawSphere(){
  noStroke();
  fill(227, 120, 14);
  //translate(58, 48, 0);
  pushMatrix();
  translate(sun.x, sun.y, sun.z);
  sphere(sun_radius);
  popMatrix();
  fill(0, 0, 255);
  pushMatrix();
  translate(sphere.x, sphere.y, sphere.z);
  //sphere(sphere_radius);
  popMatrix();
}


void mouseClicked() {
  sphere.x = mouseX;
  sphere.y = mouseY;
  print(mouseX, mouseY);
}

void mouseDragged(){
  sphere.x = mouseX;
  sphere.y = mouseY;
}

void draw() {
  //println("loop");
  float dt = 0.1;
  float startFrame = millis();
  spawnParticles(dt);
  moveParticles(dt);
  float endPhysics = millis();
  
  
  setGradient(0, 0, 1000, 500, c2, c1);
  setGradient(0,500,1000,1000,c4,c3);
  drawContext();
  drawParticles();
  drawSphere();
  float endFrame = millis();
  
  String runtimeReport = "Frame: "+str(endFrame-startFrame)+"ms,"+
        " Physics: "+ str(endPhysics-startFrame)+"ms,"+
        " FPS: "+ str(round(frameRate)) +"\n";
  surface.setTitle(projectTitle+ "  -  " +runtimeReport);
}
