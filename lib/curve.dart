import 'package:flutter_web/material.dart';
import 'package:flutter_web/widgets.dart';

class HilbertDraw extends StatefulWidget {
  const HilbertDraw({Key key}) : super(key: key);

  @override
  _HilbertDrawState createState() => _HilbertDrawState();
}

class _HilbertDrawState extends State<HilbertDraw> {
  int depth;

  @override
  void initState() {
    super.initState();
    depth = 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hilbert Curve Test'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: () {
              if (depth > 1) {
                setState(() {
                  depth--;
                });
              }
            },
          ),
          Text('$depth'),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              setState(() {
                depth++;
              });
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: 202,
          height: 202,
          decoration: BoxDecoration(
            border: Border.all(),
          ),
          child: CustomPaint(
            painter: HilbertPainter(depth: depth),
          ),
        ),
      ),
    );
  }
}

class HilbertPainter extends CustomPainter {
  int depth;
  List<Offset> points;

  HilbertPainter({this.depth});

  @override
  void paint(Canvas canvas, Size size) {
    var offset = size.width / 4;
    print('${size.height}:${size.width}');
    print(offset);
    canvas.drawLine(Offset(100, 0), Offset(100, 200), Paint());
    canvas.drawLine(Offset(0, 100), Offset(200, 100), Paint());
    canvas.drawLine(Offset(50, 0), Offset(50, 200), Paint());
    canvas.drawLine(Offset(0, 50), Offset(200, 50), Paint());
    box(canvas, offset, offset, offset * 2);
    box(canvas, offset / 2, offset / 2, offset);
    // canvas.drawLine(Offset(offset, offset),
    //     Offset(size.width - offset, size.height - offset), Paint());
  }

  void box(Canvas canvas, double xMin, double yMin, double split) {
    canvas.drawLine(Offset(xMin, yMin), Offset(xMin, yMin + split), Paint());
    canvas.drawLine(Offset(xMin, yMin + split),
        Offset(xMin + split, yMin + split), Paint());
    canvas.drawLine(Offset(xMin + split, yMin + split),
        Offset(xMin + split, yMin), Paint());
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
