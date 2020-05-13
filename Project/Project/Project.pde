Player P = new Player();
boolean left_pressed = false;
boolean right_pressed = false;
ArrayList<Platform> platforms = new ArrayList<Platform>();
ArrayList<Jetpack> jetpacks = new ArrayList<Jetpack>();
ArrayList<Prop> props = new ArrayList<Prop>();
int platform_width = 40;
int platform_height = 5;
float player_radius = 20;
PImage jetpack_off, jetpack_left, jetpack_right;
ArrayList<PImage> prop = new ArrayList<PImage>();
int num_images = 58;
int frame_counter = 0;

void setup() 
{
  noSmooth();
  int x_dim = 400;
  int y_dim = 700;
  size(400, 700);
  //frameRate(30);
  makePlatforms();
  jetpack_off = loadImage("jetpack.png");
  jetpack_left = loadImage("jetpack_left.png");
  jetpack_right = loadImage("jetpack_right.png");
  for(int i = 0; i < num_images; i++){
    //PImage tmp = loadImage("prop4/ccaf7d760bde4774e927bb7064d2cf584EK5EpdiLbBz0SD8-"  + str(i) + ".png");
    //PImage tmp = loadImage("prop3/22a4822319c141abe418f71d9a511f02EvPG1Cp4riOLsjet-"  + str(i) + ".png");
    PImage tmp = loadImage("prop/f36390d68c9b472eef9067066c4826c6qj7gJIQrNgpWy2bm-" + str(i) + ".png");
    //PImage tmp = loadImage("prop2/8f0d05067600405380cbbc15c355be48tnmlvn0fuchBd1RB-" + str(i) + ".png");
    tmp.resize(13, 9);
    //tmp.resize(13, 10);
    prop.add(tmp);
  }
}

void draw() { 
  background(210, 250, 210);
  //background(255,255,255);
  imageMode(CENTER);
  stroke(0,0,0);
  P.update(.13);
  fill(255,255,255);
  drawPlayer();
  fill(0,0,0);
  drawPlatforms();
  drawJetpacks(.13);
  //fill(255, 255, 255);
  fill(0,0,0);
  drawProps();
  //drawProp();
  //h1.update(); 
  //h2.update();  
} 


void drawProps(){
  for(int i = 0; i < props.size(); i++){
    Prop p = props.get(i);
    //fill(0,0,0);
    //rect(j.x + int(platform_width/2), j.y, 10, -20);
    if(p.on || p.deaccel){
        p.x = P.x+1;
        p.y = P.y - 10;
        //j.gen.minX = P.x-7;
        //j.gen.maxX = P.x-13;
        //j.gen.genRate -= 10;
        //p.x = P.x - 10;
        //p.y = P.y;
        //j.gen.y = P.y+20;
        p.velx = P.velx;
        p.vely = P.vely;
        //image(jetpack_right, P.x - 10, P.y, 10, 40);
        noStroke();
        fill(0,0,0);
        image(prop.get(frame_counter), p.x, p.y, 20, 15);
        frame_counter = (frame_counter +2) % num_images;
    //}else if(j.deaccel){
    //  j.velx = 0;
    //  j.vely += .01;
    //  int r = j.deaccel_counter;
    //  pushMatrix();
    //  //rotate(r*20);
    //  image(jetpack_off, j.x, j.y, 20, 40);
    //  popMatrix();
    }
    //}else if(j.done){
    //  //P.jetpack = false;
    //  image(jetpack_left, j.x, j.y, 10, 40);
    //}
    else{
      image(prop.get(0), p.x + int(platform_width/2), p.y - 20, 20, 15);
    }
  }
}

//void drawProp(){
//  P.vely = -100;
//  float x = P.x+1;
//  float y = P.y - 10;
//  noStroke();
//  fill(0,0,0);
//  //image(prop.get(frame_counter), x, y, 13, 9);
//  image(prop.get(frame_counter), x, y, 20, 15); // good
//  //image(prop.get(frame_counter), x, y, 20, 20);
//  frame_counter = (frame_counter +2) % num_images;
  
//}

void drawPlayer(){
  if(P.squash){
    //ellipse(P.x, P.y, 22-P.squash_counter, 18+P.squash_counter);
    ellipse(P.x, P.y, 25-P.squash_counter, 20+P.squash_counter);
    P.squash_counter += 1;
    if(P.squash_counter > P.squash_limit){
      P.squash = false;
      P.squash_counter = 0;
    }
  }else{
  circle(P.x, P.y, player_radius);
  }
}
 
void makePlatforms(){
  //platforms.add(new Platform(200, 650, 0));
  //platforms.add(new Platform(100, 550, 0));
  //platforms.add(new Platform(150, 450, 0));
  platforms.add(new Platform(P.x, P.y, 0));
  for(int i = 0; i < 10000; i++){
    platforms.add(new Platform(200 + random(-150, 150), -100*(i-5) + random(-50, 50), 0));
  }
}

void drawPlatforms(){
  for(int i = 0; i < platforms.size(); i++){
    Platform p = platforms.get(i);
    rect(p.x, p.y, platform_width, platform_height);
    
  }
}

void drawJetpacks(float dt){
  for(int i = 0; i < jetpacks.size(); i++){
    Jetpack j = jetpacks.get(i);
    //fill(0,0,0);
    //rect(j.x + int(platform_width/2), j.y, 10, -20);
    if(j.on || j.deaccel){
      if (P.velx >= 0){
        j.gen.minX = P.x-13;
        j.gen.maxX = P.x-7;
        //j.gen.genRate -= 10;
        j.x = P.x - 10;
        j.y = P.y;
        j.gen.y = P.y+20;
        j.velx = P.velx;
        j.vely = P.vely;
        //image(jetpack_right, P.x - 10, P.y, 10, 40);
        image(jetpack_right, j.x, j.y, 10, 40);
      }else{
        j.gen.minX = P.x + 7;
        j.gen.maxX = P.x+13;
        j.x = P.x + 10;
        j.y = P.y;
        j.velx = P.velx;
        j.vely = P.vely;
        j.gen.y = P.y+20;
        //image(jetpack_left, P.x + 10, P.y, 10, 40);
        image(jetpack_left, j.x, j.y, 10, 40);
      }
      j.gen.on(0, 0, dt);
      j.gen.drawParticles();
      //redraw();
      //fill(255, 255, 255);
    //}else if(j.deaccel){
    //  j.velx = 0;
    //  j.vely += .01;
    //  int r = j.deaccel_counter;
    //  pushMatrix();
    //  //rotate(r*20);
    //  image(jetpack_off, j.x, j.y, 20, 40);
    //  popMatrix();
    }else if(j.done){
      //P.jetpack = false;
      image(jetpack_left, j.x, j.y, 10, 40);
    }
    else{
      image(jetpack_off, j.x + int(platform_width/2), j.y - 20, 20, 40);
    }
  }
}
 

class Player { 
  float start_x_vel_low = -10;
  float start_x_vel_high = 10;
  float start_y_vel_low = -30;
  float start_y_vel_high = -70;
  float start_x_low = 150;
  float start_x_high = 200;
  float start_y =  600;
  float x, y, velx, vely, h; 
  boolean jetpack = false;
  boolean prop = false;
  boolean squash = false;
  int squash_counter = 0;
  int squash_limit = 2;
  
  Player () {  
    x = random(start_x_low, start_x_high);
    y = start_y;
    velx = random(0, 0);
    vely = random(start_y_vel_low, start_y_vel_high);
    h = 50;
  } 
  void update(float dt) { 
    if(left_pressed){
     velx -= 6; 
    }else if(right_pressed){
      velx += 6;
    }
    float a = 9.8;
    vely += a*dt;
    if (velx < -.1){
      velx += .1;
    }else if (velx > .1){
      velx -= .1;
    }else{
      velx = 0;
    }
    vel_decay();
    vel_max();
    x += velx*dt;
    y += vely*dt;
    //h += vely*dt;
    
    check_for_collisions();
    check_platforms(dt);
    check_screen_adjust(dt);
    check_game_over();
    check_jetpack(dt);
    check_props(dt);
} 

  void check_jetpack(float dt){
    int remove = -1;
    for(int i =0; i < jetpacks.size(); i++){
      Jetpack j = jetpacks.get(i);
      //image(jetpack_right, P.x - 10, P.y, 10, 40);
      if(sqrt(sq(j.x + 10 - x) + sq(j.y - 20 - y)) < 20 && !j.done && !jetpack && !prop){
        print("ACTIVATING JETPACK");
        j.on = true;
        jetpack = true;
      }
      if(j.on || j.deaccel || j.done){
      boolean good = j.update(dt);
      if(!good){
        jetpack = false;
        remove = i;
      }
      }
    }
    if(remove != -1){
      jetpacks.remove(remove);
    }
  }
  
  void check_props(float dt){
    int remove = -1;
    for(int i =0; i < props.size(); i++){
      Prop p = props.get(i);
      //image(jetpack_right, P.x - 10, P.y, 10, 40);
      if(sqrt(sq(p.x + 10 - x) + sq(p.y - 20 - y)) < 20 && !p.done && !prop && !jetpack){
        print("ACTIVATING PROPHAT");
        p.on = true;
        prop = true;
      }
      if(p.on || p.deaccel || p.done){
      boolean good = p.update(dt);
      if(!good){
        prop = false;
        remove = i;
      }
      }
    }
    if(remove != -1){
      props.remove(remove);
    }
  }

  void check_game_over(){
    if (y > 700 + player_radius){
      background(0,0,0); 
      while(platforms.size() > 0){
        platforms.remove(0);
      }
      while(jetpacks.size() > 0){
        jetpacks.remove(0);
      }
      while(props.size() > 0){
       props.remove(0); 
      }
      print("Score:", int(h));
      exit();
    }
  }

  void check_screen_adjust(float dt){
      if (y < (700/2)){
       h += ((700/2) - y);
       y = (700/2);
       for(int i = 0; i < platforms.size(); i++){
         Platform p = platforms.get(i);
         p.y -= int(vely*dt);
       }
       for(int i = 0; i < jetpacks.size(); i++){
         Jetpack j = jetpacks.get(i);
         j.y -= int(vely*dt);
       }
       for(int i = 0; i < props.size(); i++){
         Prop p = props.get(i);
         p.y -= int(vely*dt);
       }
      }
    
    
  }


  void check_for_collisions(){
    if (x<0){
     x += 400;
    }
    else if (x>400){
     x = x % 400;
    }
  }
  
  void vel_decay(){
    velx *= 0.95;
  }
  void vel_max(){
    float x_vel_max = 30;
    if (velx > x_vel_max){
     velx = x_vel_max; 
    }else if (velx < -x_vel_max){
      velx = -x_vel_max;
    }
  }
  
  void check_platforms(float dt){
    float fuzz = 25;
   for(int i = 0; i < platforms.size(); i++){
     Platform p = platforms.get(i);
     float y_tmp = y + player_radius;
   if ((x > p.x) && (x < (p.x + platform_width)) && (y_tmp - (vely*dt) < p.y) && (y_tmp  > p.y)){
     squash = true;
     y = p.y + 10 - player_radius;
     vely = -65;
   }
  }
}
}

class Platform{
  float x;
  float y;
  float h;
  int type;

  Platform(float xx, float yy, int tt){
   x = xx;
   y = yy;
   type = tt;
   if(type == 0){
    float jetpack_threshold = 0.25;
    float prop_threshold = 0.07;
    if(random(0, 1) < jetpack_threshold){
      print("CREATING JETPACK");
      Jetpack j = new Jetpack(x, y);
      jetpacks.add(j);
   } else if(random(0,1) < prop_threshold){
     print("CREATING PROP HAT");
     Prop p = new Prop(x, y+13);
     props.add(p);
   }
     
  }
  
}
}

class Prop {
  float x, y;
  boolean on = false;
  boolean deaccel = false;
  boolean done = false;
  int counter = 0;
  int limit = 200;
  float velx, vely;
  int done_counter = 0;
  
  Prop(float xx, float yy){
     x = xx;
     y = yy;
  }
  
  boolean update(float dt){
    if(on){
     P.vely = -200;
     counter += 1;
     if(counter > limit){
       on = false;
       deaccel = true;
     }
    }
    if(deaccel){
        P.vely += 15;
      if(P.vely > -30){
        deaccel = false;
        done = true;
      }
    }
      if(done){
       velx = 25;
       vely += 5;
       x += velx*dt;
       y += vely*dt;
       done_counter += 1;
       if(done_counter == 100){
         return false;
       }
      }
    return true;
  }
}
 

class Jetpack{
    float x, y;
    boolean on = false;
    boolean deaccel = false;
    boolean done = false;
    int counter = 0;
    int limit = 150;
    int done_counter = 0;
    float velx=0, vely=0;
    float deaccel_grav = 9.8;
    ParticleGenerator gen;
    
    Jetpack(float xx, float yy){
      x = xx;
      y = yy;
      gen = new ParticleGenerator(x, x+10, y, 0);
    }
    
    boolean update(float dt){
      if(on){
        //gen.on(x, y, dt);
        P.vely = -500;
        counter += 1;
        if(counter > limit){
          on = false;
          deaccel = true;
        }
      }
      if(deaccel){
        //gen.on(x, y, dt);
        P.vely += 15;
      }
      if(P.vely > -30){
        deaccel = false;
        done = true;
      }
      if(done){
       velx = 25;
       vely += 5;
       x += velx*dt;
       y += vely*dt;
       done_counter += 1;
       if(done_counter == 100){
         return false;
       }
      }
      return true;
        //if(deaccel_counter == 0){
        //  velx = P.velx*1.5;
        //  vely = P.vely;
        //}else if(deaccel_counter < 10){
        //  vely = P.vely;
        //  velx = P.velx * 1.2;
        //}
      //  deaccel_counter ++;
      //  if(deaccel_counter <= 65){
      //    P.vely += 15;
      //  //}else{
      //  //  x += velx*dt;
      //  //  y += vely*dt;
      //  //}
      //}
      //  if(P.vely < 0){
      //    y = P.y;
      //  }else{
      //    vely += 9.8*dt;
      //    x += vely*dt;
      //  }
      //  //vely += 15;
      //  //x += velx*dt;
      //  //y -= vely*dt;
      //  if (deaccel_counter > deaccel_limit){
      //    deaccel = false;
      //    done = true;
      //  }
      //}
    }
}

void keyPressed() {
  if(keyCode == LEFT){
    left_pressed = true;
  }else if (keyCode == RIGHT){
    right_pressed = true;
  }
}

void keyReleased() {
  if(keyCode == LEFT){
    left_pressed = false;
  }else if (keyCode == RIGHT){
    right_pressed = false;
  }
}

void mouseClicked(){
 print(mouseX, mouseY); 
}


class ParticleGenerator{
  int type;
  float minX, maxX, y;
  float genRate = 100;
  int jetpack_length = 10;
  float x_vel_l = -5;
  float x_vel_h = 5;
  float y_vel_l = 4;
  float y_vel_h = 7;
  PVector starting_color = new PVector(255, 0, 0);
  ArrayList<Particle> particles= new ArrayList<Particle>();
  
  ParticleGenerator(float minx, float maxx, float yy, int t){
   type = t; 
   minX = minx;
   maxX = maxx;
   y = yy;
  }
  void on(float x, float y, float dt){
    //println("IN ON", x, y);
    generate_particles(dt);
    move_particles(dt);
  }
  
  void move_particles(float dt){
    //println("IN MOVE");
    int tmp = particles.size();
    for(int i = 0; i < tmp; i++){
      Particle part = particles.get(i);
      if(!part.move(dt)){
        particles.remove(i);
        i -= 1;
        tmp -= 1;
      }
    }
  }
  
  void generate_particles(float dt){
    //println("IN GENERATE");
    int numParticles = int(dt*genRate);
    for(int i = 0; i < numParticles; i++){
      //print("Generating particles");
      float x = random(minX, maxX);
      particles.add(new Particle(x, y, random(x_vel_l, x_vel_h), random(y_vel_l, y_vel_h), starting_color));
    }
  }
  
  void drawParticles(){
    //println("Particles length:", particles.size());
    //for(Particle part : particles){
    //  part.draw_particle();
    //}
    int tmp = particles.size();
    for(int i = 0; i < tmp; i++){
      Particle p = particles.get(i);
      p.draw_particle();
      //print(p.position);
    }
  }
}

class Particle{
  PVector position, velocity, colors;
  int lifespan=200;
  int alive = 0;
  Particle(float x, float y, float xvel, float yvel, PVector colorss){
    //println("GEN", x, y, xvel, yvel);
    position = new PVector(x, y);
    velocity = new PVector(xvel, yvel);
    colors = colorss.copy();
  }
  
  void draw_particle(){
    //noSmooth();
    //fill(255, 0, 0);
    //fill(colors.x, colors.y, colors.z, lifespan-alive);
    //stroke(colors.x, colors.y, colors.z, lifespan-alive);
    stroke(colors.x, colors.y, colors.z, lifespan-alive);
    //println("X:", position.x);
    //println("Y:", position.y);
    point(position.x, position.y);
  }
  
  boolean move(float dt){
    alive += 1;
    if(alive > lifespan){
      return false;
    }
    position.add(velocity.copy().mult(dt));
    //colors.x -= 3;
    colors.y += 5;
    return true;
  }
}
