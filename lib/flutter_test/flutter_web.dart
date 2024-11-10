import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FlutterWebView extends StatefulWidget {
  const FlutterWebView({super.key});

  @override
  State<FlutterWebView> createState() => _FlutterWebViewState();
}

class _FlutterWebViewState extends State<FlutterWebView> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // This resolves the issue of using HTTP
      ..loadRequest(
        // Uri.parse('https://flutter.dev'),
        // Uri.parse('https://raquelpawnshop.com/'),

        Uri.parse('http://122.54.197.116:2110/#/dashboard'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter WebView'),
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
