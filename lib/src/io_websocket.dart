library websockets.io_websocket;


import "dart:async";

import "io.dart" as io;
import "websocket_base.dart";


class IoWebSocket extends WebSocketBase {
  var _inner;

  IoWebSocket(innerWebSocket) {
    io.assertSupported("dart:io.WebSocket");
    assert(io.isWebSocketInstance(innerWebSocket));
    _inner = innerWebSocket;
  }

  static Future<IoWebSocket> connect(url,
                                     {Iterable<String> protocols,
                                     Map<String, dynamic> headers}) async {
    var ws = await io.connectNewWebSocket(url.toString(), protocols: protocols, headers: headers);
    return new IoWebSocket(ws);
  }

  // WebSocket

  Duration get pingInterval => _inner.pingInterval;
  set pingInterval(Duration pingInterval) => _inner.pingInterval = pingInterval;

  int get readyState => _inner.readyState;

  String get extensions => _inner.extensions;

  String get protocol => _inner.protocol;

  int get closeCode => _inner.closeCode;

  String get closeReason => _inner.closeReason;

  Future close([int code, String reason]) => _inner.close(code, reason);

  void add(data) => _inner.add(data);

  Future addStream(Stream stream) => _inner.addStream(stream);

  // Stream

  StreamSubscription listen(void onData(event),
                            { Function onError,
                            void onDone(),
                            bool cancelOnError}) =>
      _inner.listen(onData, onError: onError,
                            onDone: onDone,
                            cancelOnError: cancelOnError);

  // StreamSink

  void addError(errorEvent, [StackTrace stackTrace]) =>
      _inner.addError(errorEvent, stackTrace);

  Future get done => _inner.done;

}