import beads.*;

// create our AudioContext
AudioContext ac;

// declare our unit generators (Beads) since we will need to access them throughout the program
WavePlayer wp1;
Glide frequencyGlide1;
WavePlayer wp2;
Glide frequencyGlide2;

Gain g;

void setup()
{
  size(400, 300);

  ac = new AudioContext(); // init
  
  // frequency = 20 (Hz) + transition time = 50ms
  frequencyGlide1 = new Glide(ac, 20, 50);
  
  // create a WavePlayer, attach the frequency to frequencyGlide
  wp1 = new WavePlayer(ac, frequencyGlide1, Buffer.SINE);

  // create the second frequency glide and attach it to the frequency of a second sine generator
  frequencyGlide2 = new Glide(ac, 20, 50);
  wp2 = new WavePlayer(ac, frequencyGlide2, Buffer.SINE);

  // create a Gain object to make sure we don't peak
  g = new Gain(ac, 1, 0.5);

  // connect both WavePlayers to the Gain input
  g.addInput(wp1);
  g.addInput(wp2);
  
  // connect the Gain output to the AudioContext
  ac.out.addInput(g);
  
  // start audio processing
  ac.start();
}

void draw()
{
  // update the frequency based on the position of the mouse cursor within the Processing window
  frequencyGlide1.setValue(mouseY);
  frequencyGlide2.setValue(mouseX);
}
