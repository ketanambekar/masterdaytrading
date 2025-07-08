import 'package:get/get.dart';

class OfferTimerController extends GetxController {
  var secondsLeft = 86400.obs; // 1 day in seconds

  @override
  void onInit() {
    super.onInit();
    _startCountdown();
  }

  void _startCountdown() {
    ever(secondsLeft, (_) {
      if (secondsLeft.value <= 0) return;
    });

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (secondsLeft.value > 0) {
        secondsLeft.value--;
        return true;
      }
      return false;
    });
  }

  String get formattedTime {
    final hours = (secondsLeft.value ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((secondsLeft.value % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (secondsLeft.value % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }
}
