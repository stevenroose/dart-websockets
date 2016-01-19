/*
 * The MIT License (MIT)
 * Copyright (c) 2016 Steven Roose
 */

library websockets.src.websocket;

import "dart:async";

import "environments/tools.dart" as tools;

import "environments/html/env_html.dart" as env_html;
import "environments/io/env_io.dart" as env_io;

/**
 * Generic WebSocket interface that can be used in the Dart VM as well as in the Browser.
 * Currently, to create a new instance in a Browser, use BrowserWebSocket.
 *
 * The interface is based on the dart.io.WebSocket interface of SDK v1.10.1.
 */
abstract class WebSocket implements StreamSink, Stream {
  /**
   * Possible states of the connection.
   */
  static const int CONNECTING = 0;
  static const int OPEN = 1;
  static const int CLOSING = 2;
  static const int CLOSED = 3;

  /**
   * Set and get the interval for sending ping signals. If a ping message is not
   * answered by a pong message from the peer, the `WebSocket` is assumed
   * disconnected and the connection is closed with a
   * [WebSocketStatus.GOING_AWAY] close code. When a ping signal is sent, the
   * pong message must be received within [pingInterval].
   *
   * There are never two outstanding pings at any given time, and the next ping
   * timer starts when the pong is received.
   *
   * Set the [pingInterval] to `null` to disable sending ping messages.
   *
   * The default value is `null`.
   *
   * !!! This method does not currently work in Browsers.
   */
  Duration pingInterval;

  /**
   * Create a new WebSocket connection. The URL supplied in [url]
   * must use the scheme `ws` or `wss` and can be either of type
   * [:String:] or [:Uri:].
   *
   * The [protocols] argument is specifying the subprotocols the
   * client is willing to speak.
   *
   * The [headers] argument is specifying additional HTTP headers for
   * setting up the connection. This would typically be the `Origin`
   * header and potentially cookies. The keys of the map are the header
   * fields and the values are either String or List<String>.
   *
   * If [headers] is provided, there are a number of headers
   * which are controlled by the WebSocket connection process. These
   * headers are:
   *
   *   - `connection`
   *   - `sec-websocket-key`
   *   - `sec-websocket-protocol`
   *   - `sec-websocket-version`
   *   - `upgrade`
   *
   * If any of these are passed in the `headers` map they will be ignored.
   *
   * If the `url` contains user information this will be passed as basic
   * authentication when setting up the connection.
   *
   * !!! The [headers] field is not supported in browsers. Browsers add their
   * own headers when establishing the WebSocket.
   */
  static Future<WebSocket> connect(url,
      {Iterable<String> protocols, Map<String, dynamic> headers}) async {
    if (tools.presentEnv != null) {
      return tools.createWebSocketWithPresentEnv(url, protocols, headers);
    }
    // then try environments that are supported
    if (env_io.supported) {
      return env_io.newWebSocketInstance(url, protocols, headers);
    }
    if (env_html.supported) {
      return env_html.newWebSocketInstance(url, protocols, headers);
    }
    throw tools.exception("No working environment detected. "
        "You can enable environment by importing it, f.e. import \"package:websockets/env/html.dart\"");
  }

  /**
   * Returns the current state of the connection.
   */
  int get readyState;

  /**
   * The extensions property is initially the empty string. After the
   * WebSocket connection is established this string reflects the
   * extensions used by the server.
   */
  String get extensions;

  /**
   * The protocol property is initially the empty string. After the
   * WebSocket connection is established the value is the subprotocol
   * selected by the server. If no subprotocol is negotiated the
   * value will remain [:null:].
   */
  String get protocol;

  /**
   * The close code set when the WebSocket connection is closed. If
   * there is no close code available this property will be [:null:]
   */
  int get closeCode;

  /**
   * The close reason set when the WebSocket connection is closed. If
   * there is no close reason available this property will be [:null:]
   */
  String get closeReason;

  /**
   * Closes the WebSocket connection. Set the optional [code] and [reason]
   * arguments to send close information to the remote peer. If they are
   * omitted, the peer will see [WebSocketStatus.NO_STATUS_RECEIVED] code
   * with no reason.
   */
  Future close([int code, String reason]);

  /**
   * Sends data on the WebSocket connection. The data in [data] must
   * be either a [:String:], or a [:List<int>:] holding bytes.
   */
  void add(data);

  /**
   * Sends data from a stream on WebSocket connection. Each data event from
   * [stream] will be send as a single WebSocket frame. The data from [stream]
   * must be either [:String:]s, or [:List<int>:]s holding bytes.
   */
  Future addStream(Stream stream);

  /**
   * The URL this WebSocket is connected to.
   */
  Uri get url;
}
