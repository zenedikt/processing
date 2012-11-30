import neurosky.*;
import org.json.*;

import ddf.minim.*;

ThinkGearSocket neuroSocket;

Minim minim;
AudioPlayer play;

int attention=10;
int meditation=10;
PFont font;

int myColorBackground = color(0,0,0);
int knobValue = 100;

float v = 1.0 / 9.0;
float[][] kernel = {{ v, v, v }, 
                    { v, v, v }, 
                    { v, v, v }};

PImage img;

void setup() {
  size(600,600);
  img = loadImage("mandala.png"); // Load the original image
  
  ThinkGearSocket neuroSocket = new ThinkGearSocket(this);
  try {
    neuroSocket.start();
  }
  catch (ConnectException e) {
    //println("Is ThinkGear running??");
  }
  smooth();
  //noFill();
  font = createFont("Verdana",12);
  textFont(font);  
  
  minim = new Minim(this);
  play = minim.loadFile("chant.aif");
  play.loop();
  
       println(play.getControls());
  
}

void knob(int theValue) {
  myColorBackground = color(theValue);
  println("a knob event. setting background to "+theValue);
}

void draw() {
  //background(0,0,0,50);
  fill(0, 0,0, 255);
  noStroke();
  rect(0,0,120,80);
  image(img, 0, 0); // Displays the image from point (0,0) 
  img.loadPixels();
  
  fill(0, 0, 0, 255-((255/100)*attention));
  rect(0,0,600, 600);
}

void poorSignalEvent(int sig) {
  //println("SignalEvent "+sig);
}

public void attentionEvent(int attentionLevel) {
  println("Attention Level: " + attentionLevel);
  attention = attentionLevel;
  
  if(attention < 50){
    play.shiftGain(14, -80, 500);
  }else if(attention > 50){
    if(play.getGain()<0){
      play.shiftGain(-80, 14, 500);
    }
  }
}


void meditationEvent(int meditationLevel) {
  println("Meditation Level: " + meditationLevel);
  meditation = meditationLevel;
}

void blinkEvent(int blinkStrength) {

  println("blinkStrength: " + blinkStrength);
}

public void eegEvent(int delta, int theta, int low_alpha, int high_alpha, int low_beta, int high_beta, int low_gamma, int mid_gamma) {
  /*println("delta Level: " + delta);
  println("theta Level: " + theta);
  println("low_alpha Level: " + low_alpha);
  println("high_alpha Level: " + high_alpha);
  println("low_beta Level: " + low_beta);
  println("high_beta Level: " + high_beta);
  println("low_gamma Level: " + low_gamma);
  println("mid_gamma Level: " + mid_gamma);*/
}

void rawEvent(int[] raw) {
  //println("rawEvent Level: " + raw);
}  

void stop() {
  neuroSocket.stop();
  super.stop();
}


