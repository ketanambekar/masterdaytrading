import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterdaytrading/services/api_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'chart_controller.dart';

class ChartPage extends StatelessWidget {
  ChartPage({super.key});

  final chart = Get.put(ChartController());
  final api = Get.put(ApiController());

  @override
  Widget build(BuildContext context) {
    // Fetch default 1-day data on load
    Future.delayed(Duration(milliseconds: 300), () {
      if (!api.loadedOnce) {
        api.loadedOnce = true;
        api.setDefault1Day();
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xff0d0d0f),
      appBar: AppBar(
        backgroundColor: const Color(0xff111113),
        title: const Text("Candle Replay", style: TextStyle(color: Colors.white)),
      ),

      body: Column(
        children: [
          Expanded(
            child: GetBuilder<ChartController>(
              builder: (_) {
                if (GetPlatform.isWeb) {
                  return HtmlElementView(viewType: chart.viewId);
                } else {
                  return WebViewWidget(controller: chart.mobileController!);
                }
              },
            ),
          ),

          _bottomPanel(context),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // BEAUTIFUL TRADINGVIEW-LIKE BOTTOM PANEL
  // ---------------------------------------------------------
  Widget _bottomPanel(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Color(0xff1a1a1d),
        border: Border(top: BorderSide(color: Colors.white12, width: 0.5)),
      ),

      child: Column(
        children: [
          // ---------- DATE PICKERS ----------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _dateSelector("From", api.fromDate, () => api.pickFromDate(context)),
              _dateSelector("To", api.toDate, () => api.pickToDate(context)),
            ],
          ),

          const SizedBox(height: 12),

          // ---------- UNIT + INTERVAL + FETCH ----------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _styledDropdown(
                api.unit.value,
                api.allowedUnits,
                    (v) => api.updateUnit(v!),
              ),

              _styledDropdown(
                api.interval.value.toString(),
                api.getIntervalsForUnit().map((e) => e.toString()).toList(),
                    (v) => api.interval.value = int.parse(v!),
              ),

              _actionButton("Fetch", api.fetchData),
            ],
          ),

          const SizedBox(height: 12),

          // ---------- REPLAY BUTTONS ----------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _actionButton("▶ Start", chart.startReplay),
              _actionButton("⏸ Pause", chart.pauseReplay),
              _actionButton("⏹ Stop", chart.stopReplay),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // WIDGETS
  // ---------------------------------------------------------

  Widget _dateSelector(String title, RxString date, VoidCallback onTap) {
    return Column(
      children: [
        Text(title, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Obx(() => Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xff262628),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white24),
            ),
            child: Text(
              date.value.isEmpty ? "Select" : date.value,
              style: const TextStyle(color: Colors.white),
            ),
          )),
        ),
      ],
    );
  }

  Widget _styledDropdown(
      String value, List<String> options, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xff262628),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white24),
      ),
      child: DropdownButton<String>(
        dropdownColor: const Color(0xff2c2c2e),
        underline: Container(),
        value: value,
        style: const TextStyle(color: Colors.white),
        items: options
            .map((e) => DropdownMenuItem(
          value: e,
          child: Text(e, style: const TextStyle(color: Colors.white)),
        ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _actionButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff333336),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
