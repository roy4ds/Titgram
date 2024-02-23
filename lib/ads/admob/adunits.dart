import 'dart:io';

class Adunits {
  static get getBannerAdUnit {
    final String adUnit = Platform.isAndroid
        ? 'ca-app-pub-3940256099942544/6300978111'
        : 'ca-app-pub-3940256099942544/2934735716';
    return adUnit;
  }

  static get getInterAdUnit {
    final String adUnit = Platform.isAndroid
        ? 'ca-app-pub-3940256099942544/1033173712'
        : 'ca-app-pub-3940256099942544/4411468910';
    return adUnit;
  }

  static get getAppOpenAdunit {
    final String adUnit = Platform.isAndroid
        ? 'ca-app-pub-3940256099942544/9257395921'
        : 'ca-app-pub-3940256099942544/5575463023';
    return adUnit;
  }
}
