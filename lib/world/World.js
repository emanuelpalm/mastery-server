(function () {
  "use strict";

  function World() {

  }

  World.prototype.enter = function (party) {
    party.tellState("world");
    party.disconnect();
  };

  module.exports = World;
}());
