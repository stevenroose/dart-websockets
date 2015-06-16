# websockets

A platform-independent WebSocket library using the Stream API.

This package defines a WebSocket interface much like the one in `dart:io` that can be used when writing 
platform-independent libraries like API-wrappers.
Currently, due to an outstanding issue in Dart, usage in browsers is slightly different than in the VM; 
see "Using on the Browser" below.


## Using

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


### For creating libraries

Because, currently, VM users and browser users use different classes (this will change in the future), platform-
independent libraries cannot create WebSocket instances themselves. That's why we provided the [:WebSocketConnector:]
typedef that libraries can use to create WebSockets.

This is how an API-wrapper that consumes a WebSocket can be defined and used:

```dart
import "dart:convert";
import "package:websockets/websockets.dart";

class MyApiWrapper {
  static const API_URL = "ws://myapi.com";
    
  WebSocket _ws;
  
  Future<MyApiWrapper> connect(WebSocketConnector connector) async {
    WebSocket ws = await connector(API_URL);
    return new MyApiWrapper._(ws);
  }
  MyApiWrapper._(this._ws);
  
  
  void subscribeToSomeMessages() {
    _ws.add('''{"subscribe":"some_messages"}''');
  }
  
  Stream<Map> get onMessage => _ws.map(const JsonDecoder().decode);
  Stream<Map> get onSomeMessage => onMessage.filter((m) => m["type"] == "some_message");
}
```

The user of this wrapper simply passes the [:WebSocket.connect:] method to the API-wrapper class.

```dart
import "package:myapi/myapi.dart";
import "package:websockets/websockets.dart";

main() async {
  MyApiWrapper api = await MyApiWrapper.connect(WebSocket.connect);
  api.subscribeToSomeMessages();
  api.onSomeMessage.listen(print);
}
```


## Using on the Browser

In the browser, the [:BrowserWebSocket:] is used instead of the standard [:WebSocket:] class. That's the only 
difference:

For the API-wrapper from the previous example:

```dart
import "package:myapi/myapi.dart";
import "package:websockets/browser_websockets.dart";

main() async {
  MyApiWrapper api = await MyApiWrapper.connect(BrowserWebSocket.connect);
  api.subscribeToSomeMessages();
  api.onSomeMessage.listen(print);
}
```

Or for regular WebSocket usage:

```dart
import "package:websockets/websockets.dart";
import "package:websockets/browser_websockets.dart";

main() async {
  WebSocket ws = await BrowserWebSocket.connect("wss://echo.websocket.org");
  ws.listen(print);
  ws.add("test");
}
```