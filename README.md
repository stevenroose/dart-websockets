# websockets

A platform-independent WebSocket library using the Dart async API.

This library defines a WebSocket interface very much like the one in `dart:io` that can be used when writing
platform-independent packages like API-wrappers.


## Documentation

The documentation for this library can be found [on DartDocs](https://www.dartdocs.org/documentation/websockets/0.2.1/).

## Usage

Creating and using WebSockets with this library is easy, it works entirely the same as how the dart:io.WebSocket
class works:

```dart
import "dart:io";
import "package:websockets/websockets.dart";

main() async {
  WebSocket ws = await WebSocket.connect("wss://echo.websocket.org");
  ws.listen(print);
  ws.add("test");
}
```

### When developing platform-independent packages

Everything stays the same. The websockets import does not import `dart:io` or `dart:html`, so your code will run
on both platforms. One thing to remember is that the user of your library has to make an explicit import of either of
`dart:io` or `dart:html`.