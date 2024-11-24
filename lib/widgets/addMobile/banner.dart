import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerExample extends StatefulWidget {
  final int tipo;
  const BannerExample({super.key, required this.tipo});

  @override
  State<BannerExample> createState() => BannerExampleState();
}

class BannerExampleState extends State<BannerExample> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  final adUnitId = 'ca-app-pub-9048977034983785/9486861446';
  @override
  void initState() {
    super.initState();
    loadAd();
  }

  void loadAd() async {
    _bannerAd = BannerAd(
        adUnitId: adUnitId,
        request: const AdRequest(),
        size: widget.tipo == 0
            ? AdSize.banner
            : widget.tipo == 1
                ? AdSize.fullBanner
                : AdSize.fluid,
        listener: BannerAdListener(
            // Called when an ad is successfully received.
            onAdLoaded: (ad) {
          debugPrint('$ad cargo.');
          setState(() {
            _isLoaded = true;
          });
        },
            // Called when an ad request failed.
            onAdFailedToLoad: (ad, err) {
          debugPrint('banner fallo: $err');
          ad.dispose();
        }))
      ..load();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: _isLoaded
            ? SafeArea(
                child: _bannerAd != null
                    ? SizedBox(
                        width: _bannerAd!.size.width.toDouble(),
                        height: _bannerAd!.size.height.toDouble(),
                        child: AdWidget(ad: _bannerAd!))
                    : Placeholder())
            : LinearProgressIndicator());
  }
}
