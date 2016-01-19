/*
 * The MIT License (MIT)
 * Copyright (c) 2016 Steven Roose
 */

library websockets.environments.tools;


@GlobalQuantifyCapability(_ENV_LIBRARY_PREFIX, reflector)
import "package:reflectable/reflectable.dart";

import "environment_exception.dart";


const _ENV_LIBRARY_PREFIX = r"^websockets\.env\..*$";
final _ENV_LIBRARY_PREFIX_REGEX = new RegExp(_ENV_LIBRARY_PREFIX);


const Reflectable reflector = const WebSocketsEnvReflector();


LibraryMirror findLibrary(String library) {
  try {
    return reflector.findLibrary(library);
  } catch (_) {
    // TODO(nweiz): narrow the catch clause when issue 18532 is fixed.
    return null;
  }
}

/**
 * Since we got a GlobalQuantityCapability on all environment libraries,
 * we can find one if it is included.
 */
bool _envTested = false;
LibraryMirror _presentEnv;
LibraryMirror get presentEnv {
  if(!_envTested) {
    _presentEnv = reflector.libraries.values.firstWhere(
      (mirror) => _ENV_LIBRARY_PREFIX_REGEX.hasMatch(mirror.qualifiedName),
      orElse: () => null);
    _envTested = true;
  }
  return _presentEnv;
}

createWebSocketWithPresentEnv(String url,
  Iterable<String> protocols,
  Map<String, dynamic> headers) {
  LibraryMirror env = presentEnv;
  if(env == null)
    throw exception("No environment present!");
  // env classes only have a single class declared
  assert(env.declarations.length == 1);
  return newWebSocketInstance(env.declarations[env.declarations.keys.single],
    url, protocols, headers);
}

/**
 * Invoke the static connect method of the given WebSocket subclass.
 */
newWebSocketInstance(ClassMirror envClass, String url,
  Iterable<String> protocols,
  Map<String, dynamic> headers) =>
  envClass.invoke("connect", [url],
    { const Symbol("protocols"): protocols,
      const Symbol("headers"): headers});


EnvironmentException exception(String message) =>
    new EnvironmentException(message);

class WebSocketsEnvReflector extends Reflectable {
  const WebSocketsEnvReflector()
      : super(libraryCapability, staticInvokeCapability, declarationsCapability,
            newInstanceCapability);
}