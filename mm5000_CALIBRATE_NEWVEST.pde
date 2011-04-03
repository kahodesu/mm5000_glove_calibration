#include <WString.h>
#include <Firmata.h>


/////////////////////////////////////////////////////////////////////
//                  Mary Mack 5000 CALLIBRATION                    //
//                          Kaho Abe                               //           
//                        Dec 10, 2010                             //
/////////////////////////////////////////////////////////////////////
//                                          
//
//
//
/////////////////////////////////////////////////////////////////////

/// the address pins will go in order from the first one:
const int first4067Pin = 2;
const int firstSwitchPin = 10;
const int firstAnalogPin = 1;

String inString;

///////////////////////////////////////////SETTING UP///////////////////////////////////////////
void setup() {
 Serial.begin(57600);
 
 Firmata.setFirmwareVersion(2, 1);
 Firmata.begin(57600);
  // Say hello:
 // Serial.print("String Library version: ");
 // Serial.println(inString.version());
  
  for (int pinNumber = first4067Pin; pinNumber < first4067Pin + 4; pinNumber++) {
    pinMode(pinNumber, OUTPUT);
    digitalWrite(pinNumber, LOW);
  }

  for (int pinNumber = firstSwitchPin; pinNumber < firstSwitchPin + 4; pinNumber++) {
    pinMode(pinNumber, OUTPUT);
    digitalWrite(pinNumber, HIGH);
  }
}

///////////////////////////////////////////MAIN PART///////////////////////////////////////////
void loop() {
  inString="";
  for (int pinNumber = firstSwitchPin; pinNumber < firstSwitchPin + 4; pinNumber++) {
    
    digitalWrite(pinNumber, LOW);
  //int addToString = filter(analogRead(pinNumber-9));
   int addToString = analogRead(pinNumber-9); //USE FOR CALIBRATE
   inString.append(addToString);
   inString.append(", "); //USE FOR CALIBRATE
   resetPins();
  }
 
  // loop over all the input channels
  for (int thisChannel = 4; thisChannel < 16; thisChannel++) {
    setChannel(thisChannel);
    // read the analog input and store it in the value array: 
    //int analogReading = filter(analogRead(0));  
   int analogReading = analogRead(0); //USE FOR CALIBRATE
    // print the result:
    inString.append(analogReading);
    inString.append(", "); //USE FOR CALIBRATE
   } 
   
//   Serial.println(inString);
/* if(inString.equals("3010000000000000") || 
     inString.equals("0402000000000000") ||  
     inString.equals("2143000000000000") ||   
     inString.equals("4321000000000000") ||  
     inString.equals("0000000021430000") ||  
     inString.equals("0000000000001234") ||  
     inString.equals("0000660000000000") ||  
     inString.equals("4321000100000000") || 
     inString.equals("4321001000000000")  ||
     inString.equals("0000001100000000")  ||
     inString.equals("0000000100000000") ||  
     inString.equals("0000001000000000") || 
     inString.equals("4321001100000000") ) {
   
    Serial.println(inString); }
    //USE FOR CALIBRATION
/*  //  Firmata.sendString(inString);
  // }
   */ 
 Serial.println(inString); //USE FOR CALIBRATION
 // delay(50); //USE FOR CALIBRATION*/
}


///////////////////////////////////////////FUNCTIONS///////////////////////////////////////////

// this method sets the address pins to pick which input channel
// is connected to the multiplexer's output:
void setChannel(int whichChannel) {
  // loop over all four bits in the channel number:
  for (int bitPosition = 0; bitPosition < 4; bitPosition++) {
    // read a bit in the channel number:
    int bitValue = bitRead(whichChannel, bitPosition);  
    // pick the appropriate address pin:
    int pinNumber = bitPosition + first4067Pin;
    // set the address pin
    // with the bit value you read:
    digitalWrite(pinNumber, bitValue);
  }
}

void resetPins(){
  for (int pinNumber = firstSwitchPin; pinNumber < firstSwitchPin + 4; pinNumber++) {
    digitalWrite(pinNumber, HIGH);  
  }
}

int filter(int number) {
  if (number >= 150 && number < 250) {// CL 5
       return   5;
  }
  if (number >= 300   && number < 400  ) {// AL 2 
       return   2;
  }
  if (number >= 450   && number < 550  ) {// BL 4
       return   4;
  }
  if (number >= 600   && number < 700  ) {// CR 6
       return   6;
  }
  if (number >= 750   && number < 850  ) {// BR 3 
       return   3;
  }
  if (number >= 900) {//  AR 1 
       return   1;
  }
  else {
       return   0;
  }
}


