(function () {
  "use strict";

  var IO = require("socket.io");
  var Player = require("../player/Player.js");

  /**
   * Collects connecting players connecting on given port.
   *
   * In essence, listens for connections, and wraps them in Player objects.
   */
  function Entrance(port) {
    this.enterCallback = function () {};
    this.io = new IO(port);
  }

  /**
   * Callback fired whenever a new player enters the server.
   *
   * For a player to be let in, it has to provide identification.
   */
  Entrance.prototype.onEnter = function (callback) {
    this.io.sockets.on("connection", function (socket) {
      var player = new Player(socket);
      player.tellState("entrance");
      player.on("identification", function () {
        player.clearCallbacks();
        callback(player);
      });
    });
  };

  module.exports = Entrance;
}());
