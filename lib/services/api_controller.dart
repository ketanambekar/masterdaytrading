import 'package:get/get.dart';
import 'package:masterdaytrading/modules/chart_page/chart_controller.dart';
import 'package:masterdaytrading/services/api_service.dart';
import 'package:flutter/material.dart';

class ApiController extends GetxController {
  final api = ApiService("0e239d4b-55da-4aa6-9f9f-7e335ed273cb");
  RxString fromDate = "".obs;
  RxString toDate = "".obs;

  RxString unit = "minutes".obs;
  RxInt interval = 5.obs;
  RxString selectedInstrument = "NSE_EQ|INE848E01016".obs; // Default: Reliance
  RxBool isLoading = false.obs;
  RxBool autoplayEnabled = false.obs;
  RxInt replaySpeed = 300.obs; // milliseconds

  bool loadedOnce = false;

  List<String> get allowedUnits => ApiService.allowedUnits;

  List<int> getIntervalsForUnit() {
    switch (unit.value) {
      case "minutes":
        return [1, 3, 5, 15, 30, 60];
      case "hours":
        return [1, 2, 4];
      case "days":
        return [1];
      case "weeks":
        return [1];
      case "months":
        return [1];
      default:
        return [1];
    }
  }

  List<int> get speedOptions => [100, 300, 500, 1000, 2000]; // replay speed in ms

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

  // ------------------- DEFAULT SETUP ------------------------
  void setDefault1Day() {
    final now = DateTime.now();
    toDate.value = now.toIso8601String().substring(0, 10);
    fromDate.value = now
        .subtract(const Duration(days: 7))
        .toIso8601String()
        .substring(0, 10);

    unit.value = "minutes";
    interval.value = 5;

    fetchData();
  }

  // Set to intraday mode (today's data only)
  void setIntradayMode() {
    unit.value = "minutes";
    interval.value = 5;
    fromDate.value = "";
    toDate.value = "";
    fetchData();
  }

  // ---------------------- FETCH DATA --------------------------------
  Future<void> fetchData() async {
    // For intraday mode (minutes/hours without dates), use intraday API
    if ((unit.value == "minutes" || unit.value == "hours") && 
        (fromDate.value.isEmpty || toDate.value.isEmpty)) {
      await fetchIntradayData();
      return;
    }

    // Otherwise require both dates for historical data
    if (fromDate.value.isEmpty || toDate.value.isEmpty) {
      Get.snackbar(
        "Date Required",
        "Please select both from and to dates",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      List<Map<String, dynamic>> candles = await api.getCandles(
        instrumentKey: selectedInstrument.value,
        unit: unit.value,
        interval: interval.value,
        toDate: toDate.value,
        fromDate: fromDate.value,
      );

      if (candles.isEmpty) {
        Get.snackbar(
          "No Data",
          "No candles found for the selected period",
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      // Reverse data to show oldest first
      candles = candles.reversed.toList();

      final chart = Get.find<ChartController>();
      chart.sendData(candles);
      chart.setStartDate(fromDate.value);

      // Auto-start replay if enabled
      if (autoplayEnabled.value) {
        Future.delayed(const Duration(milliseconds: 500), () {
          chart.startReplay();
        });
      }

      Get.snackbar(
        "Data Loaded",
        "${candles.length} candles loaded successfully",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        "API Error",
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch intraday data (today's data)
  Future<void> fetchIntradayData() async {
    isLoading.value = true;
    try {
      List<Map<String, dynamic>> candles = await api.getIntradayCandles(
        instrumentKey: selectedInstrument.value,
        unit: unit.value,
        interval: interval.value,
      );

      if (candles.isEmpty) {
        Get.snackbar(
          "No Data",
          "No intraday candles available",
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      // Reverse to show oldest first
      candles = candles.reversed.toList();

      final chart = Get.find<ChartController>();
      chart.sendData(candles);
      
      // Set start date to today
      final today = DateTime.now().toIso8601String().substring(0, 10);
      chart.setStartDate(today);

      // Auto-start replay if enabled
      if (autoplayEnabled.value) {
        Future.delayed(const Duration(milliseconds: 500), () {
          chart.startReplay();
        });
      }

      Get.snackbar(
        "Intraday Data Loaded",
        "${candles.length} candles loaded",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        "API Error",
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void toggleAutoplay() {
    autoplayEnabled.value = !autoplayEnabled.value;
  }

  void updateReplaySpeed(int ms) {
    replaySpeed.value = ms;
    try {
      final chart = Get.find<ChartController>();
      chart.setSpeed(ms);
    } catch (_) {}
  }
}
