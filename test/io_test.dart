library websockets.test.io;


import "package:websockets/websockets.dart";

main() async {
  WebSocket ws = await WebSocket.connect("wss://echo.websocket.org");
  ws.listen(print);
  ws.add("test");
}