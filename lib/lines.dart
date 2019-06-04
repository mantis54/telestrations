import 'dart:math';

import 'package:flutter_web_ui/ui.dart';

enum Types { drawLine, drawRec, drawOval }

class Line {
  List<Offset> points;
  List<Offset> deci;
  List<Offset> octo;
  List<Offset> penta;
  Color color;
  double size;
  double radius;
  Types type;
  bool filled = false;

  Line(Types type, Offset point, Color color, double size, radius) {
    this.type = type;
    this.color = color;
    this.points = [point];
    this.deci = [point];
    this.octo = [point];
    this.penta = [point];
    this.radius = radius;
    this.size = size;
  }

  void fill(bool fi) {
    filled = fi;
  }

  Offset point(int index) {
    if (index == -1) {
      return Offset(points.last.dx * size / 100, points.last.dy * size / 100);
    }
    return Offset(points[index].dx * size / 100, points[index].dy * size / 100);
  }

  void add(Offset offset) {
    points.add(offset);
    print(points.length);
    if (points.length % 10 == 0) {
      deci.add(offset);
      print('added to deci');
    }
    if (points.length % 8 == 0) {
      octo.add(offset);
      print('added to octo');
    }
    if (points.length % 5 == 0) {
      penta.add(offset);
      print('added to penta');
    }
    print('${points.length} ${deci.length} ${octo.length} ${penta.length}');
  }

  void other(Offset offset) {
    if (points.length == 1) {
      points.add(offset);
    } else {
      points[1] = offset;
    }
  }

  List<Offset> simplified() {
    var list = []..addAll(points);
    var dmax = 0;
    var index = 0;
    var end = list.last;

    // for(var i = 2; i < list.length - 1; i++){
    //   d = dist(list[i], list[1])
    // }
  }

  List<Offset> decimate(int split) {
    var list = <Offset>[];
    for (int i = 0; i < points.length; i++) {
      if (i % split == 0) {
        list.add(points[i]);
      }
    }
    return list;
  }

  double dist(Offset a, Offset b) {
    return sqrt(pow(a.dx - b.dx, 2) + pow(a.dy - b.dy, 2));
  }

  int get length => points.length;
}

MyCurve() {
  Point point;
  // MyCurve(this.point);
  MyCurve(Offset offset) {
    point = Point(offset.dx, offset.dy);
  }

  void rot(int n, bool rx, bool ry) {
    if (!ry) {
      // int x = point.x;
      // int y = point.y;
      // if (rx) {
      //   x = (n - 1) - x;
      //   y = (n - 1) - y;
      // }
      // point = Point(x, y);
    }
  }

  Point fromD(int n, int d) {
    var p = Point(0, 0);
    bool rx, ry;
    int t = d;
    // for(int s = 1; s < n; s <<= 1) {
    //   rx = ((t & 2) != 0);
    //   ry = (((t ^ (rx ? 1 : 0)) & 1) != 0);
    //   p.rot(s, rx, ry);
    //         p.x += (rx ? s : 0);
    //         p.y += (ry ? s : 0);
    //         t >>>= 2;
    // }
  }
}
