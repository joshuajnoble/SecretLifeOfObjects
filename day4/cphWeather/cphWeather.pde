import com.temboo.core.*;
import com.temboo.Library.Yahoo.Weather.*;

// Create a session using your Temboo account application details
TembooSession session = new TembooSession("joshuajnoble", "myFirstApp", "f06e8f5d39b044ecbf6788ba895d19b6");

void setup() {
  // Run the GetTemperature Choreo function
  runGetTemperatureChoreo();
}

void runGetTemperatureChoreo() {
  // Create the Choreo object using your Temboo session
  GetTemperature getTemperatureChoreo = new GetTemperature(session);

  // Set inputs
  getTemperatureChoreo.setAddress("Copenhagen, Denmark");

  // Run the Choreo and store the results
  GetTemperatureResultSet getTemperatureResults = getTemperatureChoreo.run();
  
  // Print results
  print(" Copenhagen Weather ");
  println(getTemperatureResults.getTemperature());
  
    // Set inputs
  getTemperatureChoreo.setAddress("Seattle, USA");

  // Run the Choreo and store the results
  GetTemperatureResultSet getTemperatureResultsSEA = getTemperatureChoreo.run();
  
  // Print results
  print(" Seattle Weather ");
  println(getTemperatureResultsSEA.getTemperature());

}
