import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:gemini_api_challenge/core/services/gemini_api_image.dart';

// Some new package installed is: Flutter_gemini,
// https://pub.dev/packages/flutter_gemini#getting-started
// This screen is mostly for testing, the result from Gemini API will be available in debug console

class GeminiScreen extends StatefulWidget {
  const GeminiScreen({super.key});

  @override
  State<GeminiScreen> createState() => _GeminiScreenState();
}

class _GeminiScreenState extends State<GeminiScreen> {
  final Gemini gemini = Gemini.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Gemini API calling')),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(onPressed: _sendMsg, child: const Text("Generate Content")),
          ],
        ),
      ),
    );
  }

  void _sendMsg() {
    List<File> files = [];
    // TODO: Handle what to do with the response from Gemini
    // Note that the response is in JSON format
    String response = callGeminiAPIAnalyzeImage("Hello there", files, gemini);
  }
}
