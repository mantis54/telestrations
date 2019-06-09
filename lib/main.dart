import 'dart:convert';

import 'package:flutter_web/material.dart';
import 'package:firebase/firebase.dart';
import 'package:telestrations_web/curve.dart';
import 'package:telestrations_web/game.dart';
import 'package:http/http.dart' as http;

void main() {
  initializeApp(
    apiKey: "AIzaSyCDKcpdP-YKRQAXGnSozNytPPUND-TlVW0",
    authDomain: "telestrations-3a71c.firebaseapp.com",
    databaseURL: "https://telestrations-3a71c.firebaseio.com",
    projectId: "telestrations-3a71c",
    storageBucket: "telestrations-3a71c.appspot.com",
    messagingSenderId: "667341614428",
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Telestrations',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController nameController;
  TextEditingController codeController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController();
    codeController = TextEditingController();
  }

  Future<void> joinGame() async {
    var code = codeController.text;
    print('${nameController.text} is attempting to join game $code');
    var res = await http.post(
      'https://us-central1-telestrations-3a71c.cloudfunctions.net/join',
      headers: {
        'content-type': 'application/json',
      },
      body: json.encode(
        {
          'name': nameController.text,
          'code': code,
        },
      ),
    );
    print(res.body);
    if (!res.body.contains('e')) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => GameView(
                code: code,
                playerNum: int.parse(res.body),
                username: nameController.text,
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Telestrations'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 100,
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(hintText: 'Name'),
                onChanged: (update) {
                  setState(() {
                    nameController.text = update;
                  });
                },
              ),
            ),
            Divider(),
            RaisedButton(
              child: Text('Create Game'),
              onPressed: nameController.text.isNotEmpty
                  ? () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => GameView(
                              code: null,
                              username: nameController.text,
                              playerNum: 0,
                            ),
                      ));
                    }
                  : null,
            ),
            Divider(),
            Container(
              width: 100,
              child: TextField(
                controller: codeController,
                decoration: InputDecoration(hintText: 'Game Code'),
                onChanged: (update) {
                  setState(() {
                    codeController.text = update;
                  });
                },
              ),
            ),
            RaisedButton(
              child: Text('Join Game'),
              onPressed: nameController.text.isNotEmpty &&
                      codeController.text.isNotEmpty
                  ? () {
                      joinGame();
                    }
                  : null,
            ),
            RaisedButton(
              child: Text('Hilbert Curve'),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => HilbertDraw()));
              },
            )
          ],
        ),
      ),
    );
  }
}
