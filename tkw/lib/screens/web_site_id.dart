// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebView extends StatefulWidget {
  final int id;

  const WebView({super.key, required this.id});

  @override
  _MyWebViewState createState() => _MyWebViewState();
}

class _MyWebViewState extends State<WebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..loadRequest(Uri.parse('https://gepa.enerji.gov.tr/pages/${widget.id}.aspx'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: WebViewWidget(controller: _controller),
    );
  }
}
