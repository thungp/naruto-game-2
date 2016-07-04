import processing.opengl.*;
import java.util.Hashtable;

import hermes.*;
import hermes.hshape.*;
import hermes.animation.*;
import hermes.physics.*;
import hermes.postoffice.*;

/*
Assignment: 6 CLIENT
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

6. Discovered that Processing has issues with useof static variables in non static classes. (unfortunate).
   ref: https://processing.org/discourse/beta/num_1263237645.html
   



*/




///////////////////////////////////////////////////
// DEFINE
///////////////////////////////////////////////////

static final int WINDOW_WIDTH  = 800;
static final int WINDOW_HEIGHT = 600;

// DV v2.1
//Constants for OSC input and output ports - change these here if you want different ports.
final int PORT_FOR_INCOMING_OSC_MESSAGES = 54321;
final int PORT_FOR_OUTGOING_OSC_MESSAGES = 12345;
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
Rasengan player2Rasengan;
PlatformCollider platformCollider = new PlatformCollider(0);
PlayerCollider playerCollider = new PlayerCollider(0);
PlayerRasenganCollider playerRasenganCollider = new PlayerRasenganCollider(0);
RasenganRasenganCollider rasenganRasenganCollider = new RasenganRasenganCollider(0);

SpriteFrame sprite01;  // having issues with Processing and static variables and classes: https://processing.org/discourse/beta/num_1263237645.html
Animation player1RasenganLaunchAnimation;  
Animation player2RasenganLaunchAnimation; 

PImage background;

///////////////////////////////////////////////////
// PAPPLET
///////////////////////////////////////////////////

void setup() {
  size(WINDOW_WIDTH, WINDOW_HEIGHT, JAVA2D);  // set window size
  Hermes.setPApplet(this);            // give the library the PApplet
  
  background = loadImage("sand_background.png");
  
  // set up the world, camera, and post office
  cam = new PlatformCamera();
  po = new PostOffice(PORT_FOR_INCOMING_OSC_MESSAGES, PORT_FOR_OUTGOING_OSC_MESSAGES);  // DV v2.1
  world = new PlatformWorld(po, cam);
  rectMode(CENTER);
  
  frameRate(60);
  sprite01 = RasenganHelper.initSpriteFrame("Naruto_04.png");
  player1RasenganLaunchAnimation  = RasenganHelper.getRasenganLaunchAnimation(sprite01);
  player2RasenganLaunchAnimation = RasenganHelper.getPlayer2RasenganLaunchAnimation(sprite01);
  //Sets up and starts world
  world.start();
}

void draw() {
  image(background, 0, 0);
  background.resize(width, height);
  
  world.draw();
}
