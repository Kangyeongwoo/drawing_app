
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:painter_app/drawing_painter.dart';
import 'package:painter_app/model/DotInfo.dart';
import 'package:painter_app/controller/BackgroundController.dart';
import 'package:painter_app/controller/DrawingController2.dart';

class DrawingPage extends StatelessWidget {
  final _picker = ImagePicker();
  final LocalStorage storage = new LocalStorage('drawing_app');

  @override
  Widget build(BuildContext context) {
    DrawingController2 p = Get.find<DrawingController2>();
    BackGroudController b = Get.find<BackGroudController>();
    
    EdgeInsets safeAreaPadding =  MediaQuery.of(context).padding;
    double menuBarHeight = 70;
    Size screenSize = MediaQuery.of(context).size;
    double myCanvasHeight = screenSize.height-safeAreaPadding.top-safeAreaPadding.bottom-menuBarHeight;
    double buttonPaddingSzie = 5;
    double buttonHeight = 55;
    double buttonWidth = 55;
    double buttonTextSize = 10;
    Color menuBackgroundColor = Colors.grey[300];
    Color menuButtonBackgroundColor = Colors.grey[500];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
             //화면 상단 메뉴바
             Container(height:menuBarHeight,
                  color:menuBackgroundColor,
                  child:
                  Expanded(child:Row(
                    children: [

                      //save 버튼
                      Container(
                        padding:EdgeInsets.all(buttonPaddingSzie),
                        height: buttonHeight, width:buttonWidth,
                        child: ElevatedButton(
                          onPressed:() async {
                            List<dynamic> jsonData =p.lines.value.map((e){
                              return e.map((DotInfo v){
                                  return {
                                    "dx":v.offset.dx,
                                    "dy":v.offset.dy,
                                    "paint":v.paint.color==Colors.white.withOpacity(1)?"erase":"pen",
                                  };
                                }).toList();
                            }).toList();
                            String jsonDataString = json.encode(jsonData);
                            storage.setItem('saveData',jsonDataString);
                          },
                          style:new ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(menuButtonBackgroundColor),
                                  padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.all(0))),
                          child:Text("SAVE",style: TextStyle(fontSize: buttonTextSize),))
                      ),
                      
                      //load버튼
                      Container(
                        padding:EdgeInsets.all(buttonPaddingSzie),
                        height: buttonHeight, width:buttonWidth,
                        child: ElevatedButton(
                          onPressed:(){
                               List<dynamic> result = json.decode(storage.getItem('saveData'));
                               p.loadData(result);
                          },
                          style:new ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(menuButtonBackgroundColor),
                                  padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.all(0))),
                          child:Text("LOAD",style: TextStyle(fontSize: buttonTextSize),))
                      ), 
                      Spacer(),
                      //add 버튼
                      Container(
                        padding:EdgeInsets.all(buttonPaddingSzie),
                        height: buttonHeight, width:buttonWidth,
                        child: ElevatedButton(
                          onPressed:() async {
                            _picker.getImage(source: ImageSource.gallery).then((pickedFile){
                                b.backGroundSelect(pickedFile.path);
                                }
                            );
                          },
                          style:new ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(menuButtonBackgroundColor),
                                  padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.all(0))),
                          child:Text("ADD",style: TextStyle(fontSize: buttonTextSize),))
                      ),           
                      Spacer(),
                      //undo 버튼
                      Container(
                        padding:EdgeInsets.all(buttonPaddingSzie),
                        height: buttonHeight, width:buttonWidth,
                        child: ElevatedButton(
                          onPressed:() {
                            p.undo();
                          },
                          style:new ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(menuButtonBackgroundColor),
                                  padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.all(0))),
                          child:Icon(Icons.undo))
                      ),  
                      
                      //redo 버튼
                      Container(
                        padding:EdgeInsets.all(buttonPaddingSzie),
                        height: buttonHeight, width:buttonWidth,
                        child: ElevatedButton(
                          onPressed:() {
                             p.redo();
                          },
                        style:new ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(menuButtonBackgroundColor),
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.all(0))),
                        child:Icon(Icons.redo))
                      ),      
                      Spacer(),
                      //pen버튼
                      Container(
                        padding:EdgeInsets.all(buttonPaddingSzie),
                        height: buttonHeight, width:buttonWidth,
                        child: ElevatedButton(
                          onPressed:(){
                            p.erase=false;
                          },
                          style:new ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(menuButtonBackgroundColor),
                                  padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.all(0))),
                          child:Text("PEN",style: TextStyle(fontSize: buttonTextSize),))
                      ),

                      //erase 버튼
                      Container(
                        padding:EdgeInsets.all(buttonPaddingSzie),
                        height: buttonHeight, width:buttonWidth,
                        child: ElevatedButton(
                          onPressed:(){
                            p.erase=true;
                          },
                          style:new ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(menuButtonBackgroundColor),
                                  padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.all(0))),
                          child:Text("ERASE",style: TextStyle(fontSize: buttonTextSize),))
                      ),
                    ]  
                  ))
                  ),
            //그림판 영역      
            RepaintBoundary(
              child: Stack(
                  children: [
                    //그림판 뒤 배경
                    Container(
                      height:myCanvasHeight,
                      color:Colors.white,
                      child:Obx((){
                        if(b.imagePath.value==""){
                          return Container();
                        }else{
                          File image = File(b.imagePath.value);
                          return Image.file(image);
                        }
                      }),
                    ),
                    //그림이 그려지는 부분 
                    Positioned.fill(
                      child: Container(
                        color:Colors.transparent,
                        child: GestureDetector(
                        child: Obx(()=>CustomPaint(
                          // ignore: invalid_use_of_protected_member
                          painter: 
                          DrawingPainter(p.lines.value)
                        )),
                        onPanStart: (s) {
                          Offset pos = s.localPosition;
                          p.add(pos);
                        },
                        onPanUpdate: (s) {
                          Offset pos = s.localPosition;
                          p.updateCurrent(pos);
                        },
                        onPanEnd: (s) {
                        },
                    ),
                      ))
                  ],
                ),)
          ],
        ),
      ),
    );
  }
}




