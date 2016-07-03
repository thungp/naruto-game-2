// Handles player-player collisions
class PlayerCollider extends GenericMassedCollider<Player, Player> {
  
  PlayerCollider(float elasticity) {
    super(elasticity);
  }
  
  // reset the player's jump when he hits another player, then do the normal projection/impulse collision stuff
  void handle(Player player1, Player player2) {
    //player1.resetJump(); // reset the jump
    super.handle(player, player2); // have GenericMassedCollider do the rest
  }
  
}
