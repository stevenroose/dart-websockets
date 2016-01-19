/*
 * The MIT License (MIT)
 * Copyright (c) 2016 Steven Roose
 */

library websockets.environments.html.env_html;


@GlobalQuantifyCapability(r"^dart.dom.html.WebSocket$", tools.reflector)
import "package:reflectable/reflectable.dart";

import "../tools.dart" as tools;

import "html_websocket_impl.dart";


/**
 * Check whether this environment should be supported.
 */
bool get supported => _nativeLibrary != null;

final LibraryMirror _nativeLibrary = tools.findLibrary("dart.html");

final ClassMirror _nativeWebSocketMirror = _nativeLibrary.declarations["WebSocket"];


newWebSocketInstance(String url,
  Iterable<String> protocols,
  Map<String, dynamic> headers) async {
  if(supported) {
    var native = _nativeWebSocketMirror.invoke("", [url, protocols]) as dynamic;
    await native.onOpen.first;
    return new HtmlWebSocketImpl(native);
  } else {
    throw tools.exception("Environment dart:html is not supported. "
      "If you are in a browser, import \"package:websockets/env/html.dart\" "
      "to enable WebSocket usage.");
  }
}
