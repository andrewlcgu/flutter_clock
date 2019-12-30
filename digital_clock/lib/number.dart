import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

class NumberWidget extends StatelessWidget {
  final Size size;
  final int number;
  final Color color;

  const NumberWidget(
      {Key key,
      @required this.number,
      this.size = Size.zero,
      this.color = const Color(0xFFFF0000)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        painter: _NumberPainter(number: number, color: color),
        size: size,
      ),
    );
  }
}

enum _PathLocation {
  top,
  leftTop,
  rightTop,
  leftBottom,
  rightBottom,
  center,
  bottom
}

class _NumberPainter extends CustomPainter {
  final int number;
  final double stokeWidth;
  final double interval;
  final Color color;

  var _displayPath = List<_PathLocation>();

  _NumberPainter(
      {@required this.number,
      this.stokeWidth: 14.0,
      this.interval: 2.0,
      @required this.color}) {
    assert(number >= 0 && number <= 9);
    switch (number) {
      case 0:
        _displayPath
          ..add(_PathLocation.top)
          ..add(_PathLocation.leftTop)
          ..add(_PathLocation.leftBottom)
          ..add(_PathLocation.bottom)
          ..add(_PathLocation.rightTop)
          ..add(_PathLocation.rightBottom);
        break;

      case 1:
        _displayPath
          ..add(_PathLocation.rightTop)
          ..add(_PathLocation.rightBottom);
        break;

      case 2:
        _displayPath
          ..add(_PathLocation.top)
          ..add(_PathLocation.rightTop)
          ..add(_PathLocation.center)
          ..add(_PathLocation.leftBottom)
          ..add(_PathLocation.bottom);
        break;

      case 3:
        _displayPath
          ..add(_PathLocation.top)
          ..add(_PathLocation.rightTop)
          ..add(_PathLocation.center)
          ..add(_PathLocation.rightBottom)
          ..add(_PathLocation.bottom);
        break;

      case 4:
        _displayPath
          ..add(_PathLocation.leftTop)
          ..add(_PathLocation.center)
          ..add(_PathLocation.rightTop)
          ..add(_PathLocation.rightBottom);
        break;

      case 5:
        _displayPath
          ..add(_PathLocation.top)
          ..add(_PathLocation.leftTop)
          ..add(_PathLocation.center)
          ..add(_PathLocation.rightBottom)
          ..add(_PathLocation.bottom);
        break;

      case 6:
        _displayPath
          ..add(_PathLocation.top)
          ..add(_PathLocation.leftTop)
          ..add(_PathLocation.center)
          ..add(_PathLocation.leftBottom)
          ..add(_PathLocation.bottom)
          ..add(_PathLocation.rightBottom);
        break;

      case 7:
        _displayPath
          ..add(_PathLocation.top)
          ..add(_PathLocation.rightTop)
          ..add(_PathLocation.rightBottom);
        break;

      case 8:
        _displayPath
          ..add(_PathLocation.top)
          ..add(_PathLocation.leftTop)
          ..add(_PathLocation.leftBottom)
          ..add(_PathLocation.center)
          ..add(_PathLocation.bottom)
          ..add(_PathLocation.rightTop)
          ..add(_PathLocation.rightBottom);
        break;

      case 9:
        _displayPath
          ..add(_PathLocation.top)
          ..add(_PathLocation.leftTop)
          ..add(_PathLocation.center)
          ..add(_PathLocation.bottom)
          ..add(_PathLocation.rightTop)
          ..add(_PathLocation.rightBottom);
        break;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    double _width = size.width;
    double _height = size.height;
    double _offset = stokeWidth / 2.0;

    var paint = Paint()
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    _displayPath.forEach((location) {
      switch (location) {
        case _PathLocation.top:
          var topOffsets = List<Offset>()
            ..add(Offset(stokeWidth, stokeWidth))
            ..add(Offset(_offset, _offset))
            ..add(Offset(stokeWidth, 0))
            ..add(Offset(_width - stokeWidth, 0))
            ..add(Offset(_width - _offset, _offset))
            ..add(Offset(_width - stokeWidth, stokeWidth));
          var topPath = Path()..addPolygon(topOffsets, true);
          canvas.drawPath(topPath, paint);
          break;
        case _PathLocation.leftTop:
          var leftTopOffsets = List<Offset>()
            ..add(Offset(_offset, _offset + interval))
            ..add(Offset(0, stokeWidth + interval))
            ..add(Offset(0, _height / 2 - _offset - interval))
            ..add(Offset(_offset, _height / 2 - interval))
            ..add(Offset(stokeWidth, _height / 2 - _offset - interval))
            ..add(Offset(stokeWidth, stokeWidth + interval));
          var leftTopPath = Path()..addPolygon(leftTopOffsets, true);
          canvas.drawPath(leftTopPath, paint);
          break;
        case _PathLocation.rightTop:
          var rightTopOffsets = List<Offset>()
            ..add(Offset(_width - _offset, _offset + interval))
            ..add(Offset(_width - stokeWidth, stokeWidth + interval))
            ..add(Offset(_width - stokeWidth, _height / 2 - _offset - interval))
            ..add(Offset(_width - _offset, _height / 2 - interval))
            ..add(Offset(_width, _height / 2 - _offset - interval))
            ..add(Offset(_width, stokeWidth + interval));
          var rightTopPath = Path()..addPolygon(rightTopOffsets, true);
          canvas.drawPath(rightTopPath, paint);
          break;
        case _PathLocation.leftBottom:
          var leftBottomOffsets = List<Offset>()
            ..add(Offset(_offset, _height / 2 + interval))
            ..add(Offset(0, _height / 2 + _offset + interval))
            ..add(Offset(0, _height - stokeWidth - interval))
            ..add(Offset(_offset, _height - _offset - interval))
            ..add(Offset(stokeWidth, _height - stokeWidth - interval))
            ..add(Offset(stokeWidth, _height / 2 + _offset + interval));
          var leftBottomPath = Path()..addPolygon(leftBottomOffsets, true);
          canvas.drawPath(leftBottomPath, paint);
          break;
        case _PathLocation.rightBottom:
          var rightBottomOffsets = List<Offset>()
            ..add(Offset(_width - _offset, _height / 2 + interval))
            ..add(Offset(_width - stokeWidth, _height / 2 + _offset + interval))
            ..add(Offset(_width - stokeWidth, _height - stokeWidth - interval))
            ..add(Offset(_width - _offset, _height - _offset - interval))
            ..add(Offset(_width, _height - stokeWidth - interval))
            ..add(Offset(_width, _height / 2 + _offset + interval));
          var rightBottomPath = Path()..addPolygon(rightBottomOffsets, true);
          canvas.drawPath(rightBottomPath, paint);
          break;
        case _PathLocation.center:
          var centerOffsets = List<Offset>()
            ..add(Offset(stokeWidth, _height / 2 + _offset))
            ..add(Offset(_offset, _height / 2))
            ..add(Offset(stokeWidth, _height / 2 - _offset))
            ..add(Offset(_width - stokeWidth, _height / 2 - _offset))
            ..add(Offset(_width - _offset, _height / 2))
            ..add(Offset(_width - stokeWidth, _height / 2 + _offset));
          var centerPath = Path()..addPolygon(centerOffsets, true);
          canvas.drawPath(centerPath, paint);
          break;
        case _PathLocation.bottom:
          var bottomOffsets = List<Offset>()
            ..add(Offset(stokeWidth, _height))
            ..add(Offset(_offset, _height - _offset))
            ..add(Offset(stokeWidth, _height - stokeWidth))
            ..add(Offset(_width - stokeWidth, _height - stokeWidth))
            ..add(Offset(_width - _offset, _height - _offset))
            ..add(Offset(_width - stokeWidth, _height));
          var bottomPath = Path()..addPolygon(bottomOffsets, true);
          canvas.drawPath(bottomPath, paint);
          break;
      }
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return (oldDelegate as _NumberPainter).number != number;
  }
}

class DotWidget extends StatelessWidget {
  final Size size;
  final Color color;

  const DotWidget(
      {Key key, this.size = Size.zero, this.color = const Color(0xFFFF0000)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        painter: _DotPainter(radius: 10, color: color),
        size: size,
      ),
    );
  }
}

class _DotPainter extends CustomPainter {
  final double radius;
  final double interval;
  final Color color;

  _DotPainter(
      {@required this.radius, this.interval = 20, @required this.color}) {
    assert(radius > 0);
  }

  @override
  void paint(Canvas canvas, Size size) {
    assert(size.width >= 2 * radius);
    assert(size.height >= interval + 4 * radius);
    var paint = Paint()
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..color = color
      ..style = PaintingStyle.fill;

    var _width = size.width;
    var _height = size.height;

    var topCenterOffset =
        Offset(_width / 2, _height / 2 - interval / 2 - radius);
    var bottomCenterOffset =
        topCenterOffset.translate(0, interval + 2 * radius);
    canvas.drawCircle(topCenterOffset, radius, paint);
    canvas.drawCircle(bottomCenterOffset, radius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
