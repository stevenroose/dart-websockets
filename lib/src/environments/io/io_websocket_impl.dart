/*
 * The MIT License (MIT)
 * Copyright (c) 2016 Steven Roose
 */
library websockets.environments.io.io_websocket_impl;

import "dart:async";

import "../../websocket_base.dart";

class IoWebSocketImpl extends WebSocketBase {
  final dynamic _inner;
  final Uri _url;

  IoWebSocketImpl(this._inner, this._url);

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
          {Function onError, void onDone(), bool cancelOnError}) =>
      _inner.listen(onData,
          onError: onError, onDone: onDone, cancelOnError: cancelOnError);

  // StreamSink

  void addError(errorEvent, [StackTrace stackTrace]) =>
      _inner.addError(errorEvent, stackTrace);

  Future get done => _inner.done;

  Uri get url => _url;
}
