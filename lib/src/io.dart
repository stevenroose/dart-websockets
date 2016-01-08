/*
 * The MIT License (MIT)
 * Copyright (c) 2016 Steven Roose
 */

// Copied from package:io and adapted to the needs of package:websockets
library websockets.io;

@MirrorsUsed(targets: const ['dart.io.WebSocket'])
import 'dart:mirrors';

/// Whether `dart:io` is supported on this platform.
bool get supported => _library != null;

/// The `dart:io` library mirror, or `null` if it couldn't be loaded.
final _library = _getLibrary();

/// The `dart:io` HttpClient class mirror.
final ClassMirror _webSocketMirror =
    _library.declarations[const Symbol('WebSocket')];

/// The `dart:io` File class mirror.
final ClassMirror _file = _library.declarations[const Symbol('File')];

/// Asserts that the [name]d `dart:io` feature is supported on this platform.
///
/// If `dart:io` doesn't work on this platform, this throws an
/// [UnsupportedError].
void assertSupported(String name) {
  if (supported) return;
  throw new UnsupportedError("$name isn't supported on this platform.");
}

/// Creates a new `dart:io` WebSocket instance.
newWebSocketInstance() => _webSocketMirror.newInstance(const Symbol(''), []).reflectee;

/// Call the static connect method for io.WebSocket
connectNewWebSocket(String url,
                    {Iterable<String> protocols,
                    Map<String, dynamic> headers}) =>
    _webSocketMirror.invoke(const Symbol('connect'), [url],
                            { const Symbol('protocols'): protocols,
                              const Symbol('headers'): headers}).reflectee;


/// Returns whether [client] is a `dart:io` HttpClient.
bool isWebSocketInstance(instance) => reflect(instance).type.isSubtypeOf(_webSocketMirror);

/// Tries to load `dart:io` and returns `null` if it fails.
LibraryMirror _getLibrary() {
  try {
    return currentMirrorSystem().findLibrary(const Symbol('dart.io'));
  } catch (_) {
    // TODO(nweiz): narrow the catch clause when issue 18532 is fixed.
    return null;
  }
}
