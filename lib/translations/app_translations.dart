import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      'title': 'Master Day Trading',
      'home': 'Home',
      'profile': 'Profile',
      'settings': 'Settings',
      'logout': 'Logout',
      'live_updates': 'Live Updates',
      'no_updates': 'No updates yet',
      'add_update': 'Add Live Update',
    },
    'hi_IN': {
      'title': 'ढोकियास',
      'home': 'होम',
      'profile': 'प्रोफ़ाइल',
      'settings': 'सेटिंग्स',
      'logout': 'लॉगआउट',
      'live_updates': 'लाइव अपडेट्स',
      'no_updates': 'कोई अपडेट नहीं',
      'add_update': 'अपडेट जोड़ें',
    },
  };
}
