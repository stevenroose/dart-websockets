/*
 * The MIT License (MIT)
 * Copyright (c) 2016 Steven Roose
 */

/**
 * A websocket.env library should only have a single class declared!
 * One extending WebSocket and providing a static connect() method!
 */
library websockets.env.html;

import "dart:async";
import "dart:html" as html;

import "../src/environments/html/html_websocket_impl.dart";

class HtmlWebSocket extends HtmlWebSocketImpl {
  HtmlWebSocket._(_inner) : super(_inner);

  static Future<HtmlWebSocket> connect(String url,
      {Iterable<String> protocols, Map<String, dynamic> headers}) async {
    var ws = new html.WebSocket(url, protocols);
    // make sure we are connected
    await ws.onOpen.first;
    return new HtmlWebSocket._(ws);
  }
}
