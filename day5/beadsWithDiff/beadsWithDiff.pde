
/* This is "lesson 3" from the Beads sound library
 hacked to accept a read value from the Arduino using
 the sensor PID function, instead of the original mouse movement.
 
 function: differentiation only.
 sensitive, faster, susceptible to noise.
 
 Tom Jennings
 11 Jan 2012
 
 */




import beads.*;

AudioContext ac;
Glide carrierFreq, modFreqRatio;
int xPos;

seDiff di;

void setup() {

  seArduino();                   // connect to the Arduino
  di= new seDiff();           //
  di.dlen (10);
  di.setThresh (1);
  di.setGain (10);

  size(300, 300);
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
color back = color(0, 0, 0);

/*
 * Just do the work straight into Processing's draw() method.
 */
void draw() {

  if (ardValid) {
    int output= di.diff(ardVals[0]);                // CdS/resistor sensor on analog 0
    if (output != 0) { 
      print ("diff("); 
      print (ardVals[0]);  
      print (")= "); 
      println (output);
    }
    carrierFreq.setValue((float)output / width * 1000 + 50);
    modFreqRatio.setValue((1 - (float)100 / height) * 10 + 0.1);  // whatever
    
    output *= 10;                  // make more visible
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

