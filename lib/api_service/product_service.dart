import 'package:dio/dio.dart';
import 'package:productstore/Entity/product.dart';
import 'package:productstore/api_service/api_urls.dart';

class ProductServices {
  static Future<List<Product>> fetchProductList() async {
    final Dio dio = Dio();
    List<Product> products = [];
    Response response = await dio.get(APIURL.BOOKLIST);
    for (var data in response.data) {
      products.add(Product.fromJson(data));
    }
    return products ?? [];
  }
}
