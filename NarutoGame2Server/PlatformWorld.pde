class PlatformWorld extends World {
  PlatformWorld(PostOffice po, HCamera cam) {
    super(po,cam);
  }
  
  void setup() {
    // set up the platforms
    platforms = new PlatformGroup(world);
    Sector first = new Sector(0, 0, platforms, 0.8);
    SectorGrid grid = new SectorGrid(first, platforms);
  
    // set up platform generation
    world.register(grid, cam, new PlatformGenerator());
  
    // set up the player
    player = new Player(0, 0, Player.PLAYER_1);
    player2 = new Player(470, 0, Player.PLAYER_2);
    println("display rasengan for testing - a");
    
    
    world.register(player, true);
    world.register(player2, true);
    
    
    po.subscribe(player, POCodes.Key.W);
    po.subscribe(player, POCodes.Key.A);
    po.subscribe(player, POCodes.Key.S);
    po.subscribe(player, POCodes.Key.D);
    po.subscribe(player, POCodes.Key.G);
    
    po.subscribe(player2, POCodes.Key.UP);
    po.subscribe(player2, POCodes.Key.DOWN);
    po.subscribe(player2, POCodes.Key.LEFT);
    po.subscribe(player2, POCodes.Key.RIGHT);
    po.subscribe(player2, POCodes.Key.L);
    
    
    //subscribe players to the Osc Messages
    po.subscribe(player,  "/NARUTO/setW");
    po.subscribe(player,  "/NARUTO/setA");
    po.subscribe(player,  "/NARUTO/setS");
    po.subscribe(player,  "/NARUTO/setD");
    po.subscribe(player,  "/NARUTO/stop");
    po.subscribe(player,  "/NARUTO/setG");
    po.subscribe(player2, "/NARUTO/setUP");
    po.subscribe(player2, "/NARUTO/setDOWN");
    po.subscribe(player2, "/NARUTO/setLEFT");
    po.subscribe(player2, "/NARUTO/setRIGHT");
    po.subscribe(player2, "/NARUTO/stop");
    po.subscribe(player2, "/NARUTO/setL");
  
    // make player collide with platforms
    //world.register(player, platforms, new PlatformCollider(0));
    world.register(player, platforms, platformCollider);
    
    // make player2 collide with platforms
    //world.register(player2, platforms, new PlatformCollider(0));
    world.register(player2, platforms, platformCollider);
    
    //make player1 colledit with player2
    //world.register(player, player2, new PlayerCollider(0));
    world.register(player, player2, playerCollider);
    
    //make player1 colledit with player2
    //world.register(player2, player, new PlayerCollider(0));
    world.register(player2, player, playerCollider);
    

  }
}
