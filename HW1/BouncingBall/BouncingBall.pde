// Created for CSCI 5611

// Here is a simple processing program that demonstrates the central math used in the check-in
// to create a bouncing ball. The ball is integrated with basic Eulerian integration.
// The ball is subject to a simple PDE of constant downward acceleration  (by default, 
// down is the positive y direction).

// If you are new to processing, you can find an excellent tutorial that will quickly
// introduce the key features here: https://processing.org/tutorials/p3d/

String projectTitle = "Bouncing Ball";

//Animation Principle: Store object & world state in external variables that are used by both
//                     the drawing code and simulation code.
float x_position = 200; 
float y_position = 300;
float z_position = 0;
float x_velocity = 20;
float y_velocity = 20;
float z_velocity = -40;
float radius = 40; 
float floor = 600;
float left = 0;
float right = 600;
float back = -600;
float front = 100;

//Creates a 600x600 window for 3D graphics 
void setup() {
 size(600, 600, P3D);
 noStroke(); //Question: What does this do?
}

//Animation Principle: Separate Physical Update 
void computePhysics(float dt){
  float y_acceleration = 9.8;
  float x_acceleration = 0;
  
  //Eulerian Numerical Integration
  x_position = x_position + x_velocity * dt;  //Question: Why update x_position before y_velocity? Does it matter?
  x_velocity = x_velocity + x_acceleration * dt;  
  
  y_position = y_position + y_velocity * dt;  //Question: Why update x_position before y_velocity? Does it matter?
  y_velocity = y_velocity + y_acceleration * dt;  
  
  z_position = z_position + z_velocity * dt;
  
  //Collision Code (update y_velocity if we hit the floor)
  if (y_position + radius > floor){
    y_position = floor - radius; //Robust collision check
    y_velocity *= -.95; //Coefficient of restitution (don't bounce back all the way) 
  }
  if (x_position - radius < left){
    x_position = left + radius;
    x_velocity *= -.95;
  }
  else if (x_position + radius > right){
    x_position = right - radius;
    x_velocity *= -.95;
  }
  else if (z_position - radius < back){
    z_position = back + radius;
    z_velocity *= -.95;
  }
  else if (z_position + radius > front){
    z_position = front - radius;
    z_velocity *= -.95;
  }
}

//Animation Principle: Separate Draw Code
void drawScene(){
  background(100,40,40);
  fill(255,0,0);
  pointLight(255, 0, 0, 300, 300, 0);
  
  pushMatrix();
  rotateY(PI/2);
  rect(0,0,600,600);
  fill(255,255,255);
  stroke(10);
  //line(0,0, 600, 0);
  //fill(255,0,0);
  noStroke();
  popMatrix();
  
  
  pushMatrix();
  translate(600, 600);
  rotateY(-PI/2);
  rect(0,0,-600,-600);
  fill(255,255,255);
  stroke(10);
  //line(0,0, -600, 0);
  fill(255,0,0);
  noStroke();
  popMatrix();
  
  pushMatrix();
  rotateX(-PI/2);
  rect(0,0,600,600);
  noFill();
  stroke(0,0,0);
  rect(0,0,600,600);
  fill(255,255,255);
  stroke(10);
  popMatrix();
  fill(255,0,0);
  noStroke();
  //popMatrix();
  
  pushMatrix();
  translate(600,600);
  rotateX(PI/2);
  rect(0,0,-600,-600);
  popMatrix();
  
  fill(255,0,0);
  stroke(10);
  //line(0,0, 0, 0, 0, -600);
  
  //line(0,100,0,0,100,0);
  //line(600,0,600,0,0,-600);
  //line(0,600,0,600,0,-600);
  
  //line(600,0,0,600,0,-100);
  //line(600,600,0,600,600,-600);
  noStroke();
  
  fill(0,200,10); 
  lights();
  translate(x_position,y_position, z_position); 
  sphere(radius);
}

//Main function which is called every timestep. Here we compute the new physics and draw the scene.
//Additionally, we also compute some timing performance numbers.
void draw() {
  float startFrame = millis(); //Time how long various components are taking
  
  //Compute the physics update
  computePhysics(0.15); //Question: Should this be a fixed number?
  float endPhysics = millis();
  
  //Draw the scene
  drawScene();
  float endFrame = millis();
  
  String runtimeReport = "Frame: "+str(endFrame-startFrame)+"ms,"+
        " Physics: "+ str(endPhysics-startFrame)+"ms,"+
        " FPS: "+ str(round(frameRate)) +"\n";
  surface.setTitle(projectTitle+ "  -  " +runtimeReport);
  //print(runtimeReport);
}
