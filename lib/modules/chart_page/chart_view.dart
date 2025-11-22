import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'chart_controller.dart';
import 'package:masterdaytrading/services/api_controller.dart';

class ChartPage extends StatelessWidget {
  ChartPage({super.key});

  final chart = Get.put(ChartController());
  final api = Get.put(ApiController());

  // Persistent controllers (never recreated)

  @override
  Widget build(BuildContext context) {
    ever(api.fromDate, (v) {
      if (chart.fromCtrl.text != v) chart.fromCtrl.text = v;
    });
    ever(api.toDate, (v) {
      if (chart.toCtrl.text != v) chart.toCtrl.text = v;
    });

    // default load
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!api.loadedOnce) {
        api.loadedOnce = true;
        api.setDefault1Day();
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xff0d0d0f),
      body: Column(
        children: [
          const SizedBox(height: 4),

          /// TOP ICON TOOLBAR
          _iconToolbar(),

          /// CHART BELOW
          Expanded(
            child: GetBuilder<ChartController>(
              builder: (_) {
                return GetPlatform.isWeb
                    ? HtmlElementView(viewType: chart.viewId)
                    : WebViewWidget(controller: chart.mobileController!);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------------
  // TOP TOOLBAR — ICON ONLY, RESPONSIVE, AUTO-FETCH ON CHANGE
  // ----------------------------------------------------------------------
  Widget _iconToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      color: const Color(0xff111113),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          /// DATE FIELDS
          _dateField(chart.fromCtrl, (v) {
            api.fromDate.value = v;
            if (isValidDate(v) && isValidDate(api.toDate.value)) {
              api.fetchData(); // auto fetch only when BOTH dates valid
            }
          }),

          _dateField(chart.toCtrl, (v) {
            api.toDate.value = v;
            if (isValidDate(v) && isValidDate(api.fromDate.value)) {
              api.fetchData(); // auto fetch only when BOTH dates valid
            } // auto fetch
          }),

          /// TIMEFRAME UNIT ICONS
          _unitIcon(Icons.timelapse, "minutes"),
          _unitIcon(Icons.schedule, "hours"),
          _unitIcon(Icons.calendar_today, "days"),
          _unitIcon(Icons.date_range, "weeks"),
          _unitIcon(Icons.event_note, "months"),

          /// INTERVAL CHIPS
          Obx(() {
            return Wrap(
              spacing: 6,
              children: api.getIntervalsForUnit().map((i) {
                return _intervalChip(i);
              }).toList(),
            );
          }),

          /// REPLAY ICONS
          _iconBtn(Icons.play_arrow, chart.startReplay),
          _iconBtn(Icons.pause, chart.pauseReplay),
          _iconBtn(Icons.stop, chart.stopReplay),
          _iconBtn(Icons.show_chart, () => chart.addIndicator("sma")),
          _iconBtn(Icons.trending_up, () => chart.addIndicator("ema")),
          _iconBtn(Icons.stacked_line_chart, () => chart.addIndicator("rsi")),
          _iconBtn(Icons.waterfall_chart, () => chart.addIndicator("vwap")),
          _iconBtn(Icons.multiline_chart, () => chart.addIndicator("bb")),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------------
  // DATE INPUT FIELD (ALWAYS EDITABLE)
  // ----------------------------------------------------------------------
  Widget _dateField(TextEditingController ctrl, Function(String) onChanged) {
    return SizedBox(
      width: 110,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: const Color(0xff262628),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.white24),
        ),
        child: TextField(
          controller: ctrl,
          onChanged: onChanged,
          style: const TextStyle(color: Colors.white, fontSize: 12),
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: "YYYY-MM-DD",
            hintStyle: TextStyle(color: Colors.white38, fontSize: 12),
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------------------
  // UNIT ICON (min/hr/day/week/month)
  // ----------------------------------------------------------------------
  Widget _unitIcon(IconData icon, String unit) {
    return Obx(() {
      bool active = api.unit.value == unit;

      return GestureDetector(
        onTap: () {
          api.updateUnit(unit);
          api.fetchData(); // auto fetch
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: active ? Colors.blueAccent : const Color(0xff222226),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: active ? Colors.white : Colors.white70,
          ),
        ),
      );
    });
  }

  // ----------------------------------------------------------------------
  // INTERVAL CHIP (auto-fetch)
  // ----------------------------------------------------------------------
  Widget _intervalChip(int value) {
    return Obx(() {
      bool active = api.interval.value == value;

      return GestureDetector(
        onTap: () {
          api.interval.value = value;
          api.fetchData(); // auto fetch
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: active ? Colors.orangeAccent : const Color(0xff2a2a2d),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            "$value",
            style: TextStyle(
              color: active ? Colors.black : Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    });
  }

  // ----------------------------------------------------------------------
  // SMALL ICON BUTTON
  // ----------------------------------------------------------------------
  Widget _iconBtn(IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff333336),
        borderRadius: BorderRadius.circular(6),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 22),
        onPressed: onTap,
      ),
    );
  }
}

bool isValidDate(String input) {
  try {
    if (input.length != 10) return false; // must be YYYY-MM-DD
    final dt = DateTime.tryParse(input);
    if (dt == null) return false;

    // must match exactly YYYY-MM-DD (avoid parsing weird values)
    final reg = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!reg.hasMatch(input)) return false;

    return true;
  } catch (_) {
    return false;
  }
}
