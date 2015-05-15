
/* This is "lesson 3" from the Beads sound library
hacked to accept a read value from the Arduino using
the sensor PID function, instead of the original mouse movement.

function: PID response. 
decent compromise of speed and noise usceptibility. tuneable.


Tom Jennings
11 Jan 2012

*/




import beads.*;

AudioContext ac;
Glide carrierFreq, modFreqRatio;

sePID pid;      // PID sensor object
int xPos;

void setup() {
  
  seArduino();                   // connet to the Arduino
  pid = new sePID();
  pid.setKg (20);               // makes event larger; "-" if sensor change goes LOW
  pid.setKd (14);                // larger (> 20) makes it sensitive to changes
  pid.setKt (3);                 // threshhold; set above "noise" (output on no input)
  
  size(300,300);
  ac = new AudioContext();
  /*
   * This is a copy of Lesson 3 with some mouse control. 
   */
   //this time we use the Glide object because it smooths the mouse input.
  carrierFreq = new Glide(ac, 500);
  modFreqRatio = new Glide(ac, 1);
  Function modFreq = new Function(carrierFreq, modFreqRatio) {
    public float calculate() {
      return x[0] * x[1];
    }
  };
  WavePlayer freqModulator = new WavePlayer(ac, modFreq, new SineBuffer().getDefault());
  Function carrierMod = new Function(freqModulator, carrierFreq) {
    public float calculate() {
      return x[0] * 400.0 + x[1];    
    }
  };
  WavePlayer wp = new WavePlayer(ac, carrierMod, new SineBuffer().getDefault());
  Gain g = new Gain(ac, 1, 0.1);
  g.addInput(wp);
  ac.out.addInput(g);
  ac.start();
}

/*
 * The drawing code also has some mouse listening code now.
 */
color fore = color(255, 102, 204);
color back = color(0,0,0);

/*
 * Just do the work straight into Processing's draw() method.
 */
 void draw() {

  if (ardValid) {
    int output= pid.PIDf(ardVals[0]);                // CdS/resistor sensor on analog 0
    if (output != 0) { 
      print ("PID("); 
      print (ardVals[0]);  
      print (")= "); 
      println (output);
    }
    carrierFreq.setValue((float)output / width * 1000 + 50);
    modFreqRatio.setValue((1 - (float)100 / height) * 10 + 0.1);  // whatever
    
    output *= 2;                  // make more visible
    output += 512;  
    float inByte = map(output, 0, 1023, 0, height);
    stroke(127, 34, 255);
    line(xPos, height, xPos, height - inByte);
    if (xPos >= width) {
      xPos = 0;
      background(0);
    }
    else {
       xPos++;
    }
    ardValid= false;
  }
}

