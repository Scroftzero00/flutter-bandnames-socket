import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:band_names/models/band.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'Metallica', votes: 5),
    Band(id: '2', name: 'Queen', votes: 5),
    Band(id: '3', name: 'Heroes del Silencio', votes: 5),
    Band(id: '4', name: 'Bon Jovi', votes: 5),
  ];
  @override
  Widget build(BuildContext context) {
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
        ),
        body: ListView.builder(
            itemCount: bands.length,
            itemBuilder: (context, i) => _banTile(bands[i])));
  }

  Widget _banTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        print('direccion: ${direction}');
        print('id: ${band.id}');
        //TODO llamar el borrado del server
      },
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
        onTap: () {
          print(band.name);
        },
      ),
    );
  }

  addNewBand() {
    final textController = new TextEditingController();
    if (Platform.isAndroid) {
      //Android
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
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
            );
          });
    }
    // showCupertinoDialog(
    //     context: context,
    //     builder: (context) {
    //       return CupertinoAlertDialog(
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
    //       );
    //     });
  }

  void addBandTolist(String name) {
    print(name);
    if (name.length > 1) {
      //Podemos agregar
      this
          .bands
          .add(new Band(id: DateTime.now().toString(), name: name, votes: 0));
      setState(() {});
    }
    Navigator.pop(context);
  }
}
