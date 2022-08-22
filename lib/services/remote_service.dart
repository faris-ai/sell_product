import 'package:http/http.dart' as http;
import 'package:sell_product/models/product.dart';

class RemoteService {
  Future<List<Product>?> getProducts() async {
    var client = http.Client();

    var uri = Uri.parse('https://dummyjson.com/products');
    var response = await client.get(uri);

    if (response.statusCode == 200) {
      var json = response.body;
      return allFromJson(json).products;
    }
    return null;
  }
}
