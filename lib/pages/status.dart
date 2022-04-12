import 'package:flutter/material.dart';
import 'package:band_names/services/socket_service.dart';
import 'package:provider/provider.dart';

class StatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final socketServices = Provider.of<SocketService>(context);

    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text('Server Status: ${socketServices.serverStatus}')],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          socketServices.emit('emitir-mensaje',
              {'nombre': 'Fluter', 'mensaje': 'Hola desde Fluter'});
        },
        elevation: 1,
        child: Icon(Icons.message),
      ),
    );
  }
}
