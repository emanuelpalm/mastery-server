var Entrance = require("./world/Entrance.js");
var Lobby = require("./world/Lobby.js");
var World = require("./world/World.js");

function main(port) {
  var entrance = new Entrance(port);
  var lobby = new Lobby();
  
  entrance.onEnter(function (player) {
    lobby.enter(player);
  });
  
  lobby.onNewGame(function (players) {
    var world = new World();
    world.enter(players);
  });
}
main(8082);

