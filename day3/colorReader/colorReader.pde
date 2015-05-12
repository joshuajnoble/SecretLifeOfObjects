import processing.video.*;

Capture video;

static final int hueRange = 360; 

float saturation;
float brightness;
float dominantHue;

void setup()
{
  
  video = new Capture(this, 160, 120);
 
  // Start capturing the images from the camera
  video.start();  

  //colors = new int[(video.width * video.height) / (increment * increment)];
  
  size(400, 400);
  
}

void draw()
{
 
  int brightest = 0;
  float brightestBrightness = 0;
  
  int index = 0;
  
  if (video.available()) {
    
    video.read();
    video.loadPixels();
  
    int numberOfPixels = video.pixels.length;
    int[] hues = new int[hueRange];
    float[] saturations = new float[hueRange];
    float[] brightnesses = new float[hueRange];

    for (int i = 0; i < numberOfPixels; i++) {
      int pixel = video.pixels[i];
      int hue = Math.round(hue(pixel));
      float saturation = saturation(pixel);
      float brightness = brightness(pixel);
      hues[hue]++;
      saturations[hue] += saturation;
      brightnesses[hue] += brightness;
    }

    // Find the most common hue.
    int hueCount = hues[0];
    int hue = 0;
    for (int i = 1; i < hues.length; i++) {
       if (hues[i] > hueCount) {
        hueCount = hues[i];
        hue = i;
      }
    }

    // Set the vars for displaying the color.
    dominantHue = hue;
    saturation = saturations[hue] / hueCount;
    brightness = brightnesses[hue] / hueCount;
  }
  
  colorMode(HSB, 100);
  fill(dominantHue, saturation, brightness);
  rect( 0, 0, width, height );
  
}
