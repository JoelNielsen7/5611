//Camera camera;

//Create Window
void setup() {
  //size(400, 500, P3D);
  size(1000,1000, P3D);
  //camera = new Camera();
  surface.setTitle("Pathfinder");
  obstacles[0] = new PVector(0,0);
  radii[0] = 2;
  for(int i = 0; i < points.length; i++){
   points[i] = new PVector(0,0); 
  }
  points[0] = start;
  points[1] = end;
  sample_points();
  build_graph();
  build_heuristic();
  final_path= a_star();
}

//Simulation Parameters
int path_length_final = -1;
int current_node = 1;
boolean done = false;

boolean draw_points = false;
boolean draw_lines = false;

int num_obstacles = 1;
PVector[]obstacles = new PVector[num_obstacles];
float[]radii = new float[num_obstacles];

float agent_speed = 50;
PVector agent_pos = new PVector(-9, -9);
float agent_radius = 0.5;

int num_points = 400;
int[] final_path = new int[num_points];
PVector[] points = new PVector[num_points];

float[][]graph = new float[num_points][num_points];

float[]heuristic = new float[num_points];

PVector start = new PVector(-9,-9);
PVector end = new PVector(9,9);

PVector translate_coords(PVector vec){
  PVector tmp = PVector.mult(PVector.add(vec, new PVector(10, 10)), 50);
  tmp.y = 1000 - tmp.y;
  return tmp;
}

float translate_radius(float rad){
 return rad * 50; 
}


void sample_points(){
  int count = 2;
  while (count < num_points){
    PVector p = new PVector(random(-10, 10), random(-10, 10));
    for(int i = 0; i < num_obstacles; i++){
      if(p.dist(obstacles[i]) < radii[i] + agent_radius){
        continue;
      }
      points[count] = p;
      count += 1;
    }
  }
}

void build_graph(){
  boolean good = true;
  int num_steps = 20;
  for(int i = 0; i < num_points; i++){
    for(int j = 0; j < num_points; j++){
      good = true;
      for(int k = 0; k < num_steps; k++){
        for(int l = 0; l < num_obstacles;l++){
          float ratio = float(k)/float(num_steps);
          if(points[i].copy().lerp(points[j], ratio).dist(obstacles[l]) < radii[l] + agent_radius){
             good = false;
             break;
          }
        }
      }
      if(good){
       graph[i][j] = points[i].dist(points[j]); 
      }
    }
  }
  //print(graph[0][0], graph[0][1]);
}


void build_heuristic(){
  for(int i = 0; i < num_points; i++){
    heuristic[i] = points[i].dist(end); 
  }
}


int[] a_star(){
  int path_length = 0;
  int last_ind = 0;
  float[]point_path_length = new float[num_points];
  int[]previous = new int[num_points];
  point_path_length[0] = 0;
  for(int i = 1; i < num_points; i++){
    point_path_length[i] = 1000000;
  }
  int[]point_status = new int[num_points];
  for(int i = 0; i < num_points;i++){
   point_status[i] = 0; //indicates not in open or closed list 
  }
  point_status[0] = 1; //indicates in open list
  int[] path = new int[num_points];
  int[] path_new = new int[num_points];
  
  boolean not_empty = true;
  boolean first = true;
  
  while(not_empty){
   int opens = 0;
   float min_f = 100000;
   int min_ind = -1;
   for(int i =0; i < num_points; i++){
    if(point_status[i] == 1){
      opens += 1;
      //float f = graph[last_ind][i] + heuristic[i];
      float f  = point_path_length[i] + heuristic[i];
      if(f < min_f){
       min_ind = i;
       min_f = f;
      }
    }
   }
   if(opens == 0){
     println("Open list empty");
     break;
   }
   //point_path_length[min_ind] = point_path_length[last_ind] + graph[min_ind][last_ind];
   path[path_length] = min_ind;
   path_length++;
   point_status[min_ind] = 2; //indicates in closed list
   if(min_ind == 1){ //found goal
     println("Found goal");
     break;
   }
   
   for(int i = 0; i < num_points;i++){
     if(graph[min_ind][i] != 0){
     if(i == min_ind){continue;}
    float succ_cost =  point_path_length[min_ind] + graph[min_ind][i];
    //point_path_length[i] = succ_cost;
    if(point_status[i] == 0){
     point_status[i] = 1; 
     previous[i] = min_ind;
    }
    else if (point_status[i] == 1){
     if(point_path_length[i] <= succ_cost){
       continue;
     }
     //else{
     //  point_path_length[i] = succ_cost;
     //}
    }
    else{
     if(point_path_length[i] <= succ_cost){
       continue;
     }
     else{
       point_status[i] = 1;
     }
    }
    previous[i] = min_ind;
    point_path_length[i] = succ_cost;
   }
   }
  }
  
  //int open_count = 1;
  //int[]open = new int[num_points];
  // add start node to open queue
  //open[0] = 0;
  //int[]closed = new int[num_points];
  
  //for(int i = 0; i < path.length; i++){
  //println(path[i]);
  //}
  
  
  
  //return path;
  
  // work backwards to reconstruct path then reverse list
  int g = 1;
  int p_len = 0;
  while(g != 0){
   path_new[p_len] = g;
   g = previous[g];
   p_len++;
  }
  path_new[p_len] = 0;
  p_len++;
  
  for(int i = 0; i < p_len / 2; i++){
    int tmp = path_new[i];
    path_new[i] = path_new[p_len-i-1];
    path_new[p_len-i-1] = tmp;
  }
  path_length_final = p_len;
  
  //println("After");
  //for(int i = 0; i < p_len; i++){
  //println(path_new[i]);
  //}
  
  return path_new;
}

void update(float dt){
  if(!done){
    if(points[final_path[current_node]].dist(points[final_path[current_node-1]]) < agent_pos.dist(points[final_path[current_node-1]])){
      if(final_path[current_node] == 1){
        done = true;
      }
      else{
     current_node++; 
      }
    }
  //print(points[0]);
  agent_pos.add(PVector.mult(points[final_path[current_node]].copy().sub(points[final_path[current_node-1]]).normalize(), (agent_speed*dt)));
  
  }
  //for(int i = 0; i < path_length_final; i++){
  //  int num_steps = 20;
  //  for(int l = 0; l < num_obstacles;l++){
  //    float ratio = float(k)/float(num_steps);
  //    if(points[i].copy().lerp(points[j], ratio).dist(obstacles[l]) < radii[l]){
  //       break;
  //    }
  //  }
  //}
  
  
  
}


//Draw the scene: one sphere per mass, one line connecting each pair
void draw() {
  background(255,255,255);
  //camera.Update(0.1);
  update(0.001);
  //camera.Update(1.0/frameRate);
  //for (int i = 0; i < 10; i++){
  //  //camera.Update( 1.0/frameRate );
  //  //update(1/(10.0*frameRate));
  //  update(0.001);
  //  //update(0.0015);
  //  //camera.Update(0.1);k
  noStroke();
  fill(0, 0, 255);
  PVector translated;
  float radius;
  for(int i = 0; i < num_obstacles; i++){
    //pushMatrix();
    //translate(obstacles[i].x, obstacles[i].y);
    translated = translate_coords(obstacles[i]);
    radius = translate_radius(radii[i]);
    circle(translated.x, translated.y,radius*2);
  }
  fill(255, 0, 0);
  translated = translate_coords(agent_pos);
  radius = translate_radius(agent_radius);
  circle(translated.x, translated.y, radius*2);
  
  //// draw points
  if(draw_points){
    for(int i = 2; i < points.length; i++){
     fill(0, 0, 0);
     translated = translate_coords(points[i]);
     radius = translate_radius(0.05);
     circle(translated.x, translated.y, radius*2);
    }
  }
  
  // draw start and end special
  radius = translate_radius(0.2);
  fill(0, 255, 0);
  translated = translate_coords(points[1]);
  circle(translated.x, translated.y, radius*2);
  fill(255, 0, 0);
  translated = translate_coords(points[0]);
  circle(translated.x, translated.y, radius*2);
  
  fill(0, 0, 0);
//  for(int i = 0; i < num_points; i++){
//    for(int j = 0; j < num_points; j++){
//       if(graph[i][j] != 0){
//         PVector t1 = translate_coords(points[i]);
//         PVector t2 = translate_coords(points[j]);
//         line(t1.x, t1.y, t2.x, t2.y); 
//       }
//    }
//}
  // draw lines along path
  if(draw_lines){
    stroke(255, 0, 0);
    int i = 1;
    PVector p1 = points[final_path[0]];
    PVector p2 = points[final_path[1]];
    p1 = translate_coords(p1);
    p2 = translate_coords(p2);
    line(p1.x, p1.y, p2.x, p2.y);
    while(i < final_path.length - 1 && final_path[i+1] != 0){
      //delay(500);
      p1 = points[final_path[i]];
      p2 = points[final_path[i+1]];
      p1 = translate_coords(p1);
      p2 = translate_coords(p2);
      line(p1.x, p1.y, p2.x, p2.y);
      i++;
    }
  }
}

void keyPressed() {
  if(key == 'z'){
    //print("Z pressed");
    draw_points = !draw_points;
    //print(draw_points);
  }
  if (key == 'x' ) draw_lines = !draw_lines;
  
}

//class Camera
//{
//  Camera()
//  {
//    position      = new PVector (0, 0, 0);//( 0, 0, 0 ); // initial position
//    theta         = 0; // rotation around Y axis. Starts with forward direction as ( 0, 0, -1 )
//    phi           = 0; // rotation around X axis. Starts with up direction as ( 0, 1, 0 )
//    moveSpeed     = 500;
//    turnSpeed     = 1.57; // radians/sec
    
//    // dont need to change these
//    negativeMovement = new PVector( 0, 0, 0 );
//    positiveMovement = new PVector( 0, 0, 0 );
//    negativeTurn     = new PVector( 0, 0 ); // .x for theta, .y for phi
//    positiveTurn     = new PVector( 0, 0 );
//    fovy             = PI / 4;
//    aspectRatio      = width / (float) height;
//    nearPlane        = 0.1;
//    farPlane         = 10000;
//  }
  
//  void Update( float dt )
//  {
//    theta += turnSpeed * (negativeTurn.x + positiveTurn.x) * dt;
    
//    // cap the rotation about the X axis to be less than 90 degrees to avoid gimble lock
//    float maxAngleInRadians = 85 * PI / 180;
//    phi = min( maxAngleInRadians, max( -maxAngleInRadians, phi + turnSpeed * ( negativeTurn.y + positiveTurn.y ) * dt ) );
    
//    // re-orienting the angles to match the wikipedia formulas: https://en.wikipedia.org/wiki/Spherical_coordinate_system
//    // except that their theta and phi are named opposite
//    float t = theta + PI / 2;
//    float p = phi + PI / 2;
//    PVector forwardDir = new PVector( sin( p ) * cos( t ),   cos( p ),   -sin( p ) * sin ( t ) );
//    PVector upDir      = new PVector( sin( phi ) * cos( t ), cos( phi ), -sin( t ) * sin( phi ) );
//    PVector rightDir   = new PVector( cos( theta ), 0, -sin( theta ) );
//    PVector velocity   = new PVector( negativeMovement.x + positiveMovement.x, negativeMovement.y + positiveMovement.y, negativeMovement.z + positiveMovement.z );
//    position.add( PVector.mult( forwardDir, moveSpeed * velocity.z * dt ) );
//    position.add( PVector.mult( upDir,      moveSpeed * velocity.y * dt ) );
//    position.add( PVector.mult( rightDir,   moveSpeed * velocity.x * dt ) );
    
//    aspectRatio = width / (float) height;
//    perspective( fovy, aspectRatio, nearPlane, farPlane );
//    camera( position.x, position.y, position.z,
//            position.x + forwardDir.x, position.y + forwardDir.y, position.z + forwardDir.z,
//            upDir.x, upDir.y, upDir.z );
//  }
  
//  // only need to change if you want difrent keys for the controls
//  void HandleKeyPressed()
//  {
//    if ( key == 'w' ) positiveMovement.z = 1;
//    if ( key == 's' ) negativeMovement.z = -1;
//    if ( key == 'a' ) negativeMovement.x = -1;
//    if ( key == 'd' ) positiveMovement.x = 1;
//    if ( key == 'q' ) positiveMovement.y = 1;
//    if ( key == 'e' ) negativeMovement.y = -1;
    
//    if ( keyCode == LEFT )  negativeTurn.x = 1;
//    if ( keyCode == RIGHT ) positiveTurn.x = -1;
//    if ( keyCode == UP )    positiveTurn.y = 1;
//    if ( keyCode == DOWN )  negativeTurn.y = -1;
    
//    if (key == 'i') {
//    i_press = true;
//  }
//  else if (key == 'k'){
//    k_press = true;
//  }
//  else if (key == 'j'){
//    j_press = true;
//  }
//  else if (key == 'l'){
//    l_press = true;
//  }
//  else if (key == 'u'){
//    u_press = true;
//  }
//  else if (key == 'o'){
//    o_press = true;
//  }
//  else if(key == ' '){
//    wind_speed.z += 100;
//    wind_speed.x += 100;
//    wind_speed.y += 20;
//  }
//  else if(key == 'b'){
//   attached = false; 
//  }
//  }
  
//  // only need to change if you want difrent keys for the controls
//  void HandleKeyReleased()
//  {
//    if ( key == 'w' ) positiveMovement.z = 0;
//    if ( key == 'q' ) positiveMovement.y = 0;
//    if ( key == 'd' ) positiveMovement.x = 0;
//    if ( key == 'a' ) negativeMovement.x = 0;
//    if ( key == 's' ) negativeMovement.z = 0;
//    if ( key == 'e' ) negativeMovement.y = 0;
    
//    if ( keyCode == LEFT  ) negativeTurn.x = 0;
//    if ( keyCode == RIGHT ) positiveTurn.x = 0;
//    if ( keyCode == UP    ) positiveTurn.y = 0;
//    if ( keyCode == DOWN  ) negativeTurn.y = 0;
//    if (key == 'i') {
//    i_press = false;
//  }
//  else if (key == 'k'){
//    k_press = false;
//  }
//  else if (key == 'j'){
//    j_press = false;
//  }
//  else if (key == 'l'){
//    l_press = false;
//  }
//  else if (key == 'u'){
//    u_press = false;
//  }
//  else if (key == 'o'){
//    o_press = false;
//  }
//  }
  
//  // only necessary to change if you want different start position, orientation, or speeds
//  PVector position;
//  float theta;
//  float phi;
//  float moveSpeed;
//  float turnSpeed;
  
//  // probably don't need / want to change any of the below variables
//  float fovy;
//  float aspectRatio;
//  float nearPlane;
//  float farPlane;  
//  PVector negativeMovement;
//  PVector positiveMovement;
//  PVector negativeTurn;
//  PVector positiveTurn;
//};

//void keyPressed()
//{
//  camera.HandleKeyPressed();
//}

//void keyReleased()
//{
//  camera.HandleKeyReleased();
//}
