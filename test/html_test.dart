/*
 * The MIT License (MIT)
 * Copyright (c) 2016 Steven Roose
 */

library websockets.test.html;


import "dart:async";
import "dart:html";

import "package:websockets/websockets.dart" as ws;
import "package:websockets/browser_websockets.dart";


main() async {
  ws.WebSocket sock = await BrowserWebSocket.connect("wss://echo.websocket.org");
  sock.listen(htmlPrint);
  sock.add("test");


  new Timer(const Duration(seconds: 3), () {
    sock.close(3333, "reason33");
    new Timer(const Duration(seconds: 2), () {
      sock.add("test2");
    });
  });
}


htmlPrint(message) {
  window.document.getElementById("htmlconsole").appendHtml("$message<br />");
}