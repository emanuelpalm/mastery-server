(function () {
  "use strict";

  function World() {

  }

  World.prototype.enter = function (players) {
    players.forEach(function (player) {
      player.tellState("world");
      player.disconnect();
    });
  };

  module.exports = World;
}());
