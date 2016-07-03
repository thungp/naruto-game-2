import processing.opengl.*;
import java.util.Hashtable;

import hermes.*;
import hermes.hshape.*;
import hermes.animation.*;
import hermes.physics.*;
import hermes.postoffice.*;

/*
Assignment: 6 SERVER
Author: Peter Thung and Daniel Vance
Based off  of the Hercules Library Explorer Example

Important:  Note the Hermes library is still only compatable with Procecessing 2.x
According to forum, not sure if/when they will port library to be compatible with 3.x.

Change Log:
1. (PT) Started to port over the world from https://github.com/thungp/naruto-game
2. (PT) Ported over Naruto and Deidara Sprites
3. (PT) Created a second player instance to map to Deidara. Ability to control second
player with keypad, 1st player with a,d,s,w
4. (PT) add a Player collider so they can kind of bounce off each other, needs tweaking.
5. (PT) added  ArrayList<PImage> getFrameStripByRectangle(int topLeftX, int topLeftY, int bottomRightX, int bottomRightY, int numFrames) {
  to SpriteFrame to facilitate utilizing hermes AnimatedSprite class.
Change Log (V2.1)
1. (DV) Introduction of code to use Osc Messages to control the players.





*/




///////////////////////////////////////////////////
// DEFINE
///////////////////////////////////////////////////

static final int WINDOW_WIDTH  = 1000;
static final int WINDOW_HEIGHT = 1000;

// DV v2.1
//Constants for OSC input and output ports - change these here if you want different ports.
final int PORT_FOR_INCOMING_OSC_MESSAGES = 12345;
final int PORT_FOR_OUTGOING_OSC_MESSAGES = 54321;
static final String SYSTEM_NAME = "NARUTO"; 

static final float GRAVITY = -200; // acceleration due to gravity

///////////////////////////////////////////////////
// GLOBAL VARS
///////////////////////////////////////////////////

World world;
PlatformCamera cam;
PostOffice po;
PlatformGroup platforms;
Player player;
Player player2;
Rasengan player1Rasengan;

///////////////////////////////////////////////////
// PAPPLET
///////////////////////////////////////////////////

void setup() {
  size(WINDOW_WIDTH, WINDOW_HEIGHT, JAVA2D);  // set window size
  Hermes.setPApplet(this);            // give the library the PApplet
  
  // set up the world, camera, and post office
  cam = new PlatformCamera();
  po = new PostOffice(PORT_FOR_INCOMING_OSC_MESSAGES, PORT_FOR_OUTGOING_OSC_MESSAGES);  // DV v2.1
  world = new PlatformWorld(po, cam);
  
  rectMode(CENTER);
  
  frameRate(60);
  
  //Sets up and starts world
  world.start();
}

void draw() {
  background(230);
  
  world.draw();
}
