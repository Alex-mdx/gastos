import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdFun {
  static InterstitialAd? interstitialAd;
  static final adUnitId = 'ca-app-pub-9048977034983785/4773762257';
  static Future<void> loadAd() async {
    await InterstitialAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdShowedFullScreenContent: (ad) {},
              onAdImpression: (ad) {},
              onAdFailedToShowFullScreenContent: (ad, err) {
                ad.dispose();
              },
              onAdDismissedFullScreenContent: (ad) {
                
                ad.dispose();
              },
              onAdClicked: (ad) {});
          debugPrint('$ad cargo.');
          interstitialAd = ad;
        },
            // Called when an ad request failed.
            onAdFailedToLoad: (LoadAdError error) {
          debugPrint('No cargo: $error');
        }));
  }
}
