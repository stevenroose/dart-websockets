
@TestOn("vm")

import "package:test/test.dart";

import "package:websockets/websockets.dart";


final String ECHO_SERVER = "wss://echo.websocket.org";

void main() {
  test("connecting and closing", () async {
    WebSocket ws = await WebSocket.connect(ECHO_SERVER);
    expect(ws, new isInstanceOf<WebSocket>());
    ws.listen(expectAsync((_){}, count: 0));
    await ws.close();
    ws.add("hello closed socket");
  });
  test("listen for echo's", () async {
    WebSocket ws = await WebSocket.connect(ECHO_SERVER);
    ws.listen(expectAsync((message) {
      expect(message, equals("hello"));
    }));
    ws.add("hello");
  });
}