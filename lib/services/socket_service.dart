import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;
  ServerStatus get serverStatus => this._serverStatus;

  IO.Socket get socket => this._socket;

  Function get emit => this._socket.emit;

  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    //DART Client
    _socket = IO.io(
        'http://192.168.10.14:3003/',
        IO.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .enableAutoConnect() // enable auto-connection// optional
            .build());
    _socket.onConnect((_) {
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
      // socket.emit('msg', 'test');
    });
    _socket.onDisconnect((_) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
  }
}
