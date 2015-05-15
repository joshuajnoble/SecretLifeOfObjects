

/*******************************************************************
 
 sePID: Proportional Integral Derivative 
 for ratiometric sensor event processing.
 
 s1= new sePID ();
 setKi (n);        // set Ki, integral scaler (and implicitly, Kp to -Ki) default: 1
 setKd (n);        // set Kd, derivative scaler (default: -1)
 setG (n);         // set output gain SEE NOTE (applied after threshhold) default: -20
 setKt (n);        // set output threshhold (default= 5)
 
 setIlen (n);      // set input smoothing default: 1= none
 setOlen (n);      // set output smoothing default: 1= none
 
 NOTE: subsequent (optional) code that turns the processed analog signal
 assumes that the initial change is in a positive direction; if the sensor
 generates negative-going voltages on stimuli, set gain to a negative value.
 
 s1.sePID(n);        // main function
 
 */


class sePID {

  int Ki = 1;
  int Kp = -Ki;             // Ki/Kp must be -1, since we have no control term, we seek output=0
  int Kd = 1;
  int Kg = 1;
  int Kt = 5;

  int integral, derivative, output;

  seAverage aIn = new seAverage();         // input smoothing filter
  seAverage aOut = new seAverage();        // output smoothing
  seDiff fd = new seDiff();                // main function differential
  seAverage fi = new seAverage();          // main function integrator
  seEventGunk ev = new seEventGunk();

  // constructor
  public void PID () {

    // input and output filters
    aIn.len (1);                   // no input smoothing
    aOut.len (1);

    // main function
    fd.dlen (4);                   // 4-deep differentiator
    fi.len (10);                   // 10-deep integrator
  }

  public void setIlen (int n) { aIn.len (n); }
  public void setOlen (int n) { aOut.len (n); }
  public void setKi (int n) { Ki= n; Kp= -Ki; }
  public void setKd (int n) {  Kd= n; }
  public void setKg (int n) { Kg= n; }
  public void setKt (int n) { Kt= n; }  

  // Main function.
  public int PIDf (int n) {

    n= aIn.average(n);               // do some smoothing first
    derivative= fd.diff(n);           // differential (amplifies short-term change)
    integral= fi.average(n);          // integral (since N arrives periodically)
    output = (Kp * n) + (Ki * integral) + (Kd * derivative);
    output= aOut.average(output);     // (optional) output smoothing
    if (abs(output) < Kt) output= 0;  // threshhold it,
    return (output * Kg);             // apply gain after threshhold
  }
  
  // As a zero-crossed event.
  public boolean PIDz (int n) {
    return (ev.zeroCross (PIDf (n)));
  }
  
  // Return width of event.
  public int PIDw (int n) {
    return (ev.eventWidth (PIDf (n)));
  }  
}




//Perform two sequential differentiation/integration series on
//a sensor input stream, return true when the resulting double-differentiation
// crosses zero, eg. the centroid of the event.

class seDiffIntTwice {
  seDiff s1 = new seDiff();
  seDiff s2 = new seDiff();
  seAverage a1 = new seAverage();
  seAverage a2 = new seAverage();
  
  seEventGunk se = new seEventGunk();

  int gain;                    // first diff/int multiplier (gain)

  // Constructor.
  public void seDiffIntTwice () {
    gain= 2;
    s1.dlen(4); a1.len (8);     // first pair
    s2.dlen (2); a2.len (4);    // second pair
  }

  // Set gain.
  public void setGain (int n) { 
    gain= n;
  }


  // Return the twice-diff/int'ed sensor event value, before gain.
  public int diffIntTwice (int v) {
    return (a2.average (s2.diff (a1.average (s1.diff (v)))));
  }
}





//Serial differentation/integration
//for detecting change events in serial sensor data.
 
class seDiff {

  // History buffers contain N datums, plus overhead:
  //    length-1: index  
  //    length-2: running sum  
  //    length-3: most recent (d only)
  int[] d= new int[2+2];       // differentiator history
  seAverage a = new seAverage();
  int gain = 1;
  int thresh = 0;              // below this value events are not returned

  // Constructor.
  public seDiff () {
    a.len (10);                 // integrator size
    this.dlen (4);              // differentiator size
  }

  // Differentiation noise threshhold.
  public void setThresh (int n) {
    thresh= n;
  }
 
  // Resize the differentiation history array. 
  public void dlen (int n) {
    if (n < 2) n= 2; 
    if (n > 100) n= 100;
    expand (d, n + 3);
    d[d.length-1]= 0;          // reset index, sum
    d[d.length-2]= 0;
  }
  
  // Resize diffInt's integrator.
  public void ilen (int n) {
    a.len (n);
  }
  
  // Set post-differentiation gain for diffInt()
  public void setGain (int n) {
    gain= n;
  }


  // Perform sequential differentiation and integration.
  public int diffInt (int v) {
    return (a.average (diff(v) * gain));
  }

  // Perform a differentiation.
  public int diff (int v) {

    int n= v - d[d.length-3];                // new diff is current - previous

    d[d.length-2] -= d[d[d.length-1]];       // subtract oldest (diff) from sum
    d[d.length-2] += n;                      // add newest diff to sum
    d[d[d.length-1]]= n;                     // replace oldest with newest (shift register)
    d[d.length-3]= v;                        // history for differentiator
    n= d[d.length-2];                        // n= accummulated sum of differences
    return (n > thresh ? n : 0);
  }
}

//
// Calculate an average of a series of values, given an array to store
// values in and the most recent value. The array size determines the
// size of the average.
// 
// The current value replaces the oldest value,
// and the calculated average is returned. Note that the average will not
// be valid until this function has been called at least array.length 
// times.
// 
// a[0] value
// a[1] value
// ...
// a[length-2] running sum ("asum")
// a[length-1] index of oldest item ("ai")


class seAverage {

  int a[] = new int[10];

  // constructor
  public void seAverage () {
    expand (a, 12);                     // length-1:index length-2: running sum
    a[a.length-1]= 0;                   // reset index, sum
    a[a.length-2]= 0;
  }

  public void len (int n) {
    if (n < 1) n= 1;
    expand (a, n + 2);                  // overhead: length-1:index  length-2: running sum
    a[a.length-1]= 0;                   // reset index, sum
    a[a.length-2]= 0;
  }


  public int average (int v) {

    if (a.length == 3) return (v);      // pass-through when size is 1

    a[a.length-2] -= a[a[a.length-1]];  // subtract oldest from running sum
    a[a.length-2] += v;                 // add newest to running sum
    a[a[a.length-1]]= v;                // (remember Nth array value)

    if (++a[a.length-1] >= a.length-2) a[a.length-1]= 0; // wrap array index
    return (a[a.length-2] / (a.length - 2));    // avg= sum / #values
  }
}




// Some Common functions

class seEventGunk {
    int zcd;                     // zero-cross detector
    int zcT;                     // event width timer


  public void seEventGunk () {}

  // Perform zero-cross detection. Requires the initial excursion to be positive.
  public boolean zeroCross (int v) {

    if (zcd > 0) {                            // above zero (goiing up or down)
      if (v <= 0) {                           // going up or down, still > 0
        zcd= v;                               // til it crosses zero
        return (true);
      }
    } 
    else if (zcd < 0) {                       // negative going
      if (v >= 0) {
        zcd= v;
        return (true);
      }
    }
    zcd= v;
    return (false);
  }

  // When an event occurs return the number of milliseconds from when it first
  // goes positive to the first zero crossing (half the event). The negative-going
  // portion of the event becomes essentially dead time.
  public int eventWidth (int v) {

    if (zcd > 0) {                            // above zero (goiing up or down)
      if (v <= 0) {                           // going up or down, still > 0
        zcd= v;                               // til it crosses zero
        return (millis() - zcT);
      } 
      else return (0);                      // still in positive quadrant
    } 
    else if (zcd < 0) {                     // negative going
      if (v >= 0) {
        zcd= v;
        return (0);
      }
    }

    zcd= v;
    zcT= millis();                            // reset timer
    return (0);
  }
}

