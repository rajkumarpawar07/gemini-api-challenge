import 'dart:io';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:gemini_api_challenge/core/constants/const.dart';

// TODO: Convert image user posts into files
String callGeminiAPIAnalyzeImage(
  String userMsg,
  List<File> files,
  Gemini gemini,
) {
  // Some default init params are available in the main.dart and const.dart file
  String question = userMsg;
  String resposne = "";
  question += initalStructurePromtImage;

  if (files.isNotEmpty) {
    // Text and image conversation
    List<Uint8List> imgs = files.map((e) => e.readAsBytesSync()).toList();
    gemini
        .textAndImage(
          text: question,
          images: imgs,
        )
        .then((value) => log(value?.content?.parts?.last.text ?? ''))
        .catchError((e) => log('textAndImageInput', error: e));
  } else {
    // Only text conservation
    gemini
        .text(question)
        .then((value) => log(value?.output ?? ""))

        /// or value?.content?.parts?.last.text
        .catchError((e) => log(e));
  }
  return resposne;
}
