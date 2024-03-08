import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
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
  double interBit = 0;

  late AdManager adManager;
  late final WebViewController _controller;
  late final PlatformWebViewControllerCreationParams params;

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    _packageInfo = info;
    _controller.setUserAgent(_packageInfo.packageName);
  }

  @override
  void initState() {
    super.initState();
    String res = configs['res'] ?? "";
    String url = "https://roy4d.com/$res";
    adManager = AdManager(context);
    _initPackageInfo();

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
            interBit++;
            if (interBit % 3 > 0) adManager.showInter();
            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel('Toaster',
          onMessageReceived: (JavaScriptMessage message) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message.message)),
        );
      })
      ..loadRequest(Uri.parse(url));

    if (Platform.isAndroid) {
      final myAndroidController =
          controller.platform as AndroidWebViewController;
      myAndroidController
        ..setMediaPlaybackRequiresUserGesture(false)
        ..setGeolocationPermissionsPromptCallbacks(
          onShowPrompt: (request) async {
            request.origin;
            return const GeolocationPermissionsResponse(
                allow: true, retain: true);
          },
          onHidePrompt: () {
            // hide related ui
          },
        );
      myAndroidController.setOnShowFileSelector((params) async {
        debugPrint(params.acceptTypes.toString());
        FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: params.acceptTypes,
            allowCompression: true,
            lockParentWindow: true,
            allowMultiple:
                params.mode == FileSelectorMode.openMultiple ? true : false);

        List<String> files = [];
        if (result != null) {
          if (result.isSinglePick) {
            files.add(result.files.single.path!);
          } else {
            if (result.paths.isNotEmpty) {
              result.paths.every((path) {
                if (path == null || path.isEmpty) return false;
                files.add(path);
                return true;
              });
            }
          }
        } else {
          files.add("");
        }
        return files; // Uris
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
        if (didPop) return;
        if (await _controller.canGoBack()) {
          _controller.goBack();
        } else {
          Navigator.pop(context);
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
