import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:titgram/ads/admob/adunits.dart';

class AdManager {
  final BuildContext context;
  InterstitialAd? _interstitialAd;
  Map<int, ValueNotifier<bool>> bannerAdStream = {};
  Map<int, BannerAd> bannerAdsBook = {};
  AdManager(this.context);

  AdSize getAdSize() {
    return AdSize(width: MediaQuery.of(context).size.width.toInt(), height: 50);
  }

  int getBannerStreamID() {
    final random = Random();
    int minRange = 99;
    int maxRange = 9999;
    final randomNumber = random.nextInt(maxRange - minRange) + minRange;
    return randomNumber;
  }

  Future<void> loadBanner(int streamID) async {
    BannerAd(
      adUnitId: Adunits.getBannerAdUnit,
      request: const AdRequest(),
      size: getAdSize(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          bannerAdStream[streamID]!.value = true;
          bannerAdsBook[streamID] = ad as BannerAd;
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          ad.dispose();
        },
        onAdOpened: (Ad ad) {},
        onAdClosed: (Ad ad) {},
        onAdImpression: (Ad ad) {},
      ),
    ).load();
  }

  Widget insertBanner() {
    int bannerAdStreamId = getBannerStreamID();
    loadBanner(bannerAdStreamId);
    bannerAdStream[bannerAdStreamId] = ValueNotifier<bool>(false);
    return ValueListenableBuilder<bool>(
      valueListenable: bannerAdStream[bannerAdStreamId] as ValueNotifier<bool>,
      builder: (context, isLoaded, child) {
        if (!isLoaded) return Container();
        BannerAd ad = bannerAdsBook[bannerAdStreamId]!;
        return SizedBox(
          width: ad.size.width.toDouble(),
          height: ad.size.height.toDouble(),
          child: AdWidget(ad: ad),
        );
      },
    );
  }

  /// Loads an interstitial ad.
  void loadInter() {
    InterstitialAd.load(
      adUnitId: Adunits.getInterAdUnit,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {},
            onAdImpression: (ad) {},
            onAdFailedToShowFullScreenContent: (ad, err) {
              _interstitialAd = null;
              ad.dispose();
              loadInter();
            },
            onAdDismissedFullScreenContent: (ad) {
              _interstitialAd = null;
              ad.dispose();
              loadInter();
            },
            onAdClicked: (ad) {},
          );
          _interstitialAd = ad;
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  showInter() {
    if (_interstitialAd == null) return loadInter();
    _interstitialAd?.show();
  }

  disposeAdStream() {
    bannerAdsBook.forEach((key, ad) {
      ad.dispose();
    });
  }
}
