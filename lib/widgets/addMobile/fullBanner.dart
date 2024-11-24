import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gastos/utilities/preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class FullBanner extends StatefulWidget {
  final Widget cabeza;
  final VoidCallback funcion;
  const FullBanner({super.key, required this.cabeza, required this.funcion});

  @override
  State<FullBanner> createState() => _FullbannerState();
}

class _FullbannerState extends State<FullBanner> {
  InterstitialAd? _interstitialAd;
  final adUnitId = 'ca-app-pub-9048977034983785/4773762257';
  @override
  void initState() {
    super.initState();
  }

  /// Loads an interstitial ad.
  Future<void> loadAd() async {
    InterstitialAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
                // Called when the ad showed the full screen content.
                onAdShowedFullScreenContent: (ad) {},
                // Called when an impression occurs on the ad.
                onAdImpression: (ad) {},
                // Called when the ad failed to show full screen content.
                onAdFailedToShowFullScreenContent: (ad, err) {
                  widget.funcion();
                  ad.dispose();
                },
                // Called when the ad dismissed full screen content.
                onAdDismissedFullScreenContent: (ad) {
                  widget.funcion();
                  Preferences.setting = DateTime.now().toString();
                  ad.dispose();
                },
                // Called when a click is recorded for an ad.
                onAdClicked: (ad) {});

            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            _interstitialAd = ad;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () async {
          log("${DateTime.parse(Preferences.setting).add(Duration(minutes: 60))}");
          if (DateTime.parse(Preferences.setting)
              .add(Duration(minutes: 60))
              .isBefore(DateTime.now())) {
            await loadAd();
            if (_interstitialAd != null) {
              _interstitialAd!.show();
            }
          } else {
            widget.funcion();
          }
        },
        child: widget.cabeza);
  }
}
