import 'dart:math';
import 'dart:typed_data';
import 'package:flutter_web/material.dart';
import 'package:flutter_web_ui/ui.dart' as ui;
import 'package:telestrations_web/lines.dart';

class TeleDraw extends StatefulWidget {
  TeleDraw({Key key}) : super(key: key);

  _TeleDrawState createState() => _TeleDrawState();
}

class _TeleDrawState extends State<TeleDraw> {
  List<Line> points;
  int color;
  Duration time;
  double radius;
  bool filled;
  Types selectedType;
  Canvas canvas;
  ByteData bytes;
  ui.PictureRecorder recorder;
  var colors = [Colors.red, Colors.green, Colors.blue, Colors.black];

  @override
  void initState() {
    super.initState();
    color = 0;
    radius = 10;
    points = [];
    filled = true;
    recorder = ui.PictureRecorder();
    canvas = Canvas(recorder);
    selectedType = Types.drawLine;
  }

  Offset getRelative(Offset offset, double size) {
    return Offset(offset.dx / size * 100, offset.dy / size * 100);
  }

  Future<void> setPic(ui.Picture pic) async {
    final img = pic.toImage(200, 200);
    print('${pic.toImage(200, 200) == null}');
    print('${pic.toString()}');
    final pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);
    setState(() {
      bytes = pngBytes;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.shortestSide * .8;
    return Container(
      decoration: BoxDecoration(border: Border.all()),
      height: size,
      width: size,
      // color: Colors.grey,
      child: Stack(
        children: <Widget>[
          ClipRect(
            child: CustomPaint(
              size: Size(
                size,
                size,
              ),
              painter: MyPainter(
                points: points,
                myCanvas: canvas,
              ),
            ),
          ),
          GestureDetector(
            onPanStart: (details) {
              setState(() {
                time = details.sourceTimeStamp;
              });

              // print('pan start: ${details.globalPosition}');
              RenderBox getBox = context.findRenderObject();
              var local = getBox.globalToLocal(details.globalPosition);
              var relative = getRelative(local, size);
              points.add(
                  Line(selectedType, relative, colors[color], size, radius));
            },
            onPanUpdate: (update) {
              RenderBox getBox = context.findRenderObject();
              var local = getBox.globalToLocal(update.globalPosition);
              // print('pan update $local');
              var relative = getRelative(local, size);

              if (relative.dx <= 100 &&
                  relative.dy <= 100 &&
                  relative.dx >= 0 &&
                  relative.dy >= 0) {
                switch (selectedType) {
                  case Types.drawLine:
                    points.last.add(relative);
                    break;
                  case Types.drawRec:
                  case Types.drawOval:
                    points.last.other(relative);
                    points.last.fill(filled);
                    break;
                  default:
                }

                if (update.sourceTimeStamp - time >
                    Duration(milliseconds: 10)) {
                  setState(() {
                    time = update.sourceTimeStamp;
                  });
                }
              }
            },
            onPanEnd: (details) {
              setState(() {});
              // print('pan end');
              print(points);
            },
          ),
          Positioned(
            top: 0,
            left: 0,
            child: RaisedButton(
              child: Text('Submit'),
              onPressed: () {
                final pic = recorder.endRecording();
                // var r = recorder.beginRecording(Rect.largest);

                // setPic(pic);
                int deci = 0;
                var octo = 0;
                var penta = 0;
                var old = 0;
                for (var p in points) {
                  deci += p.deci.length;
                  octo += p.octo.length;
                  penta += p.penta.length;
                  old += p.points.length;
                }
                print('full: $old\ndeci: $deci\nocto: $octo\npenta: $penta');
                print(points.last.points.last);
              },
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Card(
                  child: Row(
                    children: <Widget>[
                      for (int i = 0; i < colors.length; i++)
                        Container(
                          height: 50,
                          width: 50,
                          child: Card(
                            elevation: color == i ? 0 : 20,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  print('set color to $i');
                                  color = i;
                                });
                              },
                            ),
                            color: colors[i],
                          ),
                        ),
                      Container(
                        height: 50,
                        width: 50,
                        child: Card(
                          elevation: 20,
                          child: GestureDetector(
                            child: Center(child: Icon(Icons.delete)),
                            onTap: () {
                              setState(() {
                                points = [];
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  child: Row(
                    children: <Widget>[
                      for (Types t in Types.values)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedType = t;
                            });
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            child: Card(
                              elevation: selectedType == t ? 0 : 20,
                              child: t == Types.drawLine
                                  ? Icon(Icons.create)
                                  : Center(
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          shape: t == Types.drawOval
                                              ? BoxShape.circle
                                              : BoxShape.rectangle,
                                          border: Border.all(
                                            width: 2,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                if (selectedType == Types.drawLine)
                  Card(
                    child: Row(
                      children: <Widget>[
                        for (double r in [10, 20, 40])
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                radius = r;
                              });
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              child: Card(
                                elevation: r == radius ? 0 : 20,
                                child: Center(
                                  child: Container(
                                    width: r,
                                    height: r,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: colors[color],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  )
                else
                  Card(
                    child: Row(
                      children: <Widget>[
                        for (bool r in [false, true])
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                filled = r;
                              });
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              child: Card(
                                elevation: r == filled ? 0 : 20,
                                child: Center(
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: r
                                        ? BoxDecoration(
                                            shape:
                                                selectedType == Types.drawOval
                                                    ? BoxShape.circle
                                                    : BoxShape.rectangle,
                                            color: colors[color])
                                        : BoxDecoration(
                                            shape:
                                                selectedType == Types.drawOval
                                                    ? BoxShape.circle
                                                    : BoxShape.rectangle,
                                            border: Border.all(
                                                width: 2, color: colors[color]),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          if (bytes != null) Image.memory(Uint8List.view(bytes.buffer)),
        ],
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  List<Line> points;
  Canvas myCanvas;

  MyPainter({this.points, this.myCanvas});

  @override
  void paint(Canvas canvas, Size size) {
    for (var line in points) {
      switch (line.type) {
        case Types.drawLine:
          var deci = line.deci;
          var octo = line.octo;
          var penta = line.penta;
          // print('10: ${deci.length} 8: ${octo.length} 5: ${penta.length}');
          for (int i = 0; i < line.length - 1; i++) {
            // canvas.drawCircle(
            //     line.point(i), line.radius * 2, Paint()..color = Colors.blue);
            canvas.drawLine(
                line.point(i), line.point(i + 1), Paint()..color = Colors.blue);
          }
          for (int i = 0; i < deci.length - 1; i++) {
            // canvas.drawCircle(
            //     Offset(deci[i].dx * line.size, deci[i].dy * line.size),
            //     line.radius,
            //     Paint()..color = Colors.black);
            canvas.drawLine(
                Offset(
                    deci[i].dx * line.size / 100, deci[i].dy * line.size / 100),
                Offset(deci[i + 1].dx * line.size / 100,
                    deci[i + 1].dy * line.size / 100),
                Paint()..color = Colors.black);
          }
          for (int i = 0; i < octo.length - 1; i++) {
            // canvas.drawCircle(
            //     Offset(octo[i].dx * line.size, octo[i].dy * line.size),
            //     line.radius / 2,
            //     Paint()..color = Colors.red);
            canvas.drawLine(
                Offset(
                    octo[i].dx * line.size / 100, octo[i].dy * line.size / 100),
                Offset(octo[i + 1].dx * line.size / 100,
                    octo[i + 1].dy * line.size / 100),
                Paint()..color = Colors.red);
          }
          for (int i = 0; i < penta.length - 1; i++) {
            // canvas.drawCircle(
            //     Offset(penta[i].dx * line.size, penta[i].dy * line.size),
            //     line.radius / 3,
            //     Paint()..color = Colors.yellow);
            canvas.drawLine(
                Offset(penta[i].dx * line.size / 100,
                    penta[i].dy * line.size / 100),
                Offset(penta[i + 1].dx * line.size / 100,
                    penta[i + 1].dy * line.size / 100),
                Paint()..color = Colors.yellow);
          }
          break;
        case Types.drawRec:
          canvas.drawRect(
              Rect.fromPoints(line.point(0), line.point(-1)),
              Paint()
                ..color = line.color
                ..style =
                    line.filled ? PaintingStyle.fill : PaintingStyle.stroke);
          break;
        case Types.drawOval:
          canvas.drawCircle(
              line.point(0),
              distance(line.point(0), line.point(-1)),
              Paint()
                ..color = line.color
                ..style =
                    line.filled ? PaintingStyle.fill : PaintingStyle.stroke);
          break;
        default:
      }
    }
  }

  double distance(Offset c, Offset e) {
    return sqrt(pow(e.dx - c.dx, 2) + pow(e.dy - c.dy, 2));
  }

  @override
  bool shouldRepaint(MyPainter old) {
    return true;

    /// This is the better way to call the refresh,
    /// but it does not redraw until the one of the buttons is pressed
    // return old.points != points;
  }
}
