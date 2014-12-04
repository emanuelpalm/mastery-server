(function () {
  "use strict";

  /**
   * Represents a room in which players wait to join a game.
   */
  function Lobby(options) {
    options = options || {};
    this.timeout = options.timeout || 10.0;
    this.minPlayers = options.minPlayers || 1;
    this.maxPlayers = options.maxPlayers || 8;

    this.newGameCallback = function () {};
    this.players = [];
    this.timeoutID = null;

    this._resetTimer();
  }

  Lobby.prototype._resetTimer = function () {
    clearTimeout(this.timeoutID);

    var that = this;
    this.timeoutID = setTimeout(function () {
      if (that.players.length >= that.minPlayers) {
        that.newGameCallback(that.players.splice(0, that.maxPlayers));
        that._resetTimer();
      }
    }, (this.timeout * 1000) | 0);
  };

  /**
   * Makes given player enter the lobby.
   */
  Lobby.prototype.enter = function (player) {
    player.tellState("lobby");
    this.players.push(player);
    this._refresh();
  };

  Lobby.prototype._refresh = function () {
    if (this.players.length >= this.maxPlayers) {
      this._resetTimer();
      this.newGameCallback(this.players.splice(0, this.maxPlayers));
    }
  };

  /**
   * Callback fired whenever there are players available for playing a new game.
   *
   * The callback is given an array of players as argument.
   */
  Lobby.prototype.onNewGame = function (callback) {
    this.newGameCallback = callback;
  };

  module.exports = Lobby;
}());
