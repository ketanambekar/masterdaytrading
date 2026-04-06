import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'chart_controller.dart';
import 'package:masterdaytrading/services/api_controller.dart';

class ChartPageResponsive extends StatelessWidget {
  ChartPageResponsive({super.key});

  final chart = Get.put(ChartController());
  final api = Get.put(ApiController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 1024;
    final isTablet = size.width > 600 && size.width <= 1024;
    final isMobile = size.width <= 600;

    // Setup listeners
    ever(api.fromDate, (v) {
      if (chart.fromCtrl.text != v) chart.fromCtrl.text = v;
    });
    ever(api.toDate, (v) {
      if (chart.toCtrl.text != v) chart.toCtrl.text = v;
    });

    // Default load
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
          
          // Responsive toolbar
          if (isDesktop || isTablet)
            _desktopToolbar(context)
          else
            _mobileToolbar(context),

          // Chart
          Expanded(
            child: Stack(
              children: [
                GetBuilder<ChartController>(
                  builder: (_) {
                    return GetPlatform.isWeb
                        ? HtmlElementView(viewType: chart.viewId)
                        : WebViewWidget(controller: chart.mobileController!);
                  },
                ),
                
                // Loading overlay
                Obx(() => api.isLoading.value
                    ? Container(
                        color: Colors.black54,
                        child: const Center(
                          child: CircularProgressIndicator(color: Colors.blue),
                        ),
                      )
                    : const SizedBox.shrink()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Desktop & Tablet Toolbar
  Widget _desktopToolbar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: const Color(0xff111113),
      child: Column(
        children: [
          // Row 1: Date controls, Unit selection, Intervals
          Row(
            children: [
              // Dates
              SizedBox(
                width: 110,
                child: _dateField(chart.fromCtrl, "From", (v) {
                  api.fromDate.value = v;
                  if (isValidDate(v) && isValidDate(api.toDate.value)) {
                    api.fetchData();
                  }
                }),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 110,
                child: _dateField(chart.toCtrl, "To", (v) {
                  api.toDate.value = v;
                  if (isValidDate(v) && isValidDate(api.fromDate.value)) {
                    api.fetchData();
                  }
                }),
              ),
              const SizedBox(width: 16),
              
              // Unit icons
              ...["minutes", "hours", "days", "weeks", "months"].map((unit) {
                return Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: _unitChip(unit),
                );
              }).toList(),
              
              const SizedBox(width: 12),
              
              // Intervals
              Obx(() => Wrap(
                spacing: 4,
                children: api.getIntervalsForUnit().map((i) => _intervalChip(i)).toList(),
              )),
              
              const Spacer(),
              
              // Fetch button
              ElevatedButton.icon(
                onPressed: () => api.fetchData(),
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text("Fetch Data"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Row 2: Playback controls and indicators
          Row(
            children: [
              // Replay controls
              _iconBtn(Icons.play_arrow, chart.startReplay, "Play", Colors.green),
              _iconBtn(Icons.pause, chart.pauseReplay, "Pause", Colors.orange),
              _iconBtn(Icons.stop, chart.stopReplay, "Stop", Colors.red),
              
              const SizedBox(width: 16),
              const Text("Speed:", style: TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(width: 8),
              
              // Speed dropdown
              Obx(() => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xff262628),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: DropdownButton<int>(
                  value: api.replaySpeed.value,
                  dropdownColor: const Color(0xff262628),
                  underline: const SizedBox(),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  items: api.speedOptions.map((speed) {
                    return DropdownMenuItem(
                      value: speed,
                      child: Text("${speed}ms"),
                    );
                  }).toList(),
                  onChanged: (v) {
                    if (v != null) api.updateReplaySpeed(v);
                  },
                ),
              )),
              
              const SizedBox(width: 16),
              
              // Autoplay toggle
              Obx(() => CheckboxListTile(
                value: api.autoplayEnabled.value,
                onChanged: (_) => api.toggleAutoplay(),
                title: const Text("Auto-play", style: TextStyle(color: Colors.white, fontSize: 12)),
                controlAffinity: ListTileControlAffinity.leading,
                dense: true,
                contentPadding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              )),
              
              const SizedBox(width: 16),
              const Text("Indicators:", style: TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(width: 8),
              
              // Indicators
              _indicatorBtn("SMA", "sma20"),
              _indicatorBtn("EMA", "ema20"),
              _indicatorBtn("RSI", "rsi14"),
              _indicatorBtn("VWAP", "vwap"),
              _indicatorBtn("BB", "bb20"),
            ],
          ),
        ],
      ),
    );
  }

  // Mobile Toolbar
  Widget _mobileToolbar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: const Color(0xff111113),
      child: Column(
        children: [
          // Row 1: Date fields
          Row(
            children: [
              Expanded(
                child: _dateField(chart.fromCtrl, "From", (v) {
                  api.fromDate.value = v;
                  if (isValidDate(v) && isValidDate(api.toDate.value)) {
                    api.fetchData();
                  }
                }),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _dateField(chart.toCtrl, "To", (v) {
                  api.toDate.value = v;
                  if (isValidDate(v) && isValidDate(api.fromDate.value)) {
                    api.fetchData();
                  }
                }),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Row 2: Unit & Interval
          Row(
            children: [
              Expanded(
                child: Obx(() => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xff262628),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: DropdownButton<String>(
                    value: api.unit.value,
                    isExpanded: true,
                    dropdownColor: const Color(0xff262628),
                    underline: const SizedBox(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    items: api.allowedUnits.map((unit) {
                      return DropdownMenuItem(value: unit, child: Text(unit));
                    }).toList(),
                    onChanged: (v) {
                      if (v != null) {
                        api.updateUnit(v);
                        api.fetchData();
                      }
                    },
                  ),
                )),
              ),
              const SizedBox(width: 8),
              Obx(() => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xff262628),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: DropdownButton<int>(
                  value: api.interval.value,
                  dropdownColor: const Color(0xff262628),
                  underline: const SizedBox(),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  items: api.getIntervalsForUnit().map((i) {
                    return DropdownMenuItem(value: i, child: Text("$i"));
                  }).toList(),
                  onChanged: (v) {
                    if (v != null) {
                      api.interval.value = v;
                      api.fetchData();
                    }
                  },
                ),
              )),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => api.fetchData(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                child: const Icon(Icons.refresh, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Row 3: Playback controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _iconBtn(Icons.play_arrow, chart.startReplay, "", Colors.green),
              _iconBtn(Icons.pause, chart.pauseReplay, "", Colors.orange),
              _iconBtn(Icons.stop, chart.stopReplay, "", Colors.red),
              IconButton(
                onPressed: () => _showIndicatorsDialog(context),
                icon: const Icon(Icons.show_chart, color: Colors.blue),
                tooltip: "Indicators",
              ),
              IconButton(
                onPressed: () => _showSettingsDialog(context),
                icon: const Icon(Icons.settings, color: Colors.white70),
                tooltip: "Settings",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dateField(TextEditingController ctrl, String label, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 10)),
        const SizedBox(height: 2),
        Container(
          height: 32,
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
              hintStyle: TextStyle(color: Colors.white38, fontSize: 11),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _unitChip(String unit) {
    return Obx(() {
      bool active = api.unit.value == unit;
      return GestureDetector(
        onTap: () {
          api.updateUnit(unit);
          api.fetchData();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: active ? Colors.blueAccent : const Color(0xff222226),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            unit[0].toUpperCase(),
            style: TextStyle(
              color: active ? Colors.white : Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    });
  }

  Widget _intervalChip(int value) {
    return Obx(() {
      bool active = api.interval.value == value;
      return GestureDetector(
        onTap: () {
          api.interval.value = value;
          api.fetchData();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: active ? Colors.orangeAccent : const Color(0xff2a2a2d),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "$value",
            style: TextStyle(
              color: active ? Colors.black : Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    });
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap, String tooltip, Color color) {
    return Tooltip(
      message: tooltip,
      child: Container(
        margin: const EdgeInsets.only(right: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: IconButton(
          icon: Icon(icon, color: color, size: 20),
          onPressed: onTap,
          padding: const EdgeInsets.all(8),
          constraints: const BoxConstraints(),
        ),
      ),
    );
  }

  Widget _indicatorBtn(String label, String indicatorId) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: OutlinedButton(
        onPressed: () => chart.addIndicator(indicatorId),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.white24),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          minimumSize: Size.zero,
        ),
        child: Text(label, style: const TextStyle(fontSize: 11)),
      ),
    );
  }

  void _showIndicatorsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Indicators"),
        backgroundColor: const Color(0xff1a1a1d),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _dialogIndicatorBtn("SMA 20", "sma20"),
            _dialogIndicatorBtn("EMA 20", "ema20"),
            _dialogIndicatorBtn("RSI 14", "rsi14"),
            _dialogIndicatorBtn("VWAP", "vwap"),
            _dialogIndicatorBtn("Bollinger Bands", "bb20"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  Widget _dialogIndicatorBtn(String label, String indicatorId) {
    return ListTile(
      title: Text(label, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(Icons.add, color: Colors.green),
      onTap: () {
        chart.addIndicator(indicatorId);
        Navigator.pop(Get.context!);
      },
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Playback Settings"),
        backgroundColor: const Color(0xff1a1a1d),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() => SwitchListTile(
              title: const Text("Auto-play on Load", style: TextStyle(color: Colors.white)),
              value: api.autoplayEnabled.value,
              onChanged: (_) => api.toggleAutoplay(),
            )),
            const Divider(),
            const Text("Replay Speed", style: TextStyle(color: Colors.white70)),
            Obx(() => Slider(
              value: api.replaySpeed.value.toDouble(),
              min: 100,
              max: 2000,
              divisions: 19,
              label: "${api.replaySpeed.value}ms",
              onChanged: (v) => api.updateReplaySpeed(v.toInt()),
            )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }
}

bool isValidDate(String input) {
  try {
    if (input.length != 10) return false;
    final dt = DateTime.tryParse(input);
    if (dt == null) return false;
    final reg = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    return reg.hasMatch(input);
  } catch (_) {
    return false;
  }
}
