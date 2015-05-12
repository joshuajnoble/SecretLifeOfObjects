void servoStop(int stopFor){
  //brings the servo to the middle position
  myservo.write(0);
  delay(stopFor);
    
}

void servoOnlyRight(){
  //brings the servo to minium pos
  myservo.write(minAngle);
}

void servoOnlyLeft(){
  //brings the servo to max pos
  myservo.write(maxAngle);
}

void servoChill(){
  //Wait up in one place
  int servoStopSide=800;
  int servoUp=30;
  
   myservo.write(servoUp);
   delay(servoStopSide);
   myservo.write(0);
}

void servoAnxious(){
  int servoStopSide=100;
  int pos= int(random(0,20));
   myservo.write(pos);
   delay(servoStopSide);
}

void servoDemocratic(){
  //makes a sweep in a very democratic way the lower the steps the faster it goes
  int servoSteps=5;
  
  for(int pos = minAngle; pos <= maxAngle; pos += 1) // goes from min to max 
  {                                  // in steps of 1 degree 
    myservo.write(pos);              // tell servo to go to position in variable 'pos' 
    delay(servoSteps);                       // waits Xms for the servo to reach the position 
  } 
  for(int pos = maxAngle; pos>=minAngle; pos-=1)     // goes from max to min 
  {                                
    myservo.write(pos);             
    delay(servoSteps);                     
  }
  
}

void servoFocusLeft(){
    //makes a sweep and stop more on one side
    int servoSpeedFocus=10;
    int servoSpeedNoFocus=1;
    int servoStopSide=500;
    
  for(int pos = minAngle; pos <= maxAngle; pos += 1) 
  {                                 
    myservo.write(pos);             
    delay(servoSpeedFocus);         
    if (pos==maxAngle-1){
      delay(servoStopSide); // the longer delay here will make it stop longer
    }    
  } 
  for(int pos = maxAngle; pos>=minAngle; pos-=1)    
  {                                
    myservo.write(pos);              
    delay(servoSpeedNoFocus);                        
  } 
}

void servoFocusRight(){
    //makes a sweep and stop more on one side
    int servoSpeedFocus=20;
    int servoSpeedNoFocus=1;
    int servoStopSide=500;
    
  for(int pos = minAngle; pos <= maxAngle; pos += 1) 
  {                                 
    myservo.write(pos);             
    delay(servoSpeedNoFocus);             
  } 
  for(int pos = maxAngle; pos>=minAngle; pos-=1)    
  {                                
    myservo.write(pos);              
    delay(servoSpeedFocus); 
    if (pos==minAngle+1){
      delay(servoStopSide); // the longer delay here will make it stop longer
    }    
  } 
  
}

void bouncyServo(){
  int dur = 100; //duration is 100 loops
  for (int pos=0; pos<dur; pos++){
    //move servo from 0 and 140 degrees forward
    myServo.write(Easing::easeInOutCubic(pos, 0, 140, dur));
    delay(15); //wait for the servo to move
  }
  
  delay(1000); //wait a second, then move back using "bounce" easing
  
  for (int pos=0; pos<dur; pos++){
    //move servo -140 degrees from position 140 (back to 0)
    myServo.write(Easing::easeOutBounce(pos, 140, -140, dur));
    delay(15);
  }
}






