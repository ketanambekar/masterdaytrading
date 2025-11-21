import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui_web' as ui;
import 'dart:html' as html;
import 'package:webview_flutter/webview_flutter.dart';

class ChartController extends GetxController {
  WebViewController? mobileController;
  html.IFrameElement? iframe;

  final String viewId = "chart-iframe-view";

  @override
  void onInit() {
    super.onInit();

    if (GetPlatform.isWeb) {
      ui.platformViewRegistry.registerViewFactory(viewId, (int id) {
        iframe = html.IFrameElement()
          ..src = "assets/html/realtime_chart.html"
          ..style.border = 'none'
          ..width = '100%'
          ..height = '100%';
        return iframe!;
      });
    } else {
      mobileController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadFlutterAsset('assets/html/realtime_chart.html');
    }
  }

  // -----------------------
  // JS COMMUNICATION LAYER
  // -----------------------
  void _sendWeb(Map<String, dynamic> msg) {
    iframe?.contentWindow?.postMessage(msg, "*");
  }

  Future<void> _runMobileJS(String js) async {
    await mobileController?.runJavaScript(js);
  }

  void _send(String js, Map<String, dynamic> msg) {
    if (GetPlatform.isWeb) {
      _sendWeb(msg);
    } else {
      _runMobileJS(js);
    }
  }

  // -------- API exposed to Flutter --------
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
    _send("setReplaySpeed($ms);", {
      "type": "setReplaySpeed",
      "ms": ms,
    });
  }
}
