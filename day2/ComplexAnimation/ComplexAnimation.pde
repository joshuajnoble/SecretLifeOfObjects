import de.looksgood.ani.*;
float x,y,w,h;
float hue,s,v;

void setup() {
  size(512,512);
  smooth();
  noStroke();

  x = 0;
  y = height/2;
  w = 10;
  h = 10;

  Ani.init(this);
  Ani.to(this, 2.5, "x:500,y:256,w:400,h:410,hue:100,s:100,v:100", Ani.SINE_IN_OUT);
  
  colorMode(HSB, 100);
}

void draw() {
  background(0,0,0);
  fill(hue,s,v);
  ellipse(x,y,w,h);
}





