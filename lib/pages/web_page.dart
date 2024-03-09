import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:titgram/ads/admob/admanager.dart';
import 'package:url_launcher/url_launcher.dart';
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
  late String url;
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

  showSnack(String sms) {
    ScaffoldMessenger.maybeOf(context)
        ?.showSnackBar(SnackBar(content: Text(sms)));
  }

  Future<void> launchUrlScheme(String url) async {
    try {
      if (!await launchUrl(Uri.parse(url))) {
        throw Exception('Could not launch $url');
      }
    } on FormatException catch (e) {
      showSnack(e.message);
    } catch (e) {
      showSnack(e.toString());
    }
  }

  FileType getFileType(FileSelectorParams params) {
    if (params.acceptTypes.isEmpty) {
      return FileType.any;
    }
    List b = [];
    for (var acpt in params.acceptTypes) {
      b.add(acpt.split('/')[0]);
    }
    switch (b[0]) {
      case 'audio':
        return FileType.audio;

      case 'image':
        return FileType.image;

      case 'video':
        return FileType.video;

      default:
        return FileType.media;
    }
  }

  @override
  void initState() {
    super.initState();
    adManager = AdManager(context);
    _initPackageInfo();

    String res = configs['res'] ?? "";
    url = res.startsWith('https://') ? res : "https://roy4d.com/$res";

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
            if (!request.url.startsWith('https://')) {
              launchUrlScheme(request.url);
              return NavigationDecision.prevent;
            }
            interBit++;
            if (interBit % 3 == 0) adManager.showInter();
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
        ..setOnPlatformPermissionRequest((request) {
          request.grant();
        })
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
        FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: getFileType(params),
            allowCompression: true,
            lockParentWindow: true,
            allowMultiple:
                params.mode == FileSelectorMode.openMultiple ? true : false);

        List<String> files = [];
        if (result == null) return [""];
        if (result.isSinglePick) {
          File file = File(result.files.single.path!);
          files.add(file.uri.toString());
        } else {
          for (var path in result.paths) {
            files.add(File(path!).uri.toString());
          }
        }
        return files;
      });
    }
    _controller = controller;
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
