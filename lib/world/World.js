(function () {
  "use strict";

  function World() {

  }

  World.prototype.enter = function (party) {
    party.tellState("world");
    var intervalID = setInterval(function () {
      party.synchronize();
    }, 100);

    party.onAllDisconnected(function () {
      clearInterval(intervalID);
    });
  };

  module.exports = World;
}());
