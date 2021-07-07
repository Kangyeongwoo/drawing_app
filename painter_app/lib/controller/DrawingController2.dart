

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:painter_app/model/DotInfo.dart';

class DrawingController2 extends GetxController{

  RxList lines = <List<DotInfo>>[].obs;
  List<List<DotInfo>> undone = <List<DotInfo>>[];
  Paint currentPaint;
  Paint paint = Paint();
  Paint eraser = Paint();
  bool _erase = false;
  
   @override
  onInit(){
    paint.color = Colors.black;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1.0;
    
    eraser.color = Colors.white.withOpacity(1);
    eraser.style = PaintingStyle.stroke;
    eraser.strokeWidth = 10;
    eraser.blendMode = BlendMode.clear;

    currentPaint = paint;
    super.onInit();
  }
  
  bool canUndo() => lines.length > 0;
  
  void undo() {
    if (canUndo()) {
      undone.add(lines.removeLast());
    }
  }

  bool canRedo() => undone.length > 0;

  void redo() {
    if (canRedo()) {
      lines.add(undone.removeLast());
    }
  }

  bool get erase => _erase;
  set erase(bool e) {
    //_erase = e;
    if(e){
      currentPaint = eraser;
    }else{
      currentPaint = paint;
    }
  }

  void add(Offset offset){
    var oneLine = <DotInfo>[];
    oneLine.add(DotInfo(offset, currentPaint));
    lines.add(oneLine);
  }

  void updateCurrent(Offset offset){
    var oneLine =lines.last;
    oneLine.add(DotInfo(offset, currentPaint));
    lines.last=oneLine;
  }
  
  void loadData(List<dynamic> ld){
      ld.forEach((e) {
        var oneLine = <DotInfo>[];
        e as List<dynamic>;
        e.forEach((v){
         oneLine.add(DotInfo(new Offset(v['dx'],v['dy']), (v['paint']=="pen")? paint: eraser));
        });
        lines.add(oneLine);
      });
  }
}