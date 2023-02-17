import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

//signup login toggle
final loginProvider = StateNotifierProvider<CommonProvider, bool>((ref) => CommonProvider(true));

class CommonProvider extends StateNotifier<bool>{
  CommonProvider(super.state);

  void toggle(){
    state = !state;
  }
}


//image picker
final imageProvider =StateNotifierProvider<ImageProvider, XFile?>((ref) => ImageProvider(null));

class ImageProvider extends StateNotifier<XFile?>{
  ImageProvider(super.state);

  void imagePick(bool isCamera) async{
    final ImagePicker _picker = ImagePicker();
    if(isCamera){
      state = await _picker.pickImage(source: ImageSource.camera);
    }else{
      state = await _picker.pickVideo(source: ImageSource.gallery);
    }

  }
}