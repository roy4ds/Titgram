import 'dart:io';
import 'dart:math';

class Adunits {
  static const bool isLive = false;
  static const env = isLive ? "live" : "test";
  static String platform = Platform.isAndroid ? 'android' : 'ios';

  static String randomAdUnit(List adunits) {
    final random = Random();
    int max = adunits.length;
    final x = random.nextInt(max);
    return adunits[x];
  }

  static get getBannerAdUnit {
    final Map<String, Map<String, dynamic>> adUnits = {
      "android": {
        "live": [],
        "test": "ca-app-pub-3940256099942544/6300978111",
      },
      "ios": {
        "live": [],
        "test": "ca-app-pub-3940256099942544/2934735716",
      }
    };
    final base = adUnits[platform]![env];
    if (!isLive) return base;
    return randomAdUnit(base);
  }

  static get getInterAdUnit {
    final Map<String, Map<String, dynamic>> adUnits = {
      "android": {
        "live": [],
        "test": "ca-app-pub-3940256099942544/1033173712",
      },
      "ios": {
        "live": [],
        "test": "ca-app-pub-3940256099942544/4411468910",
      }
    };
    final base = adUnits[platform]![env];
    if (!isLive) return base;
    return randomAdUnit(base);
  }

  static get getAppOpenAdunit {
    final Map<String, Map<String, dynamic>> adUnits = {
      "android": {
        "live": [],
        "test": "ca-app-pub-3940256099942544/9257395921",
      },
      "ios": {
        "live": [],
        "test": "ca-app-pub-3940256099942544/5575463023",
      }
    };
    final base = adUnits[platform]![env];
    if (!isLive) return base;
    return randomAdUnit(base);
  }
}
