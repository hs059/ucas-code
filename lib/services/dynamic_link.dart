 import '../controller/app_controler.dart';
import 'package:dynamicapp/dl_screen.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';

class DynamicLink {
  AppControler appControler = Get.find();

  Future<void> retrieveDynamicLink() async {
    try {
      Uri? deepLink;
      FirebaseDynamicLinks.instance.getInitialLink().then((data) {
        deepLink = data?.link;
        if (deepLink != null && !appControler.dlFlag) {
          appControler.setDlFlag(true);
          Get.to(() => DLScreen('onClose__ prodcut'));
        }
      });

      FirebaseDynamicLinks.instance.onLink(
          onSuccess: (PendingDynamicLinkData? dynamicLink) async {
        final Uri deepLink = dynamicLink!.link;
        String? id = deepLink.queryParameters['id'];
        print(' id....................... $id');
        Get.to(() => DLScreen('onResume__ prodcut'));
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<Uri> createDynamicLink(String id) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://dynamicucas.page.link',
      link: Uri.parse('https://dynamicucas.page.link.com/?id=$id'),
      androidParameters: AndroidParameters(
        packageName: 'com.s7s.dynamicapp',
        minimumVersion: 1,
      ),
      // iosParameters: IosParameters(
      //   bundleId: 'your_ios_bundle_identifier',
      //   minimumVersion: '1',
      //   appStoreId: 'your_app_store_id',
      // ),
      socialMetaTagParameters: SocialMetaTagParameters(
          title: 'title',
          description: "description",
          imageUrl: Uri.parse(
              'https://upload.wikimedia.org/wikipedia/commons/7/73/Lion_waiting_in_Namibia.jpg')),
    );
    var dynamicUrl = await parameters.buildUrl();
    ShortDynamicLink shortDynamicLink = await parameters.buildShortLink();
    Uri shortUrl = shortDynamicLink.shortUrl;
    Share.share(shortUrl.toString(), subject: 'eat');
    return dynamicUrl;
  }
}
