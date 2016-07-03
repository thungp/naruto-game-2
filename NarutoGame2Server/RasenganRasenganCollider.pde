// Handles Rasengan -Rasengan collisions
class RasenganRasenganCollider extends GenericMassedCollider<Rasengan, Rasengan> {
  
  RasenganRasenganCollider(float elasticity) {
    super(elasticity);
  }
  
  // reset the player's jump when he hits a platform, then do the normal projection/impulse collision stuff
  void handle(Rasengan r1, Rasengan r2) {
    Player player1 = r1.getOwner();
    Player player2 = r2.getOwner();
    player1.setRasenganActive(false);
    player2.setRasenganActive(false);
    world.delete(r1);
    world.delete(r2);
    //super.handle(player, rasengan); // have GenericMassedCollider do the rest
    // At this point, may want to register drop in healh of player.
    
  }
  
}
