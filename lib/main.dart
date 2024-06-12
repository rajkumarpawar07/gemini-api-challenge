import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gemini_api_challenge/app/speech_manager.dart';
import 'package:gemini_api_challenge/features/chatbot/presentation/chat_screen.dart';
import 'package:google_fonts/google_fonts.dart';

import 'shared/components/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
    ));
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: AppTheme.colorScheme(),
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(),
        inputDecorationTheme: InputDecorationTheme(
          border: AppTheme.chatInputBorder(),
          disabledBorder: AppTheme.chatInputBorder(),
          enabledBorder: AppTheme.chatInputBorder(),
          errorBorder: AppTheme.chatInputBorder(),
          focusedBorder: AppTheme.chatInputBorder(),
          focusedErrorBorder: AppTheme.chatInputBorder(),
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextToSpeechManager textManager = TextToSpeechManager();
  final SpeechToTextManager speechManager = SpeechToTextManager();
  String? content;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Text(
              'Text To Speech',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            ValueListenableBuilder<bool>(
              valueListenable: textManager.speechState,
              builder: (context, value, child) {
                return Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        if (!value) {
                          textManager.run(content ??
                              'This sunbird has an injury on its leg. It requires care from a hospital.');
                        } else {
                          textManager.stop();
                        }
                      },
                      child: Text(
                        !value ? 'Play' : 'Pause',
                      ),
                    ),
                    Text('Play State: $value'),
                  ],
                );
              },
            ),
            const Spacer(),
            Text(
              'Speech To Text',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            ValueListenableBuilder<bool>(
                valueListenable: speechManager.speechState,
                builder: (context, value, child) {
                  return Column(
                    children: [
                      TextButton(
                        onPressed: () {
                          if (speechManager.isRunning) {
                            return speechManager.stop();
                          }
                          speechManager.run(
                            (text) {
                              setState(() {
                                content = text;
                              });
                            },
                          );
                        },
                        child: Text(!value ? 'Listen' : 'Stop'),
                      ),
                      Text('Speech: $content'),
                    ],
                  );
                }),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChatScreen(),
                  ),
                );
              },
              child: const Text(
                'ChatBot',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
