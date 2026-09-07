import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:businesses_4_sale/config/app_config.dart';

class ShareService {
  Future<void> shareApp() {
    final text = StringBuffer()
      ..writeln('Businesses 4 Sale — list or browse businesses for sale.')
      ..writeln(AppConfig.websiteUrl)
      ..writeln('Android: ${AppConfig.playStoreUrl}')
      ..writeln('iOS: ${AppConfig.appStoreUrl}');

    return SharePlus.instance.share(
      ShareParams(
        text: text.toString(),
        subject: AppConfig.appName,
      ),
    );
  }

  static String storeUrlForPlatform() {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return AppConfig.appStoreUrl;
    }
    return AppConfig.playStoreUrl;
  }
}
