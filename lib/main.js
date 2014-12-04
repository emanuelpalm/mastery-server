var net = require("net");

var server = net.createServer();

server.on("connection", function (socket) {
  socket.pipe(socket);
});

server.on("error", function (error) {
  console.error(error);
});

server.listen(14001);

