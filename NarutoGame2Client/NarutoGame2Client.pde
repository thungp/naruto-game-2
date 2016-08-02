import processing.opengl.*;
import java.util.Hashtable;
import ddf.minim.*;
import hermes.*;
import hermes.hshape.*;
import hermes.animation.*;
import hermes.physics.*;
import hermes.postoffice.*;
import org.multiply.processing.TimedEventGenerator;


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
6. Discovered that Processing has issues with useof static variables in non static classes. (unfortunate).
   ref: https://processing.org/discourse/beta/num_1263237645.html
7. (DV) Background Music found at: https://www.freesound.org/people/FoolBoyMedia/sounds/320232/
8. (DV) Music Player library documentation found at http://code.compartmental.net/minim/
9. (PT) Added Player boundary check for falling through floor or exiting left or right wall.

10. (PT) Added string for remote IP
11. (PT) Required, need to install the TimedEventGenerator library
12. (PT) Calling open weather map API http://openweathermap.org/current  (Can't make calls faster than 60 calls per minute with free plan
13. (PT) Added with speed and direction force based on city location which cycles through list at configurable periodicty. 
Notes: 
1) City IDs can be foundfrom this link: List of city ID city.list.json.gz can be downloaded here http://bulk.openweathermap.org/sample/
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
//static final String REMOTE_SYSTEM_IP = "192.168.199.126";
//static final String REMOTE_SYSTEM_IP = "100.65.67.47";
static final String REMOTE_SYSTEM_IP = "207.204.250.207";
static final String SYSTEM_NAME = "NARUTO"; 
static final int CITY_CHG_PERIODICITY_IN_SECONDS = 10;
static final int WEATHER_UPDATE_IN_SECONDS = 20;
/*
{"_id":5516233,"name":"Amarillo","country":"US","coord":{"lon":-101.831299,"lat":35.222}}
{"_id":4058076,"name":"Dallas County","country":"US","coord":{"lon":-87.083321,"lat":32.333469}}
{"_id":1848313,"name":"Yokosuka","country":"JP","coord":{"lon":139.667221,"lat":35.283611}}
{"_id":4720131,"name":"Portland","country":"US","coord":{"lon":-97.323883,"lat":27.877251}}
{"_id":5601538,"name":"Moscow","country":"US","coord":{"lon":-117.000168,"lat":46.732391}}

*/

static final String CITY_LIST = "5516233,4058076,1848313,4720131,5601538";
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
CityList cityList;
TimedEventGenerator weatherRefreshEventGenerator;
TimedEventGenerator cityChangeEventGenerator;


SpriteFrame sprite01;  // having issues with Processing and static variables and classes: https://processing.org/discourse/beta/num_1263237645.html
Animation player1RasenganLaunchAnimation;  
Animation player2RasenganLaunchAnimation; 



PImage background;

// Music Globals
AudioPlayer bgMusic;
Minim minim; // Audio context

///////////////////////////////////////////////////
// PAPPLET
///////////////////////////////////////////////////

void setup() {
  size(WINDOW_WIDTH, WINDOW_HEIGHT, JAVA2D);  // set window size
  Hermes.setPApplet(this);            // give the library the PApplet
  
  background = loadImage("sand_background.png");
  
  // Load the background music and player
  minim = new Minim(this);
  bgMusic = minim.loadFile("video-game-land.wav"); 
  bgMusic.loop();
  
  // initialize weather
  cityList = new CityList();
  City ca = cityList.getNextCity();
  ca = cityList.getNextCity();
  //ca = cityList.getNextCity();
  println("cityList speed " + ca.getWindSpeed());
  
  // set up the world, camera, and post office
  cam = new PlatformCamera();
  //po = new PostOffice(PORT_FOR_INCOMING_OSC_MESSAGES, PORT_FOR_OUTGOING_OSC_MESSAGES);  // DV v2.1  REMOTE_SYSTEM_IP
  po = new PostOffice(PORT_FOR_INCOMING_OSC_MESSAGES, PORT_FOR_OUTGOING_OSC_MESSAGES, REMOTE_SYSTEM_IP);  // PT v2.
  world = new PlatformWorld(po, cam);
  rectMode(CENTER);
  
  frameRate(60);
  sprite01 = RasenganHelper.initSpriteFrame("Naruto_04.png");
  player1RasenganLaunchAnimation  = RasenganHelper.getRasenganLaunchAnimation(sprite01);
  player2RasenganLaunchAnimation = RasenganHelper.getPlayer2RasenganLaunchAnimation(sprite01);
  
  weatherRefreshEventGenerator = new TimedEventGenerator(
      this, "onWeatherRefreshTimerEvent", true);
  weatherRefreshEventGenerator.setIntervalMs(1000 * WEATHER_UPDATE_IN_SECONDS);
  
  cityChangeEventGenerator = new TimedEventGenerator(
      this, "onCityChangeTimerEvent", true);

  cityChangeEventGenerator.setIntervalMs(1000 * CITY_CHG_PERIODICITY_IN_SECONDS);
  
  //Sets up and starts world
  world.start();
}

void draw() {
  image(background, 0, 0);
  background.resize(width, height);
  textSize(28);
  fill(255, 102, 153);
  if(cityList != null) {
    String cityName = cityList.getCurrentCity().getName();
    int windDirection = cityList.getCurrentCity().getWindDirection();
    float windSpeed = cityList.getCurrentCity().getWindSpeed();
    
    text("City: " + cityName + " Wind Direction/Speed: " + windDirection + "/" + windSpeed, .1 * width, height * .95);
  }
  
  world.draw();
}

void onWeatherRefreshTimerEvent() {
  System.out.println("Got a onWeatherRefreshTimerEvent!");
  // list of city IDs
  //JSONObject json = loadJSONObject("http://api.openweathermap.org/data/2.5/group?id=4058076,1848313,4720131&units=metric&mode=json&appid=cbc1fc23414e03a198fb37afa9c5bbd8");
  JSONObject json = loadJSONObject("http://api.openweathermap.org/data/2.5/group?id=" + CITY_LIST + "&units=metric&mode=json&appid=cbc1fc23414e03a198fb37afa9c5bbd8");
  saveJSONObject(json, "cachedWeather.json");
  if(cityList != null) {
    cityList.initializeCityList();
  }
}


void onCityChangeTimerEvent() {
  System.out.println("Got a onCityChangeTimerEvent!");
  if(cityList != null) {
    cityList. getNextCity();
  }
}
