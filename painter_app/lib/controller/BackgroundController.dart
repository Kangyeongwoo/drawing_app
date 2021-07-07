

import 'package:get/get.dart';

class BackGroudController extends GetxController{
  
  RxBool backGroundImageExist ;
  RxString imagePath;

  @override
  onInit(){
    backGroundImageExist = false.obs;
    imagePath = "".obs;
    super.onInit();
  }

  backGroundSelect(String filePath){
    backGroundImageExist.value=true;
    imagePath.value = filePath;
  }

}