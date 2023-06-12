import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


pickImage(ImageSource imageSource)async{
  final ImagePicker _imagePicker=ImagePicker();

  XFile? xFile=await _imagePicker.pickImage(source: imageSource);

  if(xFile!=null){
    return await xFile.readAsBytes();
  }
  print('No Image Selected');
}