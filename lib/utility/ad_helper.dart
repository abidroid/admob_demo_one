import 'dart:io';

class AdHelper{
  
  static String getBannerAdId() {
    
    if( Platform.isAndroid){
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if( Platform.isIOS){
      return 'ca-app-pub-3940256099942544/2934735716';
    }else{
      throw  UnsupportedError('Unsupported platform');
    }
  }

  static String getInterstitialAdId(){
    if( Platform.isAndroid){
      return 'ca-app-pub-3940256099942544/8691691433';
    } else if( Platform.isIOS){
      return 'ca-app-pub-3940256099942544/5135589807';
    }else{
      throw  UnsupportedError('Unsupported platform');
    }
  }

}