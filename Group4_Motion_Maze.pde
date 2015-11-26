import processing.serial.*;
Serial s;
Game game = new Game();
Ball ball = new Ball();

String p;
String r;
String u;

float pitch = 0;
float roll  = 0;
float cm    = 0;

float initDist = 0;
float endDist  = 0;
boolean initDistSet = false;
boolean endDistSet  = false;
int handMovement = 0;

int rTimer = 0;
boolean rTimerOn = false;

int getHandMovement() {
  if (cm != 0 && initDistSet == false && rTimer <= 20) {
    initDist = cm;
    initDistSet = true;
    rTimerOn = true;
  } //set initial distance

  if (cm != 0 && rTimer >= 30 && endDistSet == false) {
    endDist = cm; //set end distance
    endDistSet = true;
  } //in a one second, check where hand is

  if (cm != 0 && endDist <= initDist - 7 && rTimer >= 20) {
    initDistSet = false;
    endDistSet = false;
    return -1;
  }
  if (cm != 0 && endDist >= initDist + 7 && rTimer >= 20) {
    initDistSet = false;
    endDistSet = false;
    return 1;
  }
  if (endDist <= initDist + 7 || endDist >= initDist - 7 && rTimer >= 30) {
    initDistSet = false;
    endDistSet = false;
    return 0;
  }
  return 0;
} //end get hand movement

void controlrTimer() {
  if (rTimerOn == true) {
    rTimer++;
  }
  if (rTimer >= 90) {
    rTimerOn = false;
    rTimer = 0;
  }
} //end control timer

void setup() {
  String ports = Serial.list()[0];
  s = new Serial(this, ports, 9600);
  size(880, 680);
  background(0);
}

void draw() {
  controlrTimer();
  background(0);

  if (s.available() > 0) {
    p = s.readStringUntil('\n');
    r = s.readStringUntil('\n');
    u = s.readStringUntil('\n');

    pitch = Float.parseFloat(p)*(PI/180);
    roll  = Float.parseFloat(r)*(PI/180);
    cm    = Float.parseFloat(u);
  } //end if Serial is available

  handMovement = getHandMovement();
  //game.drawGame();

  if (handMovement == 1) {
    println("Hand Moved Up");
  } else if (handMovement == -1) {
    println("Hand Moved Down");
  }
  println(cm);
  //println("Pitch: " + pitch*(180/PI) + "\n" + "Roll: " + roll*(180/PI) + "\n" + "Dist: " + cm + "cm");
} //end draw