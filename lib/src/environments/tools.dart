/*
 * The MIT License (MIT)
 * Copyright (c) 2016 Steven Roose
 */

library websockets.env_helpers.tools;

@MirrorsUsed(targets: const [], symbols: const ["connect", "protocols", "headers"])
import "dart:mirrors";


LibraryMirror findLibrary(Symbol symbol) {
  try {
    return currentMirrorSystem().findLibrary(symbol);
  } catch (_) {
    // TODO(nweiz): narrow the catch clause when issue 18532 is fixed.
    return null;
  }
}

/**
 * Invoke the static connect method of the given WebSocket subclass.
 */
newWebSocketInstance(ClassMirror envClass, String url,
  Iterable<String> protocols,
  Map<String, dynamic> headers) =>
  envClass.invoke(const Symbol("connect"), [url],
    { const Symbol("protocols"): protocols,
      const Symbol("headers"): headers}).reflectee;