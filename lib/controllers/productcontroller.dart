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
  var orders = [].obs;
  RxMap<String, dynamic> orderDetails = RxMap<String, dynamic>({});
  Future<void> fetchProducts(int userId) async {
    final response = await http.get(
        Uri.parse('http://18.143.178.80/pos/get-products?user_id=$userId'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      products.value =
          List<Map<String, dynamic>>.from(data['product_list']).map((product) {
        product['is_favorite'] = product['is_favorite'] == 1;
        return product;
      }).toList();
    }
  }

  Future<void> fetchProductById(int id, int userId) async {
    final response = await http.get(Uri.parse(
        'http://18.143.178.80/api/products-data/$id?user_id=$userId'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      bool isFavorite = (data['is_favorite'] == 1);
      productDetails.value = Map<String, dynamic>.from(data);
      productDetails.value!['is_favorite'] = isFavorite;
      print(productDetails.value);
    }
  }

  void addToCart(int productId, int userId, String size, int quantity) async {
    const String url = 'http://18.143.178.80/api/add_to_cart';
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
        await http.get(Uri.parse('http://18.143.178.80/api/get_cart/$id'));
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
        Uri.parse('http://18.143.178.80/api/update_cart'), // Your API URL
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
          Uri.parse('http://18.143.178.80/api/delete_from_cart'),
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
        // Get.snackbar('Success', 'Successfully delete from cart!');
      } else {
        Get.snackbar('Error', 'Error delete from cart!');
      }
    } catch (e) {
      print("Error delete from cart $e");
    }
  }

  Future<void> addToFavorites(int productId, int userId) async {
    final url = 'http://18.143.178.80/api/add_to_favorite';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'product_id': productId,
        'user_id': userId,
      }),
    );

    if (response.statusCode == 201) {
      final index =
          products.indexWhere((product) => product['id'] == productId);
      if (index != -1) {
        products[index]['is_favorite'] = true;
        products.refresh();
      }
      await fetchProductById(productId, userId);
      print("Product added to favorites");
    } else if (response.statusCode == 400) {
      final message = json.decode(response.body)['message'];
      print(message);
      if (message.contains("already in the favorites")) {
        final index =
            products.indexWhere((product) => product['id'] == productId);
        if (index != -1) {
          products[index]['is_favorite'] = false;
          products.refresh();
        }
      }
    } else {
      // Handle other errors
      print("Error: ${response.body}");
    }
  }

  Future<void> removeFromFavorites(int productId, int userId) async {
    final url = 'http://18.143.178.80/api/remove_from_favorite';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'product_id': productId,
          'user_id': userId,
        }),
      );

      if (response.statusCode == 200) {
        print("Product removed from favorites");
        final index =
            products.indexWhere((product) => product['id'] == productId);
        if (index != -1) {
          products[index]['is_favorite'] = false;
          products.refresh();
        }
        await fetchProductById(productId, userId);
      } else {
        print("Error: ${response.body}");
      }
    } catch (e) {
      print("Exception occurred: $e");
    }
  }

  Future<void> createOrder(int userId, String paymentMethod,
      Map<String, String> shippingAddress) async {
    const String url = 'http://18.143.178.80/api/create_order';

    List<Map<String, dynamic>> cartItems = cart.map((item) {
      return {
        'product_id': item['product_id'],
        'size': item['size'],
        'quantity': item['quantity'],
        'price': item['price'],
      };
    }).toList();
    print('Sending data to backend:');
    print('user_id: $userId');
    print('payment_method: $paymentMethod');
    print('cart_items: $cartItems');
    print('total_price: ${totalPrice.value}');
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'payment_method': paymentMethod,
          'cart_items': cartItems,
          'total_price': totalPrice.value,
          'shipping_address': shippingAddress,
        }),
      );
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');
      if (response.statusCode == 201) {
        final data = json.decode(response.body);

        if (data['message'] == "Order created successfully") {
          // Get.snackbar(
          //   "Success",
          //   "Your order has been placed successfully!",
          //   snackPosition: SnackPosition.BOTTOM,
          //   backgroundColor: Color(0xFF20C31),
          //   colorText: Color(0xFFFFFFFF),
          // );

          cart.clear();
          totalPrice.value = 0.0;
        } else {
          Get.snackbar(
            "Error",
            "Failed to create the order: ${data['error']}",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Color(0xFFD32F2F),
            colorText: Color(0xFFFFFFFF),
          );
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
      } else {
        Get.snackbar(
          "Error",
          "Failed to create the order. Status: ${response.statusCode}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Color(0xFFD32F2F),
          colorText: Color(0xFFFFFFFF),
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to create the order: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Color(0xFFD32F2F),
        colorText: Color(0xFFFFFFFF),
      );
    }
  }

  Future<void> fetchOrder(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('http://18.143.178.80/api/orders/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> orderData = json.decode(response.body);
        orders.assignAll(orderData);
      } else if (response.statusCode == 404) {
        // Get.snackbar(
        //   "No Orders",
        //   "No orders found for this user.",
        //   snackPosition: SnackPosition.BOTTOM,
        //   backgroundColor: Color(0xFF20C31),
        //   colorText: Color(0xFFFFFFFF),
        // );
      } else {
        Get.snackbar(
          "Error",
          "Failed to fetch orders. Status: ${response.statusCode}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Color(0xFFD32F2F),
          colorText: Color(0xFFFFFFFF),
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to fetch orders: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Color(0xFFD32F2F),
        colorText: Color(0xFFFFFFFF),
      );
    }
  }

  Future<void> fetchOrderById(int orderId, int userId) async {
    try {
      final response = await http.get(
        Uri.parse('http://18.143.178.80/api/order/$orderId?user_id=$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> orderData = json.decode(response.body);
        if (orderData.isNotEmpty) {
          orderDetails.value = orderData;
        }
      } else {
        Get.snackbar(
          "Error",
          "Failed to fetch order details. Status: ${response.statusCode}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Color(0xFFD32F2F),
          colorText: Color(0xFFFFFFFF),
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to fetch order details: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Color(0xFFD32F2F),
        colorText: Color(0xFFFFFFFF),
      );
    }
  }
}
