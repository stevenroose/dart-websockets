# websockets

A platform-independent WebSocket library using the Dart async API.

This library defines a WebSocket interface very much like the one in `dart:io` that can be used when writing
platform-independent packages like API-wrappers.
Currently, due to [an outstanding issue in Dart](http://dartbug.com/18541), usage in browsers requires
an additional import statement, but other than that it works exactly the same.


## Documentation

The documentation for this library can be found [on DartDocs](https://www.dartdocs.org/documentation/websockets/0.2.0/).

## Usage

Creating and using WebSockets with this library is easy, it works entirely the same as how the dart:io.WebSocket
class works:

```dart
import "package:websockets/websockets.dart";

main() async {
  WebSocket ws = await WebSocket.connect("wss://echo.websocket.org");
  ws.listen(print);
  ws.add("test");
}
```

### When developing platform-independent packages

Everything stayes the same. The websockets import does not import `dart:io` or `dart:html`, so your code will run
on both platforms.


## Using in the Browser

In the browser, more specifically when using dart2js, an additional import is required. Other than this import, everything
works the same way. This exception is only temporarily until the [issue](http://dartbug.com/18541) in Dart is fixed.

Please note that, when developing a platform-independent package, the end user will still be required to do this import.

```dart
import "package:websockets/env/html.dart";
import "package:websockets/websockets.dart";

main() async {
  WebSocket ws = await WebSocket.connect("wss://echo.websocket.org");
  ws.listen(print);
  ws.add("test");
}
```