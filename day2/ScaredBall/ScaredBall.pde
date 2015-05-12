import ddf.minim.analysis.*;
import ddf.minim.*;
// our main minim
Minim minim;

// the actual audio input
AudioInput in;
int yPosition = 0;

boolean hide = false;
int hidingTime = 0;

void setup()
{
  size(512, 512);
  
  minim = new Minim(this);
  
  yPosition = height/2;
  
  // make an audio in
  in = minim.getLineIn();
}

void draw()
{
  background(0);
  stroke(255);
  
  ellipse(width/2, yPosition, 100, 100);
  
  float soundSum = 0;
  
  for(int i = 0; i < in.bufferSize(); i++)
  {
    soundSum += in.left.get(i);
    soundSum += in.right.get(i);
  }

  // if it's too loud, it's scary, hide
  if( soundSum > 1.0) {
      hide = true;
      hidingTime = millis();
  }
  
  // some really simple movements based on whether we're hiding or not
  if(hide == true)
  {
    if(yPosition < 500) //here's where we go to hide 
    {
      yPosition += 40;
    }
    
    if(millis() - hidingTime > 5000) {
      hide = false;
    }
  }
  else if(yPosition > height/2)
  {
    yPosition -= (550 - height/2)/100;
  }
   
}
