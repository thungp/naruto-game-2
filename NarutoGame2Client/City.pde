import java.util.*;



public class City {
  float windSpeed;
  int windDirection;
  String cityName;
  int dt; // time
  
  public String getName(){
    return cityName;
  }
  
  public float getWindSpeed() {
    // if wind direction between 0-180 make wind speed positive for game else make it negative.
    if( windDirection > 0 && windDirection <= 180) {
      return windSpeed;
    } else {
      return windSpeed * (-1);
    }
  }
  
  public int getWindDirection(){
    return windDirection;
  }
  
  public int getTime(){
    return dt;
  }
    
    
  /**
  * Copy constructor
  */
  public City(City aCity){
     this(aCity.getName(), aCity.getWindSpeed(), aCity.getWindDirection(), aCity.getTime());
     //no defensive copies are created here, since 
    //there are no mutable object fields (String is immutable)
  }
  
  /**
  * regular constructor
  */
  public City(String name, float speed, int direction, int time){
    this.cityName = name;
    this.windSpeed = speed;
    this.windDirection = direction;
    this.dt = time;
  }
  
}


public class CityList {
  
   int currentCityIndex = -1;
   JSONObject json;
   List<City> cList = null;

   public CityList(){
      initializeCityList(); 
   }
   public City getNextCity() {
     if (cList != null) {
       currentCityIndex = (++currentCityIndex) % cList.size();
       return cList.get(currentCityIndex);     
     }  else {
       return null; 
     }     
   }
   
   public City getCurrentCity(){
     if(cList != null){
       return cList.get(currentCityIndex);
     } else {
      return null;
     
     } 
   }
   public void initializeCityList() {
     // eventually check to see if there is any change. 
     json = loadJSONObject("../cachedWeather.json");
     int count = json.getInt("cnt");
     println("count = " + count);
     JSONArray  cityList = json.getJSONArray("list");
     cList = new ArrayList<City>();
     for(int i = 0; i < count; i++) {
       JSONObject city =  cityList.getJSONObject(i);
       JSONObject windJSONObj = city.getJSONObject("wind");
       float windSpeed = windJSONObj.getFloat("speed");
       int windDegrees = windJSONObj.getInt("deg");
       String cityName = city.getString("name");
       int dt = city.getInt("dt");
       City cityObj = new City(cityName, windSpeed, windDegrees, dt);
       cList.add(cityObj);
       //println(cityName + ", " + windSpeed + ", " + windDegrees + ", " + dt);
     }
     
   } 
   
   public int getCityListCount(){
      if(cList != null){
        return cList.size();
      } else {
        return 0;
      }
   }
  
}
