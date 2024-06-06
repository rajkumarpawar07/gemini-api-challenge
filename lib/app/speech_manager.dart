import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';

class TextToSpeechManager {
  final FlutterTts flutterTts = FlutterTts();

  final ValueNotifier<bool> speechState = ValueNotifier<bool>(false);

  bool get isRunning => speechState.value;

  void run(String content) async {
    try {
      speechState.value = true;
      flutterTts.awaitSpeakCompletion(true);
      await flutterTts.speak(content);
      speechState.value = false;
    } catch (e, stack) {
      log('error', error: e, stackTrace: stack);
    }
  }

  void stop() async {
    if (isRunning) {
      await flutterTts.stop();
      speechState.value = false;
    }
  }

  void dispose() {
    stop();
    speechState.dispose();
  }
}

class SpeechToTextManager {
  final SpeechToText speech = SpeechToText();

  final ValueNotifier<bool> speechState = ValueNotifier<bool>(false);

  bool get isRunning => speechState.value;

  Future<bool> _initialize() async {
    return speech.initialize(
      onStatus: (text) {
        if (text == 'listening') {
          speechState.value = true;
        } else {
          speechState.value = false;
        }
      },
      onError: (errorNotification) {
        log('error: $errorNotification');
        speechState.value = false;
      },
      debugLogging: true,
    );
  }

  void run(Function(String) onResult) async {
    final available = await _initialize();
    if (available) {
      speech.listen(
        onResult: (result) {
          onResult(result.recognizedWords);
        },
      );
    } else {
      log("The user has denied the use of speech recognition.");
    }
  }

  void stop() {
    speech.stop();
  }

  void dispose() {
    speech.stop();
    speechState.dispose();
  }
}
