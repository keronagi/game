import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketServise {
  static final SocketServise _instance = SocketServise._internal();
  factory SocketServise() => _instance;
  SocketServise._internal();
  late IO.Socket socket;
  void conectToServer() {
    socket = IO.io('http://192.168.1.6:3000', <String, dynamic>{
      "transports": ["websocket"],
      'autoConnect': false,
    });
    socket.connected;
    socket.onConnect((_) {
      print("conected to server");
    });
    socket.onDisconnect((_) {
      print("disconected");
    });
  }

  void emit(String event, dynamic data) {
    socket.emit(event, data);
  }

  void on(String event, Function(dynamic) handler) {
    socket.on(event, handler);
  }
}
