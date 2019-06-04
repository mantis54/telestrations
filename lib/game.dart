import 'package:flutter_web/material.dart';
import 'package:telestrations_web/draw.dart';
import 'package:telestrations_web/guess.dart';

class GameView extends StatelessWidget {
  final String code;
  final bool host;
  GlobalKey<ScaffoldState> scaffold = GlobalKey<ScaffoldState>();
  var players = ['Matt', 'Adam', 'Test', 'apple', 'jon', 'danny', 'arya'];

  GameView({Key key, this.code, this.host}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: players.length,
      child: Scaffold(
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
                        for (var p in players)
                          ListTile(
                            title: Text(p),
                          )
                      ],
                    );
                  },
                );
              },
            ),
            if (host)
              IconButton(
                icon: Icon(Icons.play_arrow),
                onPressed: () {},
              ),
          ],
          bottom: TabBar(
            tabs: <Widget>[
              for (var p in players)
                Tab(
                  child: Text('${players.indexOf(p) + 1}'),
                )
            ],
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[for (var p in players) Notepad()],
        ),
      ),
    );
  }
}

class Notepad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: 10,
      itemBuilder: (context, round) {
        return Card(
            child: Column(
          children: <Widget>[
            Text('Round ${round + 1}'),
            if (round % 2 == 0) TeleGuess() else TeleDraw()
          ],
        ));
      },
    );
  }
}
