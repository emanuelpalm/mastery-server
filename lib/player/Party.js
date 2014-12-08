(function () {
  "use strict";

  /**
   * A party of players residing within the same game.
   */
  function Party(players) {
    this.players = players;
    this.allDisconnectedCallback = function () {};

    var onlinePlayers = players.length;
    var that = this;
    players.forEach(function (player) {
      player.on("disconnect", function () {
        if (--onlinePlayers === 0) {
          that.allDisconnectedCallback();
        }
      });
    });
  }

  /**
   * Distributes identification data among players in party.
   */
  Party.prototype.identify = function () {
    var partyData = new Array(this.players.length);
    this.players.forEach(function (player, index) {
      partyData[index] = {
        id: player.id,
        avatarUrl: player.avatarUrl,
      };
    });
    this.players.forEach(function (player) {
      player.identifyParty(partyData);
    });
  };

  /**
   * Synchronizes state between players in party.
   */
  Party.prototype.synchronize = function () {
    this.players.forEach(function (receiver) {
      var message = new Array(this.players.length);
      this.players.forEach(function (player, index) {
        message[index] = [player.position, player.velocity];
      });
      receiver.sendWorldState(message);
    }, this);
  };

  /**
   * Gives all players in party given state.
   */
  Party.prototype.tellState = function (state) {
    this.players.forEach(function (player) {
      player.tellState(state);
    });
  };

  /**
   * Disconnects all players in party.
   */
  Party.prototype.disconnect = function () {
    this.players.forEach(function (player) {
      player.disconnect();
    });
  };

  /**
   * Callback fired when all players have disconnected.
   */
  Party.prototype.onAllDisconnected = function (callback) {
    this.allDisconnectedCallback = callback;
  };

  module.exports = Party;
}());
