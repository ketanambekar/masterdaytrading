// ignore_for_file: avoid_web_libraries_in_flutter, undefined_prefixed_name

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Web-only imports
// ignore: conditional_uri_does_not_exist
import 'dart:html' as html show IFrameElement;
import 'dart:ui_web' as ui; // ✅ this fixes platformViewRegistry undefined error

import 'chart_controller.dart';

class ChartPage extends StatelessWidget {
  const ChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChartController());

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Realtime Chart', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: kIsWeb ? _buildWebChart(controller) : _buildMobileChart(controller),
    );
  }

  /// ✅ Mobile (Android/iOS)
  Widget _buildMobileChart(ChartController controller) {
    return WebViewWidget(
      controller: WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadHtmlString(_chartHTML('hi')),
    );
  }

  /// ✅ Web
  Widget _buildWebChart(ChartController controller) {
    final viewId = 'chart-view-${DateTime.now().millisecondsSinceEpoch}';

    // register iframe view only for web
    ui.platformViewRegistry.registerViewFactory(viewId, (int _) {
      final iframe = html.IFrameElement()
        ..width = '100%'
        ..height = '100%'
        ..style.border = 'none'
        ..srcdoc = _chartHTML('hi');
      return iframe;
    });

    return HtmlElementView(viewType: viewId);
  }

  /// ✅ Lightweight Charts HTML
  String _chartHTML(String symbol) {
    return '''
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8" />
    <script src="https://unpkg.com/lightweight-charts/dist/lightweight-charts.standalone.production.js"></script>
    <style>
      html, body {
        margin: 0;
        padding: 0;
        background: #000;
        height: 100%;
        overflow: hidden;
      }
      #chart {
        height: 100%;
      }
    </style>
  </head>
  <body>
    <div id="chart"></div>
    <script>
      const chart = LightweightCharts.createChart(document.getElementById('chart'), {
        layout: { background: { color: '#000000' }, textColor: '#FFFFFF' },
        grid: { vertLines: { color: '#222' }, horzLines: { color: '#222' } },
        crosshair: { mode: LightweightCharts.CrosshairMode.Normal },
        timeScale: { borderColor: '#71649C' },
      });

      const candleSeries = chart.addCandlestickSeries({
        upColor: '#00FF00',
        downColor: '#FF3333',
        borderDownColor: '#FF3333',
        borderUpColor: '#00FF00',
        wickDownColor: '#FF3333',
        wickUpColor: '#00FF00',
      });

      candleSeries.setData([
        { time: '2025-11-01', open: 80, high: 96, low: 75, close: 90 },
        { time: '2025-11-02', open: 90, high: 105, low: 85, close: 95 },
        { time: '2025-11-03', open: 95, high: 120, low: 90, close: 110 },
      ]);

      let lastClose = 110;
      setInterval(() => {
        lastClose += (Math.random() - 0.5) * 5;
        const lastTime = Date.now() / 1000;
        candleSeries.update({
          time: Math.floor(lastTime),
          open: lastClose - 2,
          high: lastClose + 2,
          low: lastClose - 4,
          close: lastClose,
        });
      }, 2000);
    </script>
  </body>
</html>
    ''';
  }
}
