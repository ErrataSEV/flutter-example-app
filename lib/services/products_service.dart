import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:form_validation/models/models.dart';

class ProductsService extends ChangeNotifier {
  final String _baseUrl = 'fluttter-varios-abbf0-default-rtdb.firebaseio.com';
  final List<Product> products = [];
  final _storage = FlutterSecureStorage();

  /// Copy of actual Product
  late Product selectedProduct;
  bool isLoading = true;
  bool isSaving = false;
  File? newPicture;

  ProductsService() {
    loadProducts();
  }

  Future<List<Product>> loadProducts() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'products.json', {
      'auth': await _storage.read(key: 'token') ?? ''
    });
    final resp = await http.get(url);

    final Map<String, dynamic> productsMap = jsonDecode(resp.body);

    productsMap.forEach((key, value) {
      final tempProduct = Product.fromMap(value);
      tempProduct.id = key;
      products.add(tempProduct);
    });

    isLoading = false;
    notifyListeners();
    return products;
  }

  Future saveOrCreateProduct(Product product) async {
    isSaving = true;
    notifyListeners();

    if (product.id == null) {
      await createProduct(product);
    } else {
      await updateProduct(product);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'products/${product.id}.json', {
      'auth': await _storage.read(key: 'token') ?? ''
    });
    await http.put(url, body: product.toJson());
    // final resp = await http.put(url, body: product.toJson());
    // final decodedData = resp.body;

    // final productToUpdate = products.firstWhere((p) => p.id == product.id);
    // productToUpdate.name = product.name;
    // productToUpdate.price = product.price;
    // productToUpdate.available = product.available;
    // productToUpdate.picture = product.picture;

    final index = products.indexWhere((p) => p.id == product.id);
    products[index] = product;
    notifyListeners();

    return product.id!;
  }

  Future<String> createProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'products.json', {
      'auth': await _storage.read(key: 'token') ?? ''
    });
    final resp = await http.post(url, body: product.toJson());
    final decodedData = json.decode(resp.body);

    product.id = decodedData['name'];
    products.add(product);
    notifyListeners();

    return product.id!;
  }

  void updateSelectedProductImage(String path) {
    
    selectedProduct.picture = path;
    newPicture = File.fromUri(Uri(path: path));

    notifyListeners();

  }

  Future<String?> uploadImage() async {
    if (newPicture == null) {
      return null;
    }

    isSaving = true;
    notifyListeners();

    
    final url = Uri.parse(
      "https://api.cloudinary.com/v1_1/dsn8cnadp/image/upload?upload_preset=x6kng3j6"
    );

    final imageUploadRequest = http.MultipartRequest('post', url);
    final file = await http.MultipartFile.fromPath('file', newPicture!.path);
    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      return null;
    }

    newPicture = null;
    final decodeData = json.decode(resp.body);

    return decodeData['secure_url'];
  }
}
