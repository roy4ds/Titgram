import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:titgram/ads/admob/admanager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

late String channelLink;

class ChannelView extends StatefulWidget {
  ChannelView({super.key, required String clink}) {
    channelLink = clink;
  }

  @override
  State<ChannelView> createState() => _ChannelViewState();
}

class _ChannelViewState extends State<ChannelView> {
  var loadingPercentage = 0;
  double interBit = 0;
  late String url;
  late AdManager adManager;
  late final WebViewController _controller;
  late final PlatformWebViewControllerCreationParams params;

  showSnack(String sms) {
    try {
      ScaffoldMessenger.maybeOf(context)
          ?.showSnackBar(SnackBar(content: Text(sms)));
    } catch (e) {
      debugPrint(e.toString());
    }
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

  @override
  void initState() {
    super.initState();
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
            if (!request.url.startsWith('https://')) {
              launchUrlScheme(request.url);
              return NavigationDecision.prevent;
            }
            interBit++;
            if (interBit % 3 > 0) adManager.showInter();
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(channelLink));

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
        bottomNavigationBar: adManager.insertBanner(),
      ),
    );
  }
}
