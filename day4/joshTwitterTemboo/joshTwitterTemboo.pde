import com.temboo.core.*;
import com.temboo.Library.Twitter.Users.*;

import java.net.URLDecoder;

JSONObject json;

PImage simo, josh;

String joshName, joshLocation, simoName, simoLocation;

boolean ready = false;

// Create a session using your Temboo account application details
TembooSession session = new TembooSession("joshuajnoble", "myFirstApp", "f06e8f5d39b044ecbf6788ba895d19b6");

void setup() {
  // Run the Show Choreo function
  runShowChoreo();
  
  size(512, 512);
}

void runShowChoreo() {
  // Create the Choreo object using your Temboo session
  Show showChoreo = new Show(session);

  // Set inputs
  showChoreo.setScreenName("fctry2");
  showChoreo.setAccessToken("87591220-0kUpM1HvSvWPZ3B4pRIHpJMPguwKbL0i5YnOyuqW2");
  showChoreo.setAccessTokenSecret("BwwOY7CdqTkqEeSNmvH3JEepBeN8wACPt1dhLEnXHK28o");
  showChoreo.setConsumerSecret("oVPHFv75fcCO6XVPI3EjRDZdUQOutAsNqwUTVylMRU4TGYJphm");
  showChoreo.setConsumerKey("hwLKCuRMQJTcCXoPNfJVSB2Aa");

  // Run the Choreo and store the results
  ShowResultSet showResults = showChoreo.run();
  
  json = JSONObject.parse(showResults.getResponse());
  
  println(showResults.getResponse());
  
  joshName = json.getString("name");
  joshLocation = json.getString("location");
  
  String url = json.getString("profile_image_url");
  String escapedURL = URLDecoder.decode(url);
  
  println(escapedURL);
  
  josh = loadImage(escapedURL);
  
  showChoreo.setScreenName("fishandchipsing");
  showChoreo.setAccessToken("87591220-0kUpM1HvSvWPZ3B4pRIHpJMPguwKbL0i5YnOyuqW2");
  showChoreo.setAccessTokenSecret("BwwOY7CdqTkqEeSNmvH3JEepBeN8wACPt1dhLEnXHK28o");
  showChoreo.setConsumerSecret("oVPHFv75fcCO6XVPI3EjRDZdUQOutAsNqwUTVylMRU4TGYJphm");
  showChoreo.setConsumerKey("hwLKCuRMQJTcCXoPNfJVSB2Aa");

  // Run the Choreo and store the results
  showResults = showChoreo.run();
  
  json = JSONObject.parse(showResults.getResponse());
  
  simoName = json.getString("name");
  simoLocation = json.getString("location");
  
  url = json.getString("profile_image_url");
  escapedURL = URLDecoder.decode(url);
  
  println(escapedURL);
  
  simo = loadImage(escapedURL);
  
  
  ready = true;
}

void draw()
{
  if(ready)
  {
    image(josh, 0, 0);
    text(joshName, 0, 150);
    text(joshLocation, 0, 250);
    image(simo, 250, 0);
    text(simoName, 250, 150);
    text(simoLocation, 250, 250);
  }
}
