// define globally
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

enum Ads {
  //If more than one ids in app
  bannerAdCollectionDetailsId,
  bannerAdListCollectionId,
  bannerAdLinksOverviewId,
  bannerAdSettingId,
}

class AdHelper {
  static String getAdmobAdId({required Ads adsName}) {
    // check platform
    final isPlatformAndroid = Platform.isAndroid;

    final testBannerAdId = isPlatformAndroid
        ? "ca-app-pub-3940256099942544/6300978111"
        : "ca-app-pub-3940256099942544/2934735716";

    if (kDebugMode) {
      // If in debug mode
      switch (adsName) {
        // for all banner ads in app in Debug mode
        case Ads.bannerAdCollectionDetailsId:
        case Ads.bannerAdListCollectionId:
        case Ads.bannerAdLinksOverviewId:
        case Ads.bannerAdSettingId:
          return testBannerAdId;

        default:
          return "null";
      }
    } else {
      switch (adsName) {
        // Release mode real Ads id declare here based on enum Ads
        case Ads.bannerAdCollectionDetailsId:
          return isPlatformAndroid
              ? "ca-app-pub-3597374099069159/7387329959"
              : "ios_banner_id";

        case Ads.bannerAdListCollectionId:
          return isPlatformAndroid
              ? "ca-app-pub-3597374099069159/6904114220"
              : "iOS_banner_id";

        case Ads.bannerAdLinksOverviewId:
          return isPlatformAndroid
              ? "ca-app-pub-3597374099069159/3865783692"
              : "iOS_banner_id";

        case Ads.bannerAdSettingId:
          return isPlatformAndroid
              ? "ca-app-pub-3597374099069159/5591032559"
              : "iOS_banner_id";

        default:
          return "null";
      }
    }
  }
}
