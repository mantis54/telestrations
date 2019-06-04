import 'package:flutter_web/material.dart';

class TeleGuess extends StatefulWidget {
  TeleGuess({Key key}) : super(key: key);

  _TeleGuessState createState() => _TeleGuessState();
}

class _TeleGuessState extends State<TeleGuess> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('This is a guess widget'),
    );
  }
}
