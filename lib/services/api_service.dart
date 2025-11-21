import 'package:dio/dio.dart';

class ApiService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://api.upstox.com/v3",
      headers: {"Content-Type": "application/json"},
    ),
  );

  final String token;
  ApiService(this.token);

  static const allowedUnits = ["minutes", "hours", "days", "weeks", "months"];

  Future<List<Map<String, dynamic>>> getCandles({
    required String key,
    required String unit,
    required int interval,
    required String toDate,
    required String fromDate,
  }) async {
    if (!allowedUnits.contains(unit)) {
      throw Exception("Invalid unit");
    }

    final res = await dio.get(
      "/historical-candle/$key/$unit/$interval/$toDate/$fromDate",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    final candles = res.data["data"]["candles"] as List;

    return candles.map((c) {
      return {
        "time": convertToUnix(c[0]),
        "open": c[1],
        "high": c[2],
        "low": c[3],
        "close": c[4],
        "volume": c[5],
        "oi": c[6],
      };
    }).toList();
  }
}
int convertToUnix(String isoString) {
  DateTime local = DateTime.parse(isoString);   // Keep original offset
  DateTime ist = local.toUtc().add(const Duration(hours: 5, minutes: 30));
  return ist.millisecondsSinceEpoch ~/ 1000;
}
