import 'dart:io';

import 'package:band_names/services/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:band_names/models/band.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [];

  @override
  void initState() {
    final socketServices = Provider.of<SocketService>(context, listen: false);
    socketServices.socket.on('active-bands', _hableActiveBands);
    super.initState();
  }

  _hableActiveBands(dynamic payload) {
    this.bands = (payload as List).map((band) => Band.fromMap(band)).toList();

    setState(() {});
  }

  @override
  void dispose() {
    final socketServices = Provider.of<SocketService>(context, listen: false);
    socketServices.socket.off('active-bands');
    socketServices.socket.off('add-band');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Provider.of(context)
    final socketServices = Provider.of<SocketService>(context);
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: addNewBand,
          child: Icon(Icons.add),
          elevation: 1,
        ),
        appBar: AppBar(
          title: Text(
            'BandNames',
            style: TextStyle(color: Colors.black87),
          ),
          backgroundColor: Colors.white,
          elevation: 1,
          actions: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 10),
              child: (socketServices.serverStatus == ServerStatus.Online)
                  ? Icon(
                      Icons.check_circle,
                      color: Colors.blue[300],
                    )
                  : Icon(
                      Icons.offline_bolt,
                      color: Colors.red,
                    ),
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            _showGraph(),
            Expanded(
              child: ListView.builder(
                  itemCount: bands.length,
                  itemBuilder: (context, i) => _banTile(bands[i])),
            ),
          ],
        ));
  }

  Widget _banTile(Band band) {
    final socketService = Provider.of<SocketService>(context, listen: false);
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) =>
          socketService.socket.emit('delete-band', {'id': band.id}),
      background: Container(
        padding: EdgeInsets.only(left: 8),
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Row(children: [
            Icon(Icons.delete_outline),
            Text(
              'DeleteBand',
              style: TextStyle(color: Colors.white),
            ),
          ]),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(band.name),
        trailing: Text(
          '${band.votes}',
          style: TextStyle(fontSize: 20),
        ),
        onTap: () => socketService.socket.emit('vote-band', {'id': band.id}),
      ),
    );
  }

  addNewBand() {
    final textController = new TextEditingController();
    if (Platform.isAndroid) {
      //Android
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('New Band Name:'),
          content: TextField(
            controller: textController,
          ),
          actions: <Widget>[
            MaterialButton(
              onPressed: () => addBandTolist(textController.text),
              child: Text('ADD'),
              textColor: Colors.blue,
              elevation: 1,
            )
          ],
        ),
      );
    }
    // showCupertinoDialog(
    //     context: context,
    //     builder: ( _ ) =>
    //         CupertinoAlertDialog(
    //         title: Text('New Band Name:'),
    //         content: CupertinoTextField(
    //           controller: textController,
    //         ),
    //         actions: <Widget>[
    //           CupertinoDialogAction(
    //             isDefaultAction: true,
    //             onPressed: () => addBandTolist(textController.text),
    //             child: Text('ADD'),
    //           ),
    //           CupertinoDialogAction(
    //             isDestructiveAction: true,
    //             onPressed: () => Navigator.pop(context),
    //             child: Text('Dismiss'),
    //           )
    //         ],
    //       ),
    //     );
  }

  void addBandTolist(String name) {
    final socketService = Provider.of<SocketService>(context, listen: false);

    if (name.length > 1) {
      //Podemos agregar
      //emitir ; add-band {name: name,}
      socketService.socket.emit('add-band', {'name': name});
    }
    Navigator.pop(context);
  }

  Widget _showGraph() {
    Map<String, double> dataMap = new Map();

    bands.forEach((band) {
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
    });
    final List<Color> colorList = [
      Colors.blue,
      Colors.redAccent,
      Colors.pinkAccent,
      Colors.yellowAccent,
      Colors.lightGreen,
      Colors.pink,
    ];
    return Container(
        padding: EdgeInsets.only(top: 10),
        width: double.infinity,
        height: 200,
        child: PieChart(
          dataMap: dataMap,
          animationDuration: Duration(milliseconds: 800),
          chartType: ChartType.disc,
          chartValuesOptions: ChartValuesOptions(
            showChartValueBackground: false,
            showChartValues: true,
            showChartValuesInPercentage: true,
            showChartValuesOutside: false,
            decimalPlaces: 0,
          ),
          // gradientList: ---To add gradient colors---
          // emptyColorGradient: ---Empty Color gradient---
        ));
  }
}
