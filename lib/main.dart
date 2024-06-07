import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:gemini_api_challenge/app/router.dart';
import 'package:gemini_api_challenge/core/constants/const.dart';
import 'package:gemini_api_challenge/core/services/gemini_screen.dart';

void main() {
  // Initialize the Gemini API using API key
  // API keys and some config is located in the const.dart file
  Gemini.init(
    apiKey: apiKey,
    generationConfig: GenerationConfig(
      temperature: temperatrue,
      topK: topK,
      topP: topP,
      maxOutputTokens: maxOutputTokens,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const GeminiScreen(), //TODO: Change this to MyHomePage again
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRouter.generateRoute);
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
