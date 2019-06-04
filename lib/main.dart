import 'package:flutter_web/material.dart';
import 'package:telestrations_web/curve.dart';
import 'package:telestrations_web/game.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController();
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
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => GameView(
                        code: 'test',
                        host: true,
                      ),
                ));
              },
            ),
            RaisedButton(
              child: Text('Join Game'),
              onPressed: () {},
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
