//Triple Spring (damped) - 1D Motion
//CSCI 5611 Thread Sample Code
// Stephen J. Guy <sjguy@umn.edu>

//Create Window
void setup() {
  size(400, 500, P3D);
  surface.setTitle("Ball on Spring!");
  for(int i = 0; i < numV; i++){
   posY[i] = stringTopY + ((i+1)*restLen);
   posX[i] = stringTopX;
    
  }
//  posY[0] = 200;
//posY[1] = 250;
//posY[2] = 300;
//posY[3] = 350;
//posX[0] = 200;
//posX[1] = 200;
//posX[2] = 200;
//posX[3] = 200;
//posY[2] = 300;

velX[0] = 5000;
//posY[3] = 350;
//posY[4] = 400;
}

//Simulation Parameters
float floor = 500;
float gravity = 2000;
float radius = 10;
float stringTopX = 200;
float stringTopY = 50;
float restLen = 60;
float mass = 1; //TRY-IT: How does changing mass affect resting length?
float k = 1600; //TRY-IT: How does changing k affect resting length?
float kv = 160;
//float kv = 120;
int numV = 6;


float[] posY = new float[numV];
float[] velY = new float[numV];
float[] forces = new float[numV];

float[] accX = new float[numV];
float[] accY = new float[numV];

float[] posX = new float[numV];
float[] velX = new float[numV];
//Inital positions and velocities of masses

//float ballY1 = 200;
//float velY1 = 0;
//float ballY2 = 250;
//float velY2 = 0;
//float ballY3 = 300;
//float velY3 = 0;


void update(float dt){
  float xlen = 0, ylen = 0, len = 0, force = 0, dirX = 0, dirY = 0, aX= 0, aY=0;
  
  //for(int i = 0; i < numV; i++){
  // accX[i] = 0;
  // accY[i] = 0;
  //}
  
  xlen = posX[0] - stringTopX;
  ylen = posY[0] - stringTopY;
  
  len = sqrt(xlen*xlen + ylen*ylen);
  //force = (-k/restLen)*(len-restLen);
  force = -k*(len-restLen);
  dirX = xlen/len;
  dirY = ylen/len;
  
  //aX = dirX*force;
  //aY = dirY*force;
  
  //aX += kv*(velX[1]-velX[0]);
  //aY += kv*(velY[1]-velY[0]);
  
  //accX[0] += aX/2;
  //accY[0] += aY/2 + gravity;
  
  //accX[1] += -aX/2;
  //accY[1] += -aY/2;
  
  ////float dampFX = -kv*(velX[0]-0);
  ////float dampFY = -kv*(velY[0]-0);
  
    
  ////aX = (springForceX/mass)*dt;
  ////aY = (springForceY/mass)*dt;
  
  ////aX = dirX*force;
  ////aY = (dirY*force) + gravity;
  
  ////aX += kv*(velX[1]-velX[0]);
  ////aY += kv*(velY[1]-velY[0]);
  
  ////print("AX, AY:", aX, aY);
  
  ////accX[0] += aX/2;
  ////accY[0] += aY/2;
  ////accX[1] += -aX/2;
  ////accY[1] += -aY/2;
  
  //for(int i = 1; i < numV-1;i++){
  //  xlen = posX[i+1] - posX[i];
  //ylen = posY[i+1] - posY[i];
  
  //len = sqrt(xlen*xlen + ylen*ylen);
  ////force = (-k/restLen)*(len-restLen);
  //force = -k*(len-restLen);
  //dirX = xlen/len;
  //dirY = ylen/len;
  
  //aX = dirX*force;
  //aY = dirY*force;
  
  //aX += kv*(velX[i+1]-velX[i]);
  //aY += kv*(velY[i+1]-velY[i]);
  
  //accX[i] += aX/2;
  //accY[i] += aY/2 + gravity;
  
  //accX[i+1] += -aX/2;
  //accY[i+1] += -aY/2;
  
  ////float dampFX = -kv*(velX[0]-0);
  ////float dampFY = -kv*(velY[0]-0);
  
    
  ////aX = (springForceX/mass)*dt;
  ////aY = (springForceY/mass)*dt;
  
  ////aX = dirX*force;
  ////aY = (dirY*force) + gravity;
  
  ////aX += kv*(velX[1]-velX[0]);
  ////aY += kv*(velY[1]-velY[0]);
  
  //print("AX, AY:", aX, aY);
  
  //accX[0] += aX/2;
  //accY[0] += aY/2;
  //accX[1] += -aX/2;
  //accY[1] += -aY/2;
    
  //}
  
  //for(int i = 0; i < numV;i++){
  // velX[i] += accX[i]*dt;
  // velY[i] += accY[i]*dt;
  // posX[i] += velX[i]*dt;
  // posY[i] += velY[i]*dt;
  //}
  
  
  //***********************
  xlen = posX[0] - stringTopX;
  ylen = posY[0] - stringTopY;
  
  len = sqrt(xlen*xlen + ylen*ylen);
  //force = (-k/restLen)*(len-restLen);
  force = -k*(len-restLen);
  dirX = xlen/len;
  dirY = ylen/len;
  
  float projVel = (velX[0]*dirX) + (velY[0]*dirY);
  
  //print("ProJ:", projVel);
  
  float tmpProjVel = projVel;
  
  //float dampF = -kv*(projVel - 0);
  float dampFX = -kv*(velX[0])*dirX;
  float dampFY = -kv*(velY[0])*dirY;
  
  float forcetmp = force;
  
  //float springForceX = (force + dampF)* dirX;
  
  //float springForceY = (force + dampF)* dirY;
  //float dampFX = 0;
  //float dampFY = 0;
  float springForceX = (force + dampFX)* dirX;
  
  float springForceY = (force + dampFY)* dirY;
  
  //print("X, Y", springForceX, springForceY);
  
  velX[0] += (springForceX/mass)*dt;
  velY[0] += ((springForceY + gravity)/mass)*dt;
  posX[0] += velX[0]*dt;
  posY[0] += velY[0]*dt;
    for(int i = 1; i < numV; i++){
    xlen = posX[i] - posX[i-1];
    ylen = posY[i] - posY[i-1];
    
    len = sqrt(xlen*xlen + ylen*ylen);
    //force = (-k/restLen)*(len-restLen);
    force = -k*(len-restLen);
    dirX = xlen/len;
    dirY = ylen/len;
    
    
    projVel = (velX[i]*dirX) + (velY[i]*dirY);

    
    //dampF = -kv*(projVel - tmpProjVel);
    
    //dampF = 0;
    dampFX = -kv*(velX[i]-velX[i-1])*dirX;
    dampFY = -kv*(velY[i]-velY[i-1])*dirY;
    
    tmpProjVel = projVel;
    
    springForceX = (force + dampFX)* dirX;
    
    springForceY = (force + dampFY)* dirY;
    
    //print("X, Y", springForceX, springForceY);
    
    
    velX[i] += (springForceX/mass)*dt;
    velY[i] += ((springForceY + gravity)/mass)*dt;
    posX[i] += velX[i]*dt;
    posY[i] += velY[i]*dt;
    
    //velX[i-1] +=  .2*((dampF*dirX)/mass)*dt;
    //velY[i-1] += .2*((dampF*dirY)/mass)*dt;
    
    // ********************

    
    
    
    
    
    
    ////xlen = posX[i+1] - posX[i];
    ////ylen = posY[i+1] - posY[i];
    //xlen = posX[i] - posX[i-1];
    //ylen = posY[i] - posY[i-1];
  
    //len = sqrt((xlen*xlen) + (ylen*ylen));
    ////force = (-k/restLen)*(len-restLen)/mass;
    //force = -k*(len-restLen)/mass;
    //dirX = xlen/len;
    //dirY = ylen/len;
    
    //aX = dirX*force;
    //aY = (dirY*force) + gravity;
    
    ////print("AX, AY:", aX, aY);
    
    //aX += kv*(velX[i]-velX[i-1]);
    //aY += kv*(velY[i]-velY[i-1]);
    
    //accX[i] += aX/2;
    //accY[i] += aY/2;
    //accX[i+1] += -aX/2;
    //accY[i+1] += -aY/2;
    
    //accX[i] = aX;
    //accY[i] = aY;
    
  }
  
  //for(int i = 1; i < numV-1;i++){
  // velX[i] += accX[i]*dt;
  // velY[i] += accY[i]*dt;
  // posX[i] += velX[i]*dt;
  // posY[i] += velY[i]*dt;
  //}
  
  
  //Compute (damped) Hooke's law for each spring
  //float stringF1 = -k*((posY[0] - stringTopY) - restLen);
  //float dampF1 = -kv*(velY[0] - 0);
  //forces[0] = stringF1 + dampF1;
  //float accY0 = gravity + .5*forces[0]/mass - .5*forces[1]/mass; 
  //velY[0] += accY0*dt;
  //posY[0] += velY[0]*dt;
  
  //posX[0] += velX[0]*dt;
  
  
  //for (int i = 1; i < numV; i++){
    
  //  stringF1 = -k*((posY[i] - posY[i-1]) - restLen);
  //  dampF1 = -kv*(velY[i] - velY[i-1]);
  //  forces[i] = stringF1 + dampF1;
  //  float accY1 = 0;
  //  if (i == numV-1){
  //    accY1 = gravity + .5*forces[i]/mass; 
  //    velY[i] += accY1*dt;
  //    posY[i] += velY[i]*dt;
  //  }
  //  else{
  //    accY1 = gravity + .5*forces[i]/mass - .5*forces[i+1]/mass; 
  //    velY[i] += accY1*dt;
  //    posY[i] += velY[i]*dt;
  //  }
  //  posX[i] += velX[i]*dt;
    
    
    
  }
  //}
//}

//Draw the scene: one sphere per mass, one line connecting each pair
void draw() {
  background(255,255,255);
  //for(int i = 0; i < 10; i++){
  //update(.001); //We're using a fixed, large dt -- this is a bad idea!!
  //}
  for (int i = 0; i < 10; i++){
    update(1/(10.0*frameRate));
  }
  fill(0,0,0);
  
  for (int i = 0; i < numV; i++){
    if (i == 0){
      pushMatrix();
    line(stringTopX,stringTopY,posX[0],posY[0]);
    translate(posX[0],posY[0]);
    sphere(radius);
    popMatrix();
    }
     else{
       pushMatrix();
        line(posX[i-1],posY[i-1],posX[i],posY[i]);
        translate(posX[i],posY[i]);
        sphere(radius);
        popMatrix();
       
     }
    
  }
  
  
  
  //pushMatrix();
  //line(200,stringTop,200,ballY1);
  //translate(200,ballY1);
  //sphere(radius);
  //popMatrix();
  
  //pushMatrix();
  //line(200,ballY1,200,ballY2);
  //translate(200,ballY2);
  //sphere(radius);
  //popMatrix();
  
  //pushMatrix();
  //line(200,ballY2,200,ballY3);
  //translate(200,ballY3);
  //sphere(radius);
  //popMatrix();
}

//void update(float dt){
//  //Compute (damped) Hooke's law for each spring
//  float stringF1 = -k*((posY[0] - stringTop) - restLen);
//  float dampF1 = -kv*(velY[0] - 0);
//  forces[0] = stringF1 + dampF1;
//  float accY0 = gravity + .5*forces[0]/mass - .5*forces[1]/mass; 
//  velY[0] += accY0*dt;
//  posY[0] += velY[0]*dt;
  
//  posX[0] += velX[0]*dt;
  
  
//  for (int i = 1; i < numV; i++){
    
//    stringF1 = -k*((posY[i] - posY[i-1]) - restLen);
//    dampF1 = -kv*(velY[i] - velY[i-1]);
//    forces[i] = stringF1 + dampF1;
//    float accY1 = 0;
//    if (i == numV-1){
//      accY1 = gravity + .5*forces[i]/mass; 
//      velY[i] += accY1*dt;
//      posY[i] += velY[i]*dt;
//    }
//    else{
//      accY1 = gravity + .5*forces[i]/mass - .5*forces[i+1]/mass; 
//      velY[i] += accY1*dt;
//      posY[i] += velY[i]*dt;
//    }
//    posX[i] += velX[i]*dt;
    
    
    
    
//  }
//}
