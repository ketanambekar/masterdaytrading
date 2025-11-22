import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:html' as html;               // only used on web
import 'dart:ui_web' as ui;                 // only used on web
import 'package:flutter/foundation.dart'; // for kIsWeb

class ChartController extends GetxController {
  WebViewController? mobileController;
  html.IFrameElement? iframe;
  final TextEditingController fromCtrl = TextEditingController();
  final TextEditingController toCtrl = TextEditingController();
  final String viewId = "chart-iframe-view";

  @override
  void onInit() {
    super.onInit();

    // Register view factory for web
    if (kIsWeb) {
      ui.platformViewRegistry.registerViewFactory(viewId, (int id) {
        iframe = html.IFrameElement()
          ..src = "assets/html/realtime_chart.html"
          ..style.border = 'none'
          ..width = '100%'
          ..height = '100%';
        return iframe!;
      });
    } else {
      // mobile controller: ensure you have webview_flutter configured in android/ios
      mobileController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadFlutterAsset('assets/html/realtime_chart.html');
    }
  }

  // low-level senders
  void _postMessage(Map<String, dynamic> msg) {
    try {
      iframe?.contentWindow?.postMessage(msg, "*");
    } catch (_) {}
  }

  Future<void> _runMobileJs(String js) async {
    try {
      await mobileController?.runJavaScript(js);
    } catch (_) {}
  }

  void _send(String js, Map<String, dynamic> msg) {
    if (kIsWeb) _postMessage(msg);
    else _runMobileJs(js);
  }

  // Public API to Flutter UI

  /// Expects the data already converted such that `time` is UNIX seconds (int).
  void sendData(List<Map<String, dynamic>> data) {
    final jsonString = jsonEncode(data);
    _send("addDataFromJson($jsonString);", {
      "type": "addData",
      "data": data,
    });
  }

  void setStartDate(String date) {
    _send("setStartDate('$date');", {
      "type": "setStartDate",
      "date": date,
    });
  }

  void startReplay() {
    _send("startReplay();", {"type": "startReplay"});
  }

  void pauseReplay() {
    _send("pauseReplay();", {"type": "pauseReplay"});
  }

  void stopReplay() {
    _send("stopReplay();", {"type": "stopReplay"});
  }

  void setSpeed(int ms) {
    _send("setReplaySpeed($ms);", {"type": "setReplaySpeed", "ms": ms});
  }

  /// indicator types: "sma20", "ema50", "rsi14", "vwap", "bb20" etc.
  void addIndicator(String type) {
    if (kIsWeb) {
      _postMessage({"type": "addIndicator", "indicator": type});
    } else {
      _runMobileJs("addIndicator('$type');");
    }
  }

  void removeIndicator(String type) {
    if (kIsWeb) {
      _postMessage({"type": "removeIndicator", "indicator": type});
    } else {
      _runMobileJs("removeIndicator('$type');");
    }
  }
}
