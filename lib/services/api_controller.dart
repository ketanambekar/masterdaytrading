import 'package:get/get.dart';
import 'package:masterdaytrading/modules/chart_page/chart_controller.dart';
import 'package:masterdaytrading/services/api_service.dart';
import 'package:flutter/material.dart';

class ApiController extends GetxController {
  final api = ApiService("0e239d4b-55da-4aa6-9f9f-7e335ed273cb");
  RxString fromDate = "".obs;
  RxString toDate = "".obs;

  RxString unit = "days".obs;
  RxInt interval = 1.obs;

  bool loadedOnce = false;

  List<String> get allowedUnits => ApiService.allowedUnits;

  List<int> getIntervalsForUnit() {
    switch (unit.value) {
      case "minutes":
        return [1, 3, 5, 15, 30, 60, 120, 300];
      case "hours":
        return [1, 2, 3, 4, 5];
      default:
        return [1];
    }
  }

  // ------------------------- DATE PICKERS -------------------------
  Future<void> pickFromDate(BuildContext ctx) async {
    final d = await showDatePicker(
      context: ctx,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (d != null) fromDate.value = d.toIso8601String().substring(0, 10);
  }

  Future<void> pickToDate(BuildContext ctx) async {
    final d = await showDatePicker(
      context: ctx,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (d != null) toDate.value = d.toIso8601String().substring(0, 10);
  }

  void updateUnit(String v) {
    unit.value = v;
    interval.value = 1;
    update();
  }

  // ------------------- DEFAULT 1 DAY FETCH ------------------------
  void setDefault1Day() {
    final now = DateTime.now();
    toDate.value = now.toIso8601String().substring(0, 10);
    fromDate.value = now
        .subtract(const Duration(days: 30))
        .toIso8601String()
        .substring(0, 10);

    unit.value = "minutes";
    interval.value = 5;

    fetchData();
  }

  // ---------------------- FETCH DATA --------------------------------
  Future<void> fetchData() async {
    if (fromDate.value.isEmpty || toDate.value.isEmpty) {
      Get.snackbar("Error", "Select from/to dates");
      return;
    }

    try {
      List<Map<String, dynamic>> candles = await api.getCandles(
        key: "NSE_EQ|INE848E01016",
        unit: unit.value,
        interval: interval.value,
        toDate: toDate.value,
        fromDate: fromDate.value,
      );

      // 🔥🔥🔥 FIX: Reverse data BEFORE sending to chart
      candles = candles.reversed.toList();

      final chart = Get.find<ChartController>();
      chart.sendData(candles);
      chart.setStartDate(fromDate.value);

    } catch (e) {
      Get.snackbar("API Error", e.toString());
    }
  }
}
