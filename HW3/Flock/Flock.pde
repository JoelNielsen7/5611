//Camera camera;

//Create Window
void setup() {
  //size(400, 500, P3D);
  size(1000,1000, P3D);
  //camera = new Camera();
  surface.setTitle("Pathfinder");
  //obstacles[0] = new PVector(6,8);
  //radii[0] = 3;
  //obstacles[1] = new PVector(-4, -4);
  //radii[1] = 2;
  //obstacles[2] = new PVector(3, 0);
  //radii[2] = 2;
  //obstacles[3] = new PVector(7, 0);
  //radii[3] = 4;
  //obstacles[4] = new PVector(-3,3 );
  //radii[4] = 3;
  //obstacles[5] = new PVector(-3, 0);
  //radii[5] = 2;
  //obstacles[6] = new PVector(0, -3);
  //radii[6] = 3;
  
  //sample_points();
  //build_graph();
  //build_heuristic();
  //a_star();
}

void setup_real(){
  
  
}

//Simulation Parameters
int num_agents = 15;
//int current_node = 1;
int[] current_nodes = new int[num_agents];
boolean done = false;

boolean draw_points = false;
boolean draw_lines = false;

int num_obstacles = 0;
int max_obstacles = 10;
PVector[]obstacles = new PVector[max_obstacles];
float[]radii = new float[max_obstacles];


float[] agent_speeds = new float[num_agents];
PVector[] agent_poses = new PVector[num_agents];
float[] agent_radii = new float[num_agents];


//float agent_speed = 50;
//PVector agent_pos = new PVector(-9, -9);
float agent_radius = 0.1;

int num_points = 400;
int[][] final_paths = new int[num_agents][num_points];
//int[] final_path = new int[num_points];
PVector[] points = new PVector[num_points];

float[][]graph = new float[num_points][num_points];

float[]heuristic = new float[num_points];
//float[][] heuristics = new float[num_agents][num_points];

PVector[] starts = new PVector[num_agents];

PVector start = new PVector(-9,-9);
PVector end = new PVector(0,0);

boolean[] dones = new boolean[num_agents];

PVector[] forces = new PVector[num_agents];
PVector[] vels = new PVector[num_agents];
float attraction_coef = .25;
float repulsion_coef = .25;
float repulsion_thresh = .5;
float velocity_coef = 0.25;
float obstacle_coef = 1;
float obstacle_thresh = 4;
float goal_coef = 4;
float max_vel = .1;
float sight_distance = 4;
float obstacle_avoid = 0.01;
PVector[] last_pos = new PVector[num_agents];

boolean obstacle_clicking = false;
boolean drawing_circle = false;
boolean built_graph = false;
boolean start_drawn = false;
boolean end_drawn = false;
boolean setup_done = false;

PVector translate_coords(PVector vec){
  PVector tmp = PVector.mult(PVector.add(vec, new PVector(10, 10)), 50);
  tmp.y = 1000 - tmp.y;
  return tmp;
}

PVector translate_coords_reverse(PVector vec){
  vec.y = 1000 - vec.y;
  PVector tmp = PVector.sub(PVector.div(vec, 50), new PVector(10, 10));
  return tmp;
}

float translate_radius(float rad){
 return rad * 50; 
}

float translate_radius_reverse(float rad){
 return rad / 50; 
}

void sample_points(){
  //int count = 2;
  int count = num_agents + 1;
  while (count < num_points){
    PVector p = new PVector(random(-10, 10), random(-10, 10));
    boolean good = true;
    for(int i = 0; i < num_obstacles; i++){
      if(p.dist(obstacles[i]) < radii[i] + agent_radius){
        good = false;
        break;
      }
    }
    if(good){
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


void a_star(){
  //print("Starting a*");
  for(int a = 0; a < num_agents; a++){
    //print("Entering for loop iteration", a);
    int path_length = 0;
    int last_ind = 0;
    float[]point_path_length = new float[num_points];
    int[]previous = new int[num_points];
    point_path_length[a] = 0;
    for(int i = 0; i < num_points; i++){
      if (i != a){
      point_path_length[i] = 1000000;
      }
    }
    int[]point_status = new int[num_points];
    for(int i = 0; i < num_points;i++){
     point_status[i] = 0; //indicates not in open or closed list 
    }
    point_status[a] = 1; //indicates in open list
    int[] path = new int[num_points];
    int[] path_new = new int[num_points];
    
    boolean not_empty = true;
    
    while(not_empty){
     int opens = 0;
     float min_f = 10000000;
     int min_ind = -1;
     for(int i =0; i < num_points; i++){
      if(point_status[i] == 1){
        opens += 1;
        //float f = graph[last_ind][i] + heuristic[i];
        float f  = point_path_length[i] + heuristic[i];
        //println(f);
        if(f < min_f){
         min_ind = i;
         min_f = f;
        }
      }
     }
     if(opens == 0){
       //println("Open list empty");
       break;
     }
     //point_path_length[min_ind] = point_path_length[last_ind] + graph[min_ind][last_ind];
     path[path_length] = min_ind;
     path_length++;
     point_status[min_ind] = 2; //indicates in closed list
     if(min_ind == num_agents){ //found goal
       //println("Found goal", path_length, points[num_agents]);
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
    
    
    // work backwards to reconstruct path then reverse list
    int g = num_agents;
    int p_len = 0;
    while(g != a){
     final_paths[a][p_len] = g;
     g = previous[g];
     p_len++;
    }
    final_paths[a][p_len] = a;
    p_len++;
    
    for(int i = 0; i < p_len / 2; i++){
      int tmp = final_paths[a][i];
      final_paths[a][i] = final_paths[a][p_len-i-1];
      final_paths[a][p_len-i-1] = tmp;
    }
  }
}

void ucs(){
  //print("Starting a*");
  for(int a = 0; a < num_agents; a++){
    //print("Entering for loop iteration", a);
    int path_length = 0;
    int last_ind = 0;
    float[]point_path_length = new float[num_points];
    int[]previous = new int[num_points];
    point_path_length[a] = 0;
    for(int i = 0; i < num_points; i++){
      if (i != a){
      point_path_length[i] = 1000000;
      }
    }
    int[]point_status = new int[num_points];
    for(int i = 0; i < num_points;i++){
     point_status[i] = 0; //indicates not in open or closed list 
    }
    point_status[a] = 1; //indicates in open list
    int[] path = new int[num_points];
    int[] path_new = new int[num_points];
    
    boolean not_empty = true;
    
    while(not_empty){
     int opens = 0;
     float min_f = 10000000;
     int min_ind = -1;
     for(int i =0; i < num_points; i++){
      if(point_status[i] == 1){
        opens += 1;
        //float f = graph[last_ind][i] + heuristic[i];
        float f  = point_path_length[i];
        //println(f);
        if(f < min_f){
         min_ind = i;
         min_f = f;
        }
      }
     }
     if(opens == 0){
       //println("Open list empty");
       break;
     }
     //point_path_length[min_ind] = point_path_length[last_ind] + graph[min_ind][last_ind];
     path[path_length] = min_ind;
     path_length++;
     point_status[min_ind] = 2; //indicates in closed list
     if(min_ind == num_agents){ //found goal
       println("Found goal", path_length, points[num_agents]);
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
    
    
    // work backwards to reconstruct path then reverse list
    int g = num_agents;
    int p_len = 0;
    while(g != a){
     final_paths[a][p_len] = g;
     g = previous[g];
     p_len++;
    }
    final_paths[a][p_len] = a;
    p_len++;
    
    for(int i = 0; i < p_len / 2; i++){
      int tmp = final_paths[a][i];
      final_paths[a][i] = final_paths[a][p_len-i-1];
      final_paths[a][p_len-i-1] = tmp;
    }
  }
}



void calculate_boid_forces(){
  // first boid force get center of mass
  PVector center = new PVector(0,0);
  for(int i = 0; i < num_agents; i++){
    center.add(agent_poses[i]);
  }
  center.div(num_agents);
  for(int i = 0; i < num_agents; i++){
   forces[i].add(center.copy().sub(agent_poses[i]).mult(attraction_coef));
  }
  
  // second boid force repel
  for(int i = 0; i < num_agents; i++){
   for(int j = 0; j < num_agents; j++){
     if(i==j){continue;}
     if(agent_poses[i].dist(agent_poses[j]) < repulsion_thresh){
       PVector diff = agent_poses[i].copy().sub(agent_poses[j]);
       diff.x = 1/diff.x;
       diff.y = 1/diff.y;
       forces[i].add(diff.mult(repulsion_coef));
       //forces[i].add(agent_poses[i].copy().sub(agent_poses[j]).mult(repulsion_coef));
     }
   }
  }
  
  // third boid force match velocity
  PVector center_vel = new PVector(0,0);
  for(int i = 0; i < num_agents; i++){
    center_vel.add(vels[i]);
  }
  center.div(num_agents);
  for(int i = 0; i < num_agents; i++){
   forces[i].add(center_vel.copy().sub(vels[i]).mult(velocity_coef));
  }
}

void calculate_obstacle_forces(){
 for(int i = 0; i < num_agents; i++){
  for(int j = 0; j < num_obstacles; j++){
    float d = agent_poses[i].dist(obstacles[j]);
    if(d < radii[j] + obstacle_thresh){
      forces[i].add(agent_poses[i].copy().sub(obstacles[j]).mult(obstacle_coef/(d-radii[j])));
      //forces[i].add(agent_poses[i].copy().sub(obstacles[j]).mult(obstacle_coef));
    }
  }
 }
}

void calculate_path_forces(){
  for(int i = 0; i < num_agents; i++){
   if(!dones[i]){
      if(points[final_paths[i][current_nodes[i]]].dist(points[final_paths[i][current_nodes[i]-1]]) < agent_poses[i].dist(points[final_paths[i][current_nodes[i]-1]])){
        if(final_paths[i][current_nodes[i]] == num_agents){
          dones[i] = true;
        }
        else{
       current_nodes[i]++; 
        }
      }
    forces[i].add(points[final_paths[i][current_nodes[i]]].copy().sub(agent_poses[i]).normalize().mult(goal_coef));
    }
  }
}


void check_collisions(){
  for(int i = 0; i < num_agents; i++){
    for(int j = 0; j < num_obstacles; j++){
      if(agent_poses[i].dist(obstacles[j]) < radii[j]){
        PVector diff = agent_poses[i].copy().sub(obstacles[j]).normalize();
        agent_poses[i] = obstacles[j].copy().add(diff.mult(radii[j]+ agent_radius));
      }
    }
  }
}

void obstacle_force(){
 for(int i = 0; i < num_agents; i++){
   for(int j = 0; j < num_obstacles; j++){
    float vx = vels[i].x;
    float vy = vels[i].y;
    float lenv = sqrt(vx*vx+vy*vy);
    vx /= lenv; vy /= lenv;
    float cx = obstacles[j].x;
    float cy = obstacles[j].y;
    float wx, wy;
    wx = cx - agent_poses[i].x;
    wy = cy - agent_poses[i].y;
    
    float r = radii[j] + agent_radius;
    float a = 1;  //Lenght of V (we noramlized it)
    float b = -2*(vx*wx + vy*wy); //-2*dot(V,W)
    float c = wx*wx + wy*wy - r*r; //different of squared distances
    
    float d = b*b - 4*a*c; //discriminant 
    
    boolean colliding = false;
    if (d >=0 ){ 
      //If d is positive we know the line is colliding, but we need to check if the collision line within the line segment
      //  ... this means t will be between 0 and the lenth of the line segment
      float t = (-b - sqrt(d))/(2*a); //Optimization: we only need the first collision
      if (t > 0 && t < sight_distance){
        colliding = true;
      }
    }
    if(colliding){
      PVector w = new PVector(wx, wy);
      //println("Angle:", degrees(PVector.angleBetween(vels[i], w)));
      float angle = degrees(atan2(wx, wy) - atan2(vx, vy));
      //println(angle);
      // turn right or left based on angle with obstacle
      if (angle > 0){
        vels[i].add(new PVector(-obstacle_avoid, obstacle_avoid));
      }
      else{
        vels[i].add(new PVector(obstacle_avoid, -obstacle_avoid));
      }
      //if (angle > 0){
      //  vels[i].add(new PVector(-obstacle_avoid, obstacle_avoid).mult(1/(w.mag()-radii[j]-agent_radius)));
      //}
      //else{
      //  vels[i].add(new PVector(obstacle_avoid, -obstacle_avoid).mult(1/(w.mag()-radii[j]-agent_radius)));
      //}
    }
  
   }
 }
}

void cap_velocities(){
 for(int i = 0; i < num_agents; i++){
  if(vels[i].mag() > max_vel){
   vels[i] = vels[i].normalize().mult(max_vel); 
  }
 }
}
//void update(float dt){
//  for(int i = 0; i < num_agents; i++){
//    if(!dones[i]){
//      if(points[final_paths[i][current_nodes[i]]].dist(points[final_paths[i][current_nodes[i]-1]]) < agent_poses[i].dist(points[final_paths[i][current_nodes[i]-1]])){
//        if(final_paths[i][current_nodes[i]] == num_agents){
//          dones[i] = true;
//        }
//        else{
//       current_nodes[i]++; 
//        }
//      }
//    agent_poses[i].add(PVector.mult(points[final_paths[i][current_nodes[i]]].copy().sub(points[final_paths[i][current_nodes[i]-1]]).normalize(), (agent_speeds[i]*dt)));
//    }
//  }
//}

void update(float dt){
  for(int i = 0; i < num_agents; i++){
    forces[i] = new PVector(0,0);
  }
  calculate_boid_forces();
  //calculate_obstacle_forces();
  obstacle_force();
  calculate_path_forces();
  cap_velocities();
  for(int i = 0; i < num_agents; i++){
   vels[i].add(forces[i].mult(dt));
   agent_poses[i].add(vels[i]);
  }
  check_collisions();
}

void make_obstacles(){
  while(!obstacle_clicking){
    //delay(10);
  }
}


//Draw the scene: one sphere per mass, one line connecting each pair
void draw() {
  background(255,255,255);
  PVector translated;
  float radius;
  radius = translate_radius(0.2);
  //stroke();
  if(start_drawn){
    //print("in draw start");
    radius = translate_radius(0.2);
    fill(255, 0, 0);
    translated = translate_coords(start);
    //print("Start:", translated.x, translated.y);
    circle(translated.x, translated.y, radius*2);
   
  }
  if(end_drawn){
    radius = translate_radius(0.2);
    fill(0, 255, 0);
    translated = translate_coords(end);
    circle(translated.x, translated.y, radius*2);
  }
  //fill(255, 0, 0);
  //translated = translate_coords(points[0]);
  //circle(translated.x, translated.y, radius*2);
  if(!obstacle_clicking){
    noStroke();
  fill(0, 0, 255);
  for(int i = 0; i < num_obstacles; i++){
    translated = translate_coords(obstacles[i]);
    radius = translate_radius(radii[i]);
    circle(translated.x, translated.y,radius*2);
  }
  if(drawing_circle){
      //println("Drawing circle");
      translated = obstacles[num_obstacles];
      //translated = translate_coords(obstacles[num_obstacles]);
      //println("translated:", translated);
      //noFill();
      float d = translate_radius(PVector.dist(translated, translate_coords_reverse(new PVector(mouseX, mouseY))));
      //println("distance:", d);
      translated = translate_coords(translated);
      //println("mouse", translate_coords(new PVector(mouseX, mouseY)));
      circle(translated.x, translated.y, d*2);
    }
   return;
  }
  else if(!built_graph){
    for(int i = 0; i < points.length; i++){
   points[i] = new PVector(0,0); 
  }
  for(int i = 0; i < num_agents; i++){
   current_nodes[i] = 1;
   float agent_x, agent_y;
   while(true){
     boolean flag = true;
     agent_x = start.x + random(-1, 1);
     agent_y = start.y + random(-1, 1);
     for(int j = 0; j < i; j++){
      if (new PVector(agent_x, agent_y).dist(points[j]) < 2* agent_radius){
        flag = false;
      }
     }
     if(flag){
       break;
     }
   }
   agent_poses[i] = new PVector(agent_x, agent_y);
   points[i] = new PVector(agent_x, agent_y);
   agent_speeds[i] = 50;
   dones[i] = false;
   //vels[i] = new PVector(.1 + random(-0.025, .025), .1+ random(-0.025, 0.025));
   vels[i] = new PVector(0, 0);
  }
  points[num_agents] = end;
    sample_points();
    build_graph();
    build_heuristic();
    int t1 = millis();
    a_star();
    //ucs();
    int t2 = millis();
    print("Path finding took:", t2-t1);
    built_graph = true;
  }
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
  for(int i = 0; i < num_obstacles; i++){
    translated = translate_coords(obstacles[i]);
    radius = translate_radius(radii[i]);
    circle(translated.x, translated.y,radius*2);
  }
  fill(255, 0, 0);
  for(int i = 0; i < num_agents; i++){
    translated = translate_coords(agent_poses[i]);
    radius = translate_radius(agent_radius);
    circle(translated.x, translated.y, radius*2);
  }
  
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
  for(int i = 0; i < num_agents; i++){
    if(draw_lines){
      stroke(255, 0, 0);
      int j = 1;
      PVector p1 = points[final_paths[i][0]];
      PVector p2 = points[final_paths[i][1]];
      p1 = translate_coords(p1);
      p2 = translate_coords(p2);
      line(p1.x, p1.y, p2.x, p2.y);
      //while(j < final_paths[i].length - 1 && final_paths[i][j+1] != 0){
        while(final_paths[i][j+1] != 0){
        //delay(500);
        p1 = points[final_paths[i][j]];
        p2 = points[final_paths[i][j+1]];
        p1 = translate_coords(p1);
        p2 = translate_coords(p2);
        line(p1.x, p1.y, p2.x, p2.y);
        j++;
      }
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
  
  if (key == 'd') obstacle_clicking = true;
  
}

void mouseClicked() {
  if(mouseButton == RIGHT && num_obstacles > 0 && end_drawn){
   obstacles[num_obstacles-1] = translate_coords_reverse(new PVector(mouseX, mouseY));
   return;
  }
  if(!start_drawn){
    start_drawn = true;
    start = translate_coords_reverse(new PVector(mouseX, mouseY));
    //print("Start click", mouseX, mouseY);
  }
  else if(!end_drawn){
    end_drawn = true;
    end = translate_coords_reverse(new PVector(mouseX, mouseY));
  }
  else if(!drawing_circle && !obstacle_clicking){
    drawing_circle = true;
    obstacles[num_obstacles] = translate_coords_reverse(new PVector(mouseX, mouseY));
    //print("Translated:", obstacles[num_obstacles]);
    //print("Beginning obstacle draw");
  }
  else if(drawing_circle){
   float x = mouseX;
   float y = mouseY;
   float r = PVector.dist(obstacles[num_obstacles], translate_coords_reverse(new PVector(x, y)));
   radii[num_obstacles] = r;
   num_obstacles++;
   drawing_circle = false;
   //print("Drew obstacle at", x, y, r);
  }
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
