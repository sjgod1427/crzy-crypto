import 'dart:convert';

import 'package:crzy_crypto/models/api_response.dart';
import 'package:crzy_crypto/models/coin_data.dart';
import 'package:crzy_crypto/models/tracked_asset.dart';
import 'package:crzy_crypto/services/http_requests.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AssetsController extends GetxController {
  RxList<CoinData> coinData = <CoinData>[].obs;
  RxBool loading = false.obs;
  RxList<TrackedAsset> trackedAssets = <TrackedAsset>[].obs;

  @override
  void onInit() {
    super.onInit();
    _getAssets();
    _loadStoredAssets();
  }

  Future<void> _getAssets() async {
    loading.value = true;
    HTTPService httpService = Get.find();
    var responseData = await httpService.get("currencies");
    CurrenciesListAPIResponse currenciesListAPIResponse =
        CurrenciesListAPIResponse.fromJson(responseData);
    coinData.value = currenciesListAPIResponse.data ?? [];
    loading.value = false;
  }

  Future<void> addTrackedAsset(String name, double amount) async {
    trackedAssets.add(TrackedAsset(name: name, amount: amount));
    List<String> data =
        trackedAssets.map((asset) => jsonEncode(asset)).toList();
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setStringList('tracked_assets', data);
  }

  Future<void> _loadStoredAssets() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String>? data = await preferences.getStringList('tracked_assets');
    if (data != null) {
      trackedAssets.value = data
          .map(
            (e) => TrackedAsset.fromJson(
              jsonDecode(e),
            ),
          )
          .toList();
    }
  }

  double getPortfolioValue() {
    if (coinData.isEmpty) {
      return 0;
    }
    if (trackedAssets.isEmpty) {
      return 0;
    }
    double value = 0;
    for (TrackedAsset asset in trackedAssets) {
      value += getAssetPrice(asset.name!) * asset.amount!;
    }
    return value;
  }

  double getAssetPrice(String name) {
    CoinData? data = getCoinData(name);
    return data?.values?.uSD?.price?.toDouble() ?? 0;
  }

  CoinData? getCoinData(String name) {
    return coinData.firstWhereOrNull((e) => e.name == name);
  }
}
