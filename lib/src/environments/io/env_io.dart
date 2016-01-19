/*
 * The MIT License (MIT)
 * Copyright (c) 2016 Steven Roose
 */

library websockets.environments.io.env_io;

@GlobalQuantifyCapability(r"^dart.io.WebSocket$", tools.reflector)
import "package:reflectable/reflectable.dart";

import "../tools.dart" as tools;

import "io_websocket_impl.dart";

/**
 * Check whether this environment should be supported.
 */
bool get supported => _nativeLibrary != null;

final LibraryMirror _nativeLibrary = tools.findLibrary("dart.io");

final ClassMirror _nativeWebSocketMirror =
    _nativeLibrary.declarations["WebSocket"];

newWebSocketInstance(String url, Iterable<String> protocols,
    Map<String, dynamic> headers) async {
  if (supported) {
    var native = await _nativeWebSocketMirror.invoke("connect", [
      url
    ], {
      const Symbol("protocols"): protocols,
      const Symbol("headers"): headers
    });
    return new IoWebSocketImpl(native, Uri.parse(url));
  } else {
    throw tools.exception("Environment dart:io is not supported");
  }
}
