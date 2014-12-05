(function () {
  "use strict";

  /**
   * Creates new player object from given socket.
   */
  function Player(socket) {
    this.socket = socket;
    this.callbacks = {};

    /**
     * ID of player.
     */
    this.id = "socket:" + socket.id;

    /**
     * URL to player avatar.
     */
    this.avatarUrl = "";

    var that = this;

    socket.on("identification", function (identification) {
      that.id = identification.id || that.id;
      that.avatarUrl = identification.avatarUrl || that.avatarUrl;
      if (that.callbacks.identification) {
        that.callbacks.identification(that);
      }
    });

    socket.on("error", function (error) {
      console.error(error);
      if (that.callbacks.error) {
        that.callbacks.error(that, error);
      }
    });

    socket.on("disconnect", function () {
      console.log(that.id + " disconnected.");
      if (that.callbacks.disconnect) {
        that.callbacks.disconnect(that);
      }
    });
  }

  /**
   * Add player event listener.
   *
   * The available events are "identification", "error", and "disconnect". The
   * callback given is fired with a reference to the player triggering it, and
   * in the case of "error" also a reference to the error as second argument.
   *
   * Registering the same event twice causes the old one to be overwritten.
   */
  Player.prototype.on = function (event, callback) {
    this.callbacks[event] = callback;
  };

  /**
   * Clears all currently registered callbacks.
   */
  Player.prototype.clearCallbacks = function () {
    this.callbacks = {};
  };

  /**
   * Tells player client about getting a new state.
   */
  Player.prototype.tellState = function (state) {
    this.socket.emit("state", state);
  };

  /**
   * Disconnects player.
   */
  Player.prototype.disconnect = function () {
    this.socket.disconnect();
  };

  module.exports = Player;
}());
