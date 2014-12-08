(function () {
  "use strict";

  /**
   * Represents a world which may host players and other entities.
   */
  function World() {

  }

  /**
   * Makes the given party enter the world.
   *
   * The world will remain until the last player disconnects.
   */
  World.prototype.enter = function (party) {
    party.tellState("world");
    party.identify();
    var intervalID = setInterval(function () {
      party.synchronize();
    }, 100);

    party.onAllDisconnected(function () {
      clearInterval(intervalID);
    });
  };

  module.exports = World;
}());
