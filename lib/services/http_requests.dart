import 'package:crzy_crypto/models/const.dart';
import 'package:dio/dio.dart';

class HTTPService {
  HTTPService() {
    _configureDio();
  }
  final Dio _dio = Dio();

  void _configureDio() {
    _dio.options = BaseOptions(
      baseUrl: "https://api.cryptorank.io/v1/",
      queryParameters: {
        "api_key": CRYPTO_RANK_API_KEY,
      },
    );
  }

  Future<dynamic> get(String path) async {
    try {
      Response response = await _dio.get(path);
      return response.data;
    } catch (e) {
      print(e);
    }
  }
}
