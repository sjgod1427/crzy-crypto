import 'package:crzy_crypto/controller/assets_controller.dart';
import 'package:crzy_crypto/models/api_response.dart';
import 'package:crzy_crypto/services/http_requests.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class AddAssetDialogController extends GetxController {
  RxBool loading = true.obs;
  RxList<String> assets = <String>[].obs;
  RxString selectedvalue = "".obs;
  RxDouble assetValue = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _getAssets();
  }

  Future<void> _getAssets() async {
    loading.value = true;
    HTTPService httpService = Get.find();
    var responseData = await httpService.get('currencies');
    CurrenciesListAPIResponse currenciesListAPIResponse =
        CurrenciesListAPIResponse.fromJson(responseData);
    currenciesListAPIResponse.data?.forEach((conin) {
      assets.add(conin.name!);
    });
    selectedvalue.value = assets.first;
    loading.value = false;
  }
}

class AddAssetDialogue extends StatelessWidget {
  final controller = Get.put(AddAssetDialogController());

  AddAssetDialogue({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Center(
        child: Material(
          child: Container(
            height: MediaQuery.sizeOf(context).height * 0.40,
            width: MediaQuery.sizeOf(context).width * 0.80,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.white),
            child: _buildUI(context),
          ),
        ),
      ),
    );
  }

  Widget _buildUI(BuildContext context) {
    if (controller.loading.isTrue) {
      return const Center(
        child:
            SizedBox(height: 30, width: 30, child: CircularProgressIndicator()),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DropdownButton(
                  value: controller.selectedvalue.value,
                  items: controller.assets
                      .map((asset) =>
                          DropdownMenuItem(value: asset, child: Text(asset)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.selectedvalue.value = value;
                    }
                  }),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  controller.assetValue.value = double.parse(value);
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              MaterialButton(
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    AssetsController assetsController = Get.find();
                    assetsController.addTrackedAsset(
                        controller.selectedvalue.value,
                        controller.assetValue.value);
                    Get.back();
                    print(controller.assetValue.value);
                  },
                  child: const Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        ),
      );
    }
  }
}
