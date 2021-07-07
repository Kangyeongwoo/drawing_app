import 'package:flutter/material.dart';
import 'package:painter_app/model/DotInfo.dart';

class DrawingPainter extends CustomPainter{
   DrawingPainter(this.lines);
   List<List<DotInfo>> lines;

  @override
  void paint(Canvas canvas, Size size) {
      canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());
      for(var oneLine in lines){
        var l = <Offset>[];
        var p = Path();
        for(DotInfo oneDot in oneLine){
          l.add(oneDot.offset);
        }
        p.addPolygon(l, false);
        canvas.drawPath(p, oneLine.first.paint);
      }
      canvas.restore();
  }



  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

}