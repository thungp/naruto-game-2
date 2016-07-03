// Handles player-platform collisions
class PlayerRasenganCollider extends GenericMassedCollider<Player, Rasengan> {
  
  PlayerRasenganCollider(float elasticity) {
    super(elasticity);
  }
  
  // reset the player's jump when he hits a platform, then do the normal projection/impulse collision stuff
  void handle(Player player, Rasengan rasengan) {   
    world.delete(rasengan);
    //super.handle(player, rasengan); // have GenericMassedCollider do the rest
    // At this point, may want to register drop in healh of player.
    
  }
  
}
