import 'dart:async';
import 'dart:convert';
import 'package:flutter_web/material.dart';
import 'package:telestrations_web/draw.dart';
import 'package:telestrations_web/guess.dart';
import 'package:firebase/firebase.dart';
import 'package:firebase/firestore.dart' as fs;
import 'package:http/http.dart' as http;

class GameView extends StatefulWidget {
  final String code;
  final String username;
  final int playerNum;

  GameView({Key key, this.username, this.code, this.playerNum})
      : super(key: key);

  @override
  _GameViewState createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  GlobalKey<ScaffoldState> scaffold = GlobalKey<ScaffoldState>();
  String code;
  int round;
  int player;
  String phrase;
  List<String> players;
  fs.Firestore store;

  @override
  void initState() {
    store = firestore();
    super.initState();
    player = 0;
    round = 0;
    if (widget.playerNum == 0) {
      players = [widget.username];
      code = '';
      initLobby();
    } else {
      code = widget.code;
    }
  }

  Future<void> initLobby() async {
    print('${widget.username} is attempting to start a game');
    var res = await http.post(
        'https://us-central1-telestrations-3a71c.cloudfunctions.net/create',
        headers: {
          'content-type': 'application/json',
        },
        body: json.encode(
          {
            'leader': widget.username,
          },
        ));
    if (res.body != 'taken') {
      setState(() {
        code = res.body;
      });
    } else {
      await initLobby();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (code == '') {
      return Scaffold(
        key: scaffold,
        appBar: AppBar(
          title: Text('Telestrations Game: loading'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.people),
              onPressed: null,
            ),
            if (widget.playerNum == 0)
              IconButton(
                icon: Icon(Icons.play_arrow),
                onPressed: null,
              ),
          ],
        ),
        body: Notepad(),
      );
    }
    return StreamBuilder<fs.DocumentSnapshot>(
      stream: store.collection('games').doc(code).onSnapshot,
      builder: (context, snapshot) {
        var data = snapshot.data.data();
        List<Map<String, String>> turns;
        if(data.keys.contains('turns')) {
          turns = data['turns'];
        }
        return Scaffold(
            key: scaffold,
            appBar: AppBar(
              title: Text('Telestrations Game: $code'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.people),
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            for (var p in data['players'])
                              ListTile(
                                title: Text(p),
                              )
                          ],
                        );
                      },
                    );
                  },
                ),
                if (widget.playerNum == 0)
                  IconButton(
                    icon: Icon(Icons.play_arrow),
                    onPressed: () {
                      var games = <Map<String, String>>{};
                      for (var p in data['players']) {
                        games.add({'playerName': p});
                      }
                      store.collection('games').doc(code).update(data: {
                        'hasBegun': true,
                        'turns': games,
                      });
                    },
                  ),
              ],
            ),
            body: !data['hasBegun']
                ? Center(
                    child: Column(
                      children: <Widget>[
                        Text('Waiting for game to start'),
                        TeleDraw(),
                      ],
                    ),
                  )
                : round == 0 ? Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * .8,
                      child: Row(
                        children: <Widget>[
                          TextField(
                            onChanged: (update) {
                              setState((){
                                phrase = update;
                              });
                            },
                          ),
                          FlatButton(
                            child: Text('Submit'),
                            onPressed: (){
                              store.collection('games').doc(code).update(data: {
                                'turns': 
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ): Notepad());
      },
    );
  }
}

class Notepad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: TeleDraw());
  }
}
