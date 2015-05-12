import ddf.minim.analysis.*;
import ddf.minim.*;
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

void setup()
{
  size(512, 512);
  
  minim = new Minim(this);
  
  // make an audio in
  in = minim.getLineIn();
  
  // make an FFT
  fft = new FFT( in.bufferSize(), in.sampleRate() );
  
}

void draw()
{
  background(0);
  
  stroke(255);
  
  ellipse(width/2, yPosition, 100, 100);
  
  // perform a forward FFT on the samples
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
    if( yPosition > 512 ) {
      yPosition += 10;
    } else {
      yPosition += 400;
    }
  }
  
  // do a really simple movement
  yPosition -= 1;
   
}
