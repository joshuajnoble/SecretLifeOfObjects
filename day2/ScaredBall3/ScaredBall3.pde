
import ddf.minim.analysis.*;
import ddf.minim.*;
import de.looksgood.ani.*;

// points
PVector point, target;
int eyeSizeL, eyeSizeR;

// our main minim
Minim minim;

// the thing that will look at the different frequencies
FFT fft;

// where we'll keep track of all the differences between frames
float[] differenceBuffer = new float[64];

// how we'll keep track of where in that buffer we're writing those differences
int differenceIndex;

// the actual audio input
AudioInput in;
int yPosition = 0;

// how long to wait before coming back
int wait = 0, lastWait = 0;

// simple way to keep track of state machine
static final int SCARED = 0, NOT_SCARED = 1;
int state = NOT_SCARED;


void setup()
{
  size(512, 512);
  
  // make a minim
  minim = new Minim(this);
  
  // have locations for things
  point = new PVector(width/2, height/2);
  target = new PVector(width/2, height/2);
  
  // make an audio in
  in = minim.getLineIn();
  //in.enableMonitoring();
  
  // make an FFT
  fft = new FFT( in.bufferSize(), in.sampleRate() );
  Ani.init(this);
  
  eyeSizeL = 10;
  eyeSizeR = 10;
  
}

void draw()
{
  background(122);
 
  noStroke();
  
  fill(0);
  ellipse(point.x, point.y, 200, 200);
  
  // eyes
  fill(255);
  ellipse(point.x - 50, point.y - 20, eyeSizeL, eyeSizeL);
  ellipse(point.x + 50, point.y - 20, eyeSizeR, eyeSizeR);
  
  // perform a forward FFT on the samples in jingle's mix buffer,
  // which contains the mix of both the left and right channels of the file
  fft.forward( in.mix );
  
  float diff = 0;
  
  for(int i = 0; i < fft.specSize(); i++) {
    diff += fft.getBand(i);
  }
  
  // store the difference in a buffer
  differenceBuffer[differenceIndex] = diff;
 
  // advance the buffer
  differenceIndex++;
  if(differenceIndex > 63) {
     differenceIndex = 0;
  }
 
  // now let's figure out how different things are over the last few milliseconds
  diff = 0;
 
  for(int i = 1; i < 63; i++) {
    diff += abs(fft.getBand(i) - fft.getBand(i-1));
  }
  
  // if it's too loud, it's scary, hide
  if( diff > 100) {
    
      target.set(width/2, height + 100);
      
      Ani.to(this, 1.0f, "eyeSizeL", (diff/5.0) + random(1, 10));
      Ani.to(this, 1.0f, "eyeSizeR", (diff/5.0) + random(1, 10));
      
      wait = ( int(diff) - 100) * 5;
      lastWait = millis();
      
      state = SCARED;
  }
  
  if( state == SCARED)
  {
    
    if( millis() - lastWait > wait)
    {
       Ani.to(this, 1.0f, "eyeSizeL", 10 + random(1, 4), Ani.QUART_OUT, "finished");
       Ani.to(this, 1.0f, "eyeSizeR", 10 + random(1, 4), Ani.QUART_OUT, "finished");
    }
    
  }
   
}

void finished()
{
  state = NOT_SCARED;
}
