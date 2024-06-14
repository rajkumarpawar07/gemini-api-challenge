import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gemini_api_challenge/core/utils/app_extensions.dart';
import 'package:gemini_api_challenge/features/chatbot/presentation/chat_screen.dart';
import 'package:gemini_api_challenge/shared/components/gapbox.dart';
import 'package:gemini_api_challenge/shared/utils/permission_handler.dart';
import 'package:gemini_api_challenge/shared/widgets/loading_widget.dart';
import 'dart:math' as math;

enum CameraState { initial, permissionPending, cameraReady }

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final _cameraKey = GlobalKey<_CameraWidgetState>();

  bool _capturingImage = false;

  void _onCapture() async {
    if (_capturingImage) return;
    if (mounted) setState(() => _capturingImage = true);
    final image = await _cameraKey.currentState!.takePicture();
    if (mounted) setState(() => _capturingImage = false);
    if (image != null && mounted) {
      //TODO: Add Image to chat query
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ChatScreen(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CameraWidget(key: _cameraKey),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black87,
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: _onCapture,
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(16),
                        child: _capturingImage
                            ? const LoadingWidget()
                            : Image.asset(
                                'assets/images/ic_gemini_icon.png',
                              ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const ChatScreen()));
                            },
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Container(
                                  padding: Dimens.horizontalPadding,
                                  child: Image.asset(
                                    'assets/images/ic_chat.png',
                                    width: 100,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xffE3CCF4),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 2),
                                  child: const Text('AI Chat'),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              //TODO: Add implementation
                            },
                            child: Container(
                              padding: Dimens.horizontalPadding,
                              child: Image.asset(
                                'assets/images/ic_bird.png',
                                width: 100,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CameraWidget extends StatefulWidget {
  const CameraWidget({super.key});

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget>
    with WidgetsBindingObserver {
  late List<CameraDescription> _cameras;
  CameraController? _controller;
  CameraState _cameraState = CameraState.initial;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    _disposeCamera();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        _disposeCamera();
        break;
      case AppLifecycleState.resumed:
        _initCamera();
        break;
      default:
        break;
    }
  }

  void _initCamera({bool request = false}) async {
    if (_cameraState == CameraState.cameraReady) return;
    try {
      _cameraState = CameraState.initial;
      if (mounted) setState(() {});
      final permission = request
          ? await PermissionHandler().requestCamera()
          : await PermissionHandler().checkCamera();
      if (!permission) {
        _cameraState = CameraState.permissionPending;
        if (mounted) setState(() {});
        return;
      }
      _cameras = await availableCameras();
      _controller = CameraController(_cameras[0], ResolutionPreset.max,enableAudio: false);
      await _controller?.initialize().then((_) {
        _cameraState = CameraState.cameraReady;
        if (mounted) setState(() {});
      });
    } catch (e) {
      log('message', error: e);
    }
  }

  void _disposeCamera() {
    if (_cameraState == CameraState.cameraReady) {
      _controller?.dispose();
      _cameraState = CameraState.initial;
      if (mounted) setState(() {});
    }
  }

  void _getPermission() => _initCamera(request: true);

  Future<String?> takePicture() async {
    if (_cameraState == CameraState.cameraReady) {
      final image = await _controller!.takePicture();
      return image.path;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    switch (_cameraState) {
      case CameraState.initial:
        return const LoadingWidget();
      case CameraState.permissionPending:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Camera Permission not granted',
                style: context.textTheme.bodyLarge,
              ),
              const GapBox(gap: Gap.xxs),
              ElevatedButton(
                onPressed: _getPermission,
                child:
                    Text('Grant Access', style: context.textTheme.bodyMedium),
              ),
            ],
          ),
        );
      case CameraState.cameraReady:
        var tmp = MediaQuery.of(context).size;
        final screenH = math.max(tmp.height, tmp.width);
        final screenW = math.min(tmp.height, tmp.width);
        tmp = _controller!.value.previewSize!;
        final previewH = math.max(tmp.height, tmp.width);
        final previewW = math.min(tmp.height, tmp.width);
        final screenRatio = screenH / screenW;
        final previewRatio = previewH / previewW;
        return OverflowBox(
          maxHeight: screenRatio > previewRatio
              ? screenH
              : screenW / previewW * previewH,
          maxWidth: screenRatio > previewRatio
              ? screenH / previewH * previewW
              : screenW,
          child: CameraPreview(
            _controller!,
          ),
        );
    }
  }
}
