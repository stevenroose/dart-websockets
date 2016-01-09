/*
 * The MIT License (MIT)
 * Copyright (c) 2016 Steven Roose
 */

library websockets.environments.io.env_io;


@MirrorsUsed(
  targets: const [
    "websockets.env.io.IoWebSocket",
    "dart.io.WebSocket"],
  symbols: const [
    "websockets.env.io",
    "IoWebSocket",
    "dart.io",
    "WebSocket",
    "connect"])
import 'dart:mirrors';

import "../environment_exception.dart";
import "../tools.dart" as tools;
import "io_websocket_impl.dart";


/**
 * Check of the user explicitely loaded this environment by importing the env file.
 */
bool get present => _envLibrary != null;

final LibraryMirror _envLibrary = tools.findLibrary(const Symbol("websockets.env.io"));

final ClassMirror _envWebSocketMirror = _envLibrary.declarations[const Symbol("IoWebSocket")];


/**
 * Check whether this environment should be supported.
 */
bool get supported => _nativeLibrary != null;

final LibraryMirror _nativeLibrary = tools.findLibrary(const Symbol("dart.io"));

final ClassMirror _nativeWebSocketMirror = _nativeLibrary.declarations[const Symbol("WebSocket")];


newWebSocketInstance(String url,
    Iterable<String> protocols,
    Map<String, dynamic> headers) async {
  if(present) {
    return await tools.newWebSocketInstance(_envWebSocketMirror, url, protocols, headers);
  } else if(supported) {
    var native = await _nativeWebSocketMirror.invoke(const Symbol("connect"), [url],
      { const Symbol("protocols"): protocols,
        const Symbol("headers"): headers}).reflectee;
    return new IoWebSocketImpl(native, Uri.parse(url));
  } else {
    throw new EnvironmentException("Environment dart:io is not supported");
  }
}

