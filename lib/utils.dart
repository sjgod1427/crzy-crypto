import 'package:crzy_crypto/controller/assets_controller.dart';
import 'package:crzy_crypto/services/http_requests.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

Future<void> registerServices() async {
  Get.put(HTTPService());
}

Future<void> registerController() async {
  Get.put(AssetsController());
}

String getCryptoImageURL(String name) {
  return "https://raw.githubusercontent.com/ErikThiart/cryptocurrency-icons/master/128/${name.toLowerCase()}.png";
}
