import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:titgram/ads/admob/adunits.dart';

class AdManager {
  final BuildContext context;
  InterstitialAd? _interstitialAd;
  AdManager(this.context);

  AdSize getAdSize() {
    return AdSize(width: MediaQuery.of(context).size.width.toInt(), height: 50);
  }

  Widget loadBanner() {
    BannerAd? bannerAd;
    BannerAd(
      adUnitId: Adunits.getBannerAdUnit,
      request: const AdRequest(),
      size: getAdSize(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          bannerAd = ad as BannerAd;
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

    if (bannerAd != null) {
      return SizedBox(
        width: bannerAd!.size.width.toDouble(),
        height: bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: bannerAd!),
      );
    } else {
      return Container();
    }
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
              ad.dispose();
            },
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
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

  disposeAdStreams() {}
}
