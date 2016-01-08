/*
 * The MIT License (MIT)
 * Copyright (c) 2016 Steven Roose
 */

library websockets.browser;


import "dart:async";

import "src/html_websocket.dart";
import "src/websocket.dart";


// just an alias class for HtmlWebSocket that will be removed
// as soon as issue 18541 is resolved
class BrowserWebSocket extends HtmlWebSocket {

  static Future<WebSocket> connect(String url,
                                       {Iterable<String> protocols,
                                       Map<String, dynamic> headers}) async =>
      HtmlWebSocket.connect(url, protocols: protocols, headers: headers);

}