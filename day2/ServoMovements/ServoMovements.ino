// include servo library
#include <Servo.h> 
#include <Easing.h>
// declare servo
Servo myservo;

// Let's set here some minumum maximum angles that might be handy in the future not to destroy things
int minAngle=55;
int maxAngle=125;

// declare a variable that we will use to call the different movement patterns
int actions=24
void setup() {
  // attach it to one of the PWM ports
  myservo.attach(9);
  // reset its position to 0
  //myservo.write(minAngle); 

}

void loop() {
  // put your main code here, to run repeatedly:
   switch(actions){
      case 1:
        setBehaviour1();
        break;
      case 2:
        setBehaviour2();
        break;
      case 3:
        setBehaviour3();
        break;
      case 4:
        setBehaviour4();
        break;
      case 5:
        setBehaviour5();
        break;
      case 6:
        setBehaviour6();
        break;
      case 7:
        setBehaviour7();
        break;
      case 8:
        setBehaviour8();
        break;
      case 9:
        setBehaviour9();
        break;
    }

}





