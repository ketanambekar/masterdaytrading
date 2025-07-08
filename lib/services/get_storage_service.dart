import 'package:get_storage/get_storage.dart';
import 'package:masterdaytrading/constants/app_constants.dart';

class GetStorageService {
  final _box = GetStorage();

  static const _configKey = AppConstants.appConfig;

  // Save entire config map
  void saveAppConfig(Map<String, dynamic> config) {
    _box.write(_configKey, config);
  }

  // Get entire config map
  Map<String, dynamic> getAppConfig() {
    return Map<String, dynamic>.from(_box.read(_configKey) ?? {});
  }

  // Update a single config value inside the map
  void updateAppConfig(String key, dynamic value) {
    final config = getAppConfig();
    config[key] = value;
    saveAppConfig(config);
  }

  // Read a single value from the config
  T? readAppConfig<T>(String key) {
    final config = getAppConfig();
    return config[key] as T?;
  }
}
