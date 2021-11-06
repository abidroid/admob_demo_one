import 'package:admob_demo_one/screens/detail_screen.dart';
import 'package:admob_demo_one/utility/ad_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late BannerAd _bottomBannerAd;
  bool _isBottomAdLoaded = false;

  late BannerAd _inlineBannerAd;
  final _inlineAdIndex = 3;
  bool _isInlineBannerAdLoaded = false;

  InterstitialAd? _interstitialAd;

  int _interstitialLoadAttempts = 0;

  void _createBottomBannerAd() {
    _bottomBannerAd = BannerAd(
        adUnitId: AdHelper.getBannerAdId(),
        request: const AdRequest(),
        size: AdSize.banner,
        listener: BannerAdListener(onAdLoaded: (_) {
          setState(() {
            _isBottomAdLoaded = true;
          });
        }, onAdFailedToLoad: (ad, error) {
          ad.dispose();
        }));

    _bottomBannerAd.load();
  }

  void _createInlineBannerAd() {
    _inlineBannerAd = BannerAd(
      size: AdSize.mediumRectangle,
      adUnitId: AdHelper.getBannerAdId(),
      listener: BannerAdListener(

          onAdLoaded: (_) {
            _isInlineBannerAdLoaded = true;
          },

          onAdFailedToLoad: (ad, error) {
            _inlineBannerAd.dispose();
          }
      ),

      request: const AdRequest(),
    );

    _inlineBannerAd.load();
  }

  void _createInterstitialAd() {
    InterstitialAd.load(adUnitId: AdHelper.getInterstitialAdId(),
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (InterstitialAd ad) {

              _interstitialAd = ad;
              _interstitialLoadAttempts = 0;
            },
            onAdFailedToLoad: (LoadAdError error) {

              _interstitialLoadAttempts++;
              _interstitialAd = null;

              if(_interstitialLoadAttempts <= 3 ){
                _createInterstitialAd();
              }

            }));
  }

  void _showInterstitialAd(){

    if( _interstitialAd != null ){
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(

        onAdDismissedFullScreenContent: (InterstitialAd ad){
          ad.dispose();
          _createInterstitialAd();
        },

        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error){
          ad.dispose();
          _createInterstitialAd();
        }
      );

      _interstitialAd!.show();
    }
  }

  int _getIndex(int index) {
    if (index >= _inlineAdIndex && _isInlineBannerAdLoaded) {
      index = index - 1;
      return index;
    }

    return index;
  }

  @override
  void initState() {
    super.initState();
    _createBottomBannerAd();
    _createInlineBannerAd();
    _createInterstitialAd();
  }

  @override
  void dispose() {
    super.dispose();
    _bottomBannerAd.dispose();
    _inlineBannerAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView.builder(
                    itemCount: 50 + (_isInlineBannerAdLoaded ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (_isInlineBannerAdLoaded && index == _inlineAdIndex) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),

                          width: _inlineBannerAd.size.width.toDouble(),
                          height: _inlineBannerAd.size.height.toDouble(),

                          child: AdWidget(ad: _inlineBannerAd,),
                        );
                      } else {
                        return GestureDetector(
                          onTap: () {

                            _showInterstitialAd();

                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) {
                                  return DetailScreen(index: _getIndex(index));
                                }));
                          },
                          child: Container(
                            height: 200,
                            margin: const EdgeInsets.only(bottom: 10.0),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.deepOrange,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const FlutterLogo(
                                  size: 80,
                                ),
                                Text(

                                  '${_getIndex(index)}',

                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    }),
              ),
            ),
            _isBottomAdLoaded
                ? SizedBox(
              height: _bottomBannerAd.size.height.toDouble(),
              width: _bottomBannerAd.size.width.toDouble(),
              child: AdWidget(
                ad: _bottomBannerAd,
              ),
            )
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
