/*
 * The MIT License (MIT)
 * Copyright (c) 2016 Steven Roose
 */

library websockets.env.html;


import "dart:async";
import "dart:html" as html;

import "../src/websocket_base.dart";
import "../src/environments/html/html_websocket_impl.dart";

import "../src/environments/html/constructor_helper.dart";


class HtmlWebSocket extends HtmlWebSocketImpl {

  HtmlWebSocket._(_inner) : super(_inner);

  static Future<HtmlWebSocket> connect(String url,
                                     {Iterable<String> protocols,
                                     Map<String, dynamic> headers}) async {
    var ws = new html.WebSocket(url, protocols);
    // make sure we are connected
    await ws.onOpen.first;
    return new HtmlWebSocket._(ws);
  }

}