import 'dart:ui';

import 'package:finalflutter/models/products.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductController extends GetxController {
  final products = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  var productDetails = Rx<Map<String, dynamic>?>(null);
  var cart = <Map<String, dynamic>>[].obs;
  var totalPrice = 0.0.obs;
  Future<void> fetchProducts() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.204:5000/pos/get-products'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      products.value = List<Map<String, dynamic>>.from(data['product_list']);
    }
  }

  Future<void> fetchProductById(int id) async {
    final response = await http
        .get(Uri.parse('http://192.168.1.204:5000/api/products-data/$id'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      productDetails.value = Map<String, dynamic>.from(data);
      print(productDetails.value);
    }
  }

  void addToCart(int productId, int userId, String size, int quantity) async {
    const String url = 'http://192.168.1.204:5000/api/add_to_cart';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'product_id': productId,
          'user_id': userId,
          'size': size,
          'quantity': quantity,
        }),
      );

      print({
        'product_id': productId,
        'user_id': userId,
        'size': size,
        'quantity': quantity,
      });

      if (response.statusCode == 201) {
        final data = json.decode(response.body);

        if (data['message'] == "Product added to cart") {
          // Get.snackbar(
          //   "Success",
          //   "Product added to cart successfully!",
          //   snackPosition: SnackPosition.BOTTOM,
          //   backgroundColor: Color(0xFF20C31),
          //   colorText: Color(0xFFFFFFFF),
          // );
        } else if (data['error'] != null) {
          // Handling error response from backend
          // Get.snackbar(
          //   "Error",
          //   "Unexpected response: ${data['error']}",
          //   snackPosition: SnackPosition.BOTTOM,
          //   backgroundColor: Color(0xFFD32F2F),
          //   colorText: Color(0xFFFFFFFF),
          // );
        }
      } else if (response.statusCode == 400) {
        final data = json.decode(response.body);
        Get.snackbar(
          "Error",
          "Validation error: ${data['error']}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Color(0xFFD32F2F),
          colorText: Color(0xFFFFFFFF),
        );
      } else if (response.statusCode == 500) {
        // Backend internal error handling
        Get.snackbar(
          "Error",
          "Internal server error. Please try again later.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Color(0xFFD32F2F),
          colorText: Color(0xFFFFFFFF),
        );
      } else {
        // Handle other unexpected status codes
        Get.snackbar(
          "Error",
          "Failed to add product to cart. Status: ${response.statusCode}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Color(0xFFD32F2F),
          colorText: Color(0xFFFFFFFF),
        );
      }
    } catch (e) {
      // Handle connection or parsing errors
      Get.snackbar(
        "Error",
        "Failed to add product to cart: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Color(0xFFD32F2F),
        colorText: Color(0xFFFFFFFF),
      );
    }
  }

  Future<void> fetchAddToCart(int id) async {
    final response =
        await http.get(Uri.parse('http://192.168.1.204:5000/api/get_cart/$id'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data is Map) {
        final cartData = data['cart'];

        if (cartData is List) {
          cart.value = List<Map<String, dynamic>>.from(cartData);
        }
        _updateTotalPrice();
      }
      print(cart.value);
    } else {
      print('Failed to load cart');
    }
  }

  void _updateTotalPrice() {
    double calculatedTotalPrice = 0.0;
    for (var item in cart) {
      double price = double.tryParse(item['price'].toString()) ?? 0.0;
      int qty = item['quantity'] is int ? item['quantity'] : 0;
      calculatedTotalPrice += price * qty;
    }
    totalPrice.value = calculatedTotalPrice;
  }

  Future<void> updateCartQuantity(
      int productId, String size, int userId, int quantity) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.204:5000/api/update_cart'), // Your API URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'product_id': productId,
          'user_id': userId,
          'size': size,
          'quantity': quantity,
        }),
      );

      if (response.statusCode == 200) {
        final index = cart.indexWhere(
          (item) => item['product_id'] == productId && item['size'] == size,
        );
        if (index != -1) {
          cart[index]['quantity'] = quantity;
          cart.refresh();
          _updateTotalPrice();
        }
      }
    } catch (e) {
      print("Error updating cart: $e");
    }
  }

  Future<void> deleteFromCart(int productId, String size, int userId) async {
    try {
      final response = await http.post(
          Uri.parse('http://192.168.1.204:5000/api/delete_from_cart'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'product_id': productId,
            'user_id': userId,
            'size': size,
          }));
      if (response.statusCode == 200) {
        cart.removeWhere(
            (item) => item['product_id'] == productId && item['size'] == size);
        cart.refresh();
        _updateTotalPrice();
        Get.snackbar('Success', 'Successfully delete from cart!');
      } else {
        Get.snackbar('Error', 'Error delete from cart!');
      }
    } catch (e) {
      print("Error delete from cart $e");
    }
  }
}
