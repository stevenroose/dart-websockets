/*
 * The MIT License (MIT)
 * Copyright (c) 2016 Steven Roose
 */

library websockets.environments.html.env_html;


@MirrorsUsed(
  targets: const [
    "websockets.environments.html.constructor_helper.HtmlWebSocketConstructorHelper",
    "dart.html.WebSocket"],
  symbols: const ["",
    "websockets.environments.html.constructor_helper",
    "HtmlWebSocketConstructorHelper",
    "dart.html",
    "WebSocket",
    "constructHtmlWebSocket"])
import 'dart:mirrors';

import "../environment_exception.dart";
import "../tools.dart" as tools;
import "html_websocket_impl.dart";


/**
 * Check of the user explicitely loaded this environment by importing the env file.
 */
bool get present => _envLibrary != null;

final LibraryMirror _envLibrary = tools.findLibrary(const Symbol("websockets.environments.html.constructor_helper"));

final ClassMirror _envWebSocketMirror = _envLibrary.declarations[const Symbol("HtmlWebSocketConstructorHelper")];


/**
 * Check whether this environment should be supported.
 */
bool get supported => false; //_nativeLibrary != null;
// currently not possible, see code below

final LibraryMirror _nativeLibrary = tools.findLibrary(const Symbol("dart.html"));

final ClassMirror _nativeWebSocketMirror = _nativeLibrary.declarations[const Symbol("WebSocket")];


newWebSocketInstance(String url,
  Iterable<String> protocols,
  Map<String, dynamic> headers) async {
  if(present) {
    return await _envLibrary.invoke(const Symbol('constructHtmlWebSocket'),
        [url, protocols, headers]).reflectee;
  } else if(supported) {
    // this very line of code is not possible due to this bug:
    //   https://dartbug.com/18541
    var native = _nativeWebSocketMirror.invoke(const Symbol(""), [url, protocols]).reflectee;
    await native.onOpen.first;
    return new HtmlWebSocketImpl(native);
  } else {
    throw new EnvironmentException("Environment dart:html is not supported. "
      "If you are in a browser, import \"package:websockets/env/html.dart\" to enable WebSocket usage.");
  }
}
