/*
 * The MIT License (MIT)
 * Copyright (c) 2016 Steven Roose
 */

/**
 * The reason we have this is because dart:mirrors in dart2js code does not support
 * calling methods using named arguments. So we are just providing a method that
 * takes the methods as regular parameters.
 *
 * Check out dartbug.com/25388, for more info on the bug.
 */
library websockets.environments.html.constructor_helper;


import "../../../env/html.dart";


class HtmlWebSocketConstructorHelper {
  static constructHtmlWebSocket(url, protocols, headers) =>
    HtmlWebSocket.connect(url, protocols: protocols, headers: headers);
}