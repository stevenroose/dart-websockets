
library websockets.test.tests;

import "dart:async";
import "package:test/test.dart";

import "package:websockets/websockets.dart";

final String ECHO_SERVER = "wss://echo.websocket.org";

void main() {
  WebSocket ws;
  setUp(() async {
    ws = await WebSocket.connect(ECHO_SERVER);
  });
  tearDown(() async {
    try {
      await ws.close();
    } on StateError catch(_) {
      // already closed in test
    }
  });
  test("connecting and closing", () async {
    expect(ws, new isInstanceOf<WebSocket>());
    ws.listen(expectAsync((_) {}, count: 0));
    await ws.close();
    new Timer(const Duration(seconds: 6), expectAsync(() {
      expect(() => ws.add("hello really closed socket"), returnsNormally);
    }));
    expect(() => ws.add("hello closed socket"), returnsNormally);
  });
  test("listen for echo's", () async {
    ws.listen(expectAsync((message) {
      expect(message, equals("hello"));
    }));
    ws.add("hello");
  });
}
