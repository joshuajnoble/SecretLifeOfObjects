
import de.looksgood.ani.*;

float x, y, h, w, hue, a, r;

AniSequence seq;

void setup() {
  size(512,512);
  smooth();
  noStroke();
  textAlign(CENTER);
  background(255);

  x = 50;
  y = 50;
  h = 100;
  w = 100;
  a = 10;

  // Ani.init() must be called always first!
  Ani.init(this);

  // create a sequence
  seq = new AniSequence(this);
  
  // start all the things that the sequence will contain
  seq.beginSequence();
  
  // simple stuff first
  seq.add(Ani.to(this, 0.5, "w", 55));
  
  // simple stuff first
  seq.add(Ani.to(this, 0.5, "h", 55));
  
  // back to normal
  seq.add(Ani.to(this, 2, "h:100,w:100"));
  
  // step 1
  seq.add(Ani.to(this, 2, "w:120,h:90,a:15"));
  
  // step 2
  seq.add(Ani.to(this, 2, "x:400,y:100,r:3.1415,a:6"));
  
  // step 3
  seq.add(Ani.to(this, 1, "x:350,y:400,r:-3.1415,a:12"));
  
  // elongate because you're spinning so fast
  seq.add(Ani.to(this, 3, "w:80,h:120,hue:70,r:25.1326"));
  
  // pop back
  seq.add(Ani.to(this, 1, "h:100,w:100,hue:100"));
  
  // step 4
  seq.add(Ani.to(this, 1, "x:100,y:450,h:40,w:40,r:0,a:40"));
  
  // step 5
  seq.add(Ani.to(this, 1, "x:50,y:50,h:100,w:100"));
  
  // step 6
  seq.add(Ani.to(this, 1, "h:100,w:100"));

  seq.endSequence();

  // start the whole sequence
  seq.start();
}

void draw() {
  
  colorMode(RGB, 255);
  
  fill(255,a);
  rect(0,0,width,height);
  
  colorMode(HSB, 100);
 
  pushMatrix();
    translate(x,y); // translate instead of drawing in a particular place so that we can rotate
    rotate(r); // spin the world
    fill(hue, 100, 100);
    rect(0, 0, w, h); // why draw at 0,0? Because we're transforming so we can rotate
  popMatrix();
}

// pause and resume animation by pressing SPACE
// or press "s" to start the sequence
void mousePressed() { 
  if (seq.isEnded())
  { 
    // start the whole sequence
    seq.start();
  }
}






