import 'package:crzy_crypto/authentication/services.dart';
import 'package:crzy_crypto/controller/assets_controller.dart';
import 'package:crzy_crypto/main.dart';
import 'package:crzy_crypto/models/tracked_asset.dart';
import 'package:crzy_crypto/pages/details_page.dart';
import 'package:crzy_crypto/pages/login.dart';
import 'package:crzy_crypto/utils.dart';
import 'package:crzy_crypto/widgets/add_asset_dialogue.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class HomePage extends StatelessWidget {
  AssetsController assetsController = Get.find();
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(context), body: _buildWidget(context));
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      title: const CircleAvatar(
        backgroundImage:
            NetworkImage('https://randomuser.me/api/portraits/men/1.jpg'),
      ),
      actions: [
        IconButton(
            onPressed: () {
              Get.dialog(AddAssetDialogue());
            },
            icon: const Icon(Icons.add)),
        IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Get.offAll(LoginScreen());
            },
            icon: const Icon(Icons.logout)),
      ],
    );
  }

  Widget _buildWidget(BuildContext context) {
    return SafeArea(
        child: Obx(
      () => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [_portfolioValue(context), _trackedAssetsList(context)],
        ),
      ),
    ));
  }

  Widget _portfolioValue(BuildContext context) {
    return Container(
        width: MediaQuery.sizeOf(context).width,
        margin: EdgeInsets.symmetric(
          vertical: MediaQuery.sizeOf(context).height * 0.03,
        ),
        child: Text.rich(
            textAlign: TextAlign.center,
            TextSpan(children: [
              const TextSpan(
                  text: "\$",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  )),
              TextSpan(
                  text:
                      "${assetsController.getPortfolioValue().toStringAsFixed(2)}\n",
                  style: const TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.w500,
                  )),
              const TextSpan(
                  text: "Portfolio Value",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ))
            ])));
  }

  Widget _trackedAssetsList(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).width * 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.05,
            child: const Text(
              "Portfolio",
              style: TextStyle(
                  fontSize: 10,
                  color: Colors.black38,
                  fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.65,
            width: MediaQuery.sizeOf(context).width,
            child: ListView.builder(
              itemCount: assetsController.trackedAssets.length,
              itemBuilder: (context, index) {
                TrackedAsset trackedAsset =
                    assetsController.trackedAssets[index];
                return ListTile(
                  leading: Image.network(getCryptoImageURL(trackedAsset.name!)),
                  title: Text(trackedAsset.name!),
                  subtitle: Text(
                      "USD:${assetsController.getAssetPrice(trackedAsset.name!).toStringAsFixed(2)} "),
                  trailing: Text("${trackedAsset.amount}"),
                  onTap: () {
                    Get.to(DetailsPage(
                        coin:
                            assetsController.getCoinData(trackedAsset.name!)!));
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
