// Handles player-Rasengan collisions
class PlayerRasenganCollider extends GenericMassedCollider<Player, Rasengan> {
  
  PlayerRasenganCollider(float elasticity) {
    super(elasticity);
  }
  

  void handle(Player player, Rasengan rasengan) {   
    Player enemy = rasengan.getOwner();
    enemy.setRasenganActive(false);

    world.delete(rasengan);
    //super.handle(player, rasengan); // have GenericMassedCollider do the rest
    // At this point, may want to register drop in healh of player.
    player.setHealth(-5);
  }
  
}
