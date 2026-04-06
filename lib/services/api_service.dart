import 'package:dio/dio.dart';

class ApiService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://api.upstox.com/v3",
      headers: {"Content-Type": "application/json"},
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  final String token;
  ApiService(this.token);

  static const allowedUnits = ["minutes", "hours", "days", "weeks", "months"];
  static const allowedIntradayUnits = ["minutes", "hours"];

  /// Fetch Historical Candle Data (for days, weeks, months)
  /// API: GET /historical-candle/{instrumentKey}/{unit}/{interval}/{toDate}/{fromDate}
  Future<List<Map<String, dynamic>>> getHistoricalCandles({
    required String instrumentKey,
    required String unit,
    required int interval,
    required String toDate,
    required String fromDate,
  }) async {
    if (!allowedUnits.contains(unit)) {
      throw Exception("Invalid unit. Allowed: ${allowedUnits.join(', ')}");
    }

    try {
      final res = await dio.get(
        "/historical-candle/$instrumentKey/$unit/$interval/$toDate/$fromDate",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (res.data["status"] == "error") {
        throw Exception(res.data["message"] ?? "API Error");
      }

      final candles = res.data["data"]["candles"] as List;

      return candles.map((c) {
        return {
          "time": convertToUnix(c[0]),
          "open": (c[1] as num).toDouble(),
          "high": (c[2] as num).toDouble(),
          "low": (c[3] as num).toDouble(),
          "close": (c[4] as num).toDouble(),
          "volume": (c[5] as num).toInt(),
          "oi": (c[6] as num).toInt(),
        };
      }).toList();
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Fetch Intraday Candle Data (for minutes and hours only)
  /// API: GET /historical-candle/intraday/{instrumentKey}/{unit}/{interval}
  Future<List<Map<String, dynamic>>> getIntradayCandles({
    required String instrumentKey,
    required String unit,
    required int interval,
  }) async {
    if (!allowedIntradayUnits.contains(unit)) {
      throw Exception("Invalid intraday unit. Allowed: ${allowedIntradayUnits.join(', ')}");
    }

    try {
      final res = await dio.get(
        "/historical-candle/intraday/$instrumentKey/$unit/$interval",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (res.data["status"] == "error") {
        throw Exception(res.data["message"] ?? "API Error");
      }

      final candles = res.data["data"]["candles"] as List;

      return candles.map((c) {
        return {
          "time": convertToUnix(c[0]),
          "open": (c[1] as num).toDouble(),
          "high": (c[2] as num).toDouble(),
          "low": (c[3] as num).toDouble(),
          "close": (c[4] as num).toDouble(),
          "volume": (c[5] as num).toInt(),
          "oi": (c[6] as num).toInt(),
        };
      }).toList();
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  /// Smart fetch - automatically chooses between historical or intraday based on unit
  Future<List<Map<String, dynamic>>> getCandles({
    required String instrumentKey,
    required String unit,
    required int interval,
    String? toDate,
    String? fromDate,
  }) async {
    // Use intraday API for minutes and hours without date range
    if (allowedIntradayUnits.contains(unit) && (toDate == null || fromDate == null)) {
      return getIntradayCandles(
        instrumentKey: instrumentKey,
        unit: unit,
        interval: interval,
      );
    }

    // Use historical API for all other cases
    if (toDate == null || fromDate == null) {
      throw Exception("toDate and fromDate are required for historical data");
    }

    return getHistoricalCandles(
      instrumentKey: instrumentKey,
      unit: unit,
      interval: interval,
      toDate: toDate,
      fromDate: fromDate,
    );
  }

  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return "Connection timeout. Please check your internet connection.";
      case DioExceptionType.badResponse:
        return "Server error: ${e.response?.statusCode ?? 'Unknown'}";
      case DioExceptionType.cancel:
        return "Request cancelled";
      default:
        return e.message ?? "Network error occurred";
    }
  }
}

int convertToUnix(String isoString) {
  try {
    // Parse the ISO string - Upstox returns IST timezone
    DateTime dt = DateTime.parse(isoString);
    
    // If the string contains timezone info, parse it correctly
    if (isoString.contains('+') || isoString.endsWith('Z')) {
      // Already has timezone, convert to local time then to unix
      return dt.toLocal().millisecondsSinceEpoch ~/ 1000;
    }
    
    // Assume IST if no timezone provided
    // Subtract 5:30 to get UTC, then convert to unix timestamp
    final utc = dt.subtract(const Duration(hours: 5, minutes: 30));
    return utc.millisecondsSinceEpoch ~/ 1000;
  } catch (e) {
    throw Exception("Invalid date format: $isoString");
  }
}
