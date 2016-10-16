/*
 * The MIT License (MIT)
 * Copyright (c) 2016 Steven Roose
 */

library websockets.impl.html;

import "dart:async";
import "dart:html" as html;

import "websocket_base.dart";

class HtmlWebSocketImpl extends WebSocketBase {
  final dynamic _inner;

  HtmlWebSocketImpl(this._inner);

  int _closeCode;
  String _closeReason;

  // WebSocket

  Duration get pingInterval => null;
  set pingInterval(Duration pingInterval) =>
      throw _noBrowserSupport("pingInterval");

  int get readyState => _inner.readyState;

  String get extensions => _inner.extensions;

  String get protocol => _inner.protocol;

  int get closeCode => _closeCode;

  String get closeReason => _closeReason;

  Future close([int code = 1000, String reason]) async =>
      _inner.close(code, reason);

  void add(data) => _inner.send(data);

  // this is a naive implementation that does not follow the same policy as
  // io.WebSocket's addStream, but follows the interface
  Future addStream(Stream stream) => stream.listen(add).asFuture();

  // Stream

  StreamController _upstreamListenerController = null;
  StreamSubscription _closeSubscription;
  StreamSubscription _errorSubscription;
  StreamSubscription _messageSubscription;
  StreamSubscription listen(void onData(event),
      {Function onError, void onDone(), bool cancelOnError}) {
    if (_upstreamListenerController == null) {
      void onListen() {
        _errorSubscription = _inner.onError.listen((error) {
          _upstreamListenerController.addError(error);
        });
        _messageSubscription = _inner.onMessage.listen((message) {
          var data = message.data;
          assert(data is String || data is List<int>);
          _upstreamListenerController.add(data);
        });
      }

      void onCancel() {
        if (_errorSubscription != null) {
          _errorSubscription.cancel();
        }
        if (_messageSubscription != null) {
          _messageSubscription.cancel();
        }
      }

      _upstreamListenerController = new StreamController.broadcast(
          onListen: onListen, onCancel: onCancel);
      _closeSubscription = _inner.onClose.listen((close) {
        _closed(close.code, close.reason);
      });
    }
    return _upstreamListenerController.stream.listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  void _closed(int code, String reason) {
    _closeCode = code;
    _closeReason = reason;
    _upstreamListenerController.close();
    if (_errorSubscription != null) {
      _errorSubscription.cancel();
    }
    if (_messageSubscription != null) {
      _messageSubscription.cancel();
    }
    _closeSubscription.cancel();
  }

  // StreamSink

  void addError(errorEvent, [StackTrace stackTrace]) =>
      _inner.send(errorEvent.toString());

  Future get done => _inner.onClose.first;

  Uri get url => Uri.parse(_inner.url);
}

UnsupportedError _noBrowserSupport(String component) =>
    new UnsupportedError("$component is not supported in dart:html");

Future<HtmlWebSocketImpl> connect(String url,
    {Iterable<String> protocols, Map<String, dynamic> headers}) async {
  var ws = new html.WebSocket(url, protocols);
  // make sure we are connected
  await ws.onOpen.first;
  return new HtmlWebSocketImpl(ws);
}
