import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:titgram/ads/admob/admanager.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

late Map<String, dynamic> configs;

class WebPage extends StatefulWidget {
  WebPage({super.key, required Map<String, dynamic> config}) {
    configs = config;
  }

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  var loadingPercentage = 0;

  late AdManager adManager;
  late final WebViewController _controller;
  late final PlatformWebViewControllerCreationParams params;

  @override
  void initState() {
    super.initState();
    String res = configs['res'] ?? "";
    String url = "https://roy4d.com/$res";
    adManager = AdManager(context);

    params = const PlatformWebViewControllerCreationParams();
    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              loadingPercentage = 0;
            });
          },
          onProgress: (int progress) {
            setState(() {
              loadingPercentage = progress;
            });
          },
          onPageFinished: (url) {
            setState(() {
              loadingPercentage = 100;
            });
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
								Page resource error:
								code: ${error.errorCode}
								description: ${error.description}
								errorType: ${error.errorType}
								isForMainFrame: ${error.isForMainFrame}
							''');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            adManager.showInter();
            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse(url));

    if (Platform.isAndroid) {
      final myAndroidController =
          controller.platform as AndroidWebViewController;
      myAndroidController.setMediaPlaybackRequiresUserGesture(false);
      myAndroidController.setOnShowFileSelector((params) async {
        FilePickerResult? result = await FilePicker.platform.pickFiles();
        String file;
        if (result != null) {
          file = result.files.single.path!;
        } else {
          file = "";
        }
        return [file]; // Uris
      });
    }
    _controller = controller;
  }

  Future<List<String>> selectMultipleFiles() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    List<String> files = [];
    if (result != null) {
      // files.addAll((result.paths).toList());
    } else {
      files.add("");
    }
    return files;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        debugPrint(didPop.toString());
        if (!didPop) return;
        if (await _controller.canGoBack()) {
          _controller.goBack();
        } else {
          // Navigator.pop(context);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: WebViewWidget(
                  controller: _controller,
                ),
              ),
              if (loadingPercentage < 100)
                LinearProgressIndicator(
                  value: loadingPercentage / 100.0,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
