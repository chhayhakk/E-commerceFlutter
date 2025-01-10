import 'package:finalflutter/controllers/usercontroller.dart';
import 'package:finalflutter/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'bottomNavigatorMenu.dart';
import 'controllers/productcontroller.dart';
import 'mycart.dart';

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

final ProductController productController = Get.put(ProductController());
final UserController userController = Get.put(UserController());
Widget PopularCategory(String myText, bool isActive) {
  return Container(
    width: 80,
    height: 35,
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
    margin: const EdgeInsets.only(left: 5, right: 5),
    decoration: BoxDecoration(
        border: Border.all(
            width: 1,
            color: isActive ? const Color(0xFF704F38) : Colors.grey.shade300,
            style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(20),
        color: isActive ? const Color(0xFF704F38) : const Color(0xFFFFFFFF)),
    child: Center(
      child: Text(
        myText,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.normal,
        ),
      ),
    ),
  );
}

class _ShopState extends State<Shop> {
  int _selectedCatIndex = 0;
  final userData = userController.userData.value!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 1,
                          style: BorderStyle.solid,
                          color: Colors.grey.shade300,
                        )),
                    child: IconButton(
                        onPressed: () {
                          Get.offAll(
                              () => NavigationMenu(userId: userData['id']));
                        },
                        icon: Icon(Icons.arrow_back, size: 24)),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 1,
                          style: BorderStyle.solid,
                          color: Colors.grey.shade300,
                        )),
                    child: IconButton(
                        onPressed: () async {
                          final productController =
                              Get.find<ProductController>();
                          await productController
                              .fetchAddToCart(userData['id']);
                          Get.to(() => MyCart(userId: userData['id']));
                        },
                        icon: Icon(Icons.add_shopping_cart, size: 24)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 9),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Shop',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCatIndex = 0;
                      });
                    },
                    child: PopularCategory('All', _selectedCatIndex == 0),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCatIndex = 1;
                      });
                    },
                    child: PopularCategory('Newest', _selectedCatIndex == 1),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCatIndex = 2;
                      });
                    },
                    child: PopularCategory('Popular', _selectedCatIndex == 2),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCatIndex = 3;
                      });
                    },
                    child: PopularCategory('Man', _selectedCatIndex == 3),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCatIndex = 4;
                      });
                    },
                    child: PopularCategory('Women', _selectedCatIndex == 4),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 30),
          Expanded(
              child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: productController.products.length,
                  itemBuilder: (context, index) {
                    final product = productController.products[index];
                    bool isFavorite = product['is_favorite'];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () async {
                            final productController =
                                Get.find<ProductController>();
                            productController.productDetails.value = null;
                            await productController.fetchProductById(
                                product['id'], userData['id']);

                            Get.to(
                                () => ProductDetail(productId: product['id']));
                          },
                          child: Stack(children: [
                            Container(
                                width: double.infinity,
                                height: 160,
                                decoration: BoxDecoration(
                                  color: Color(0xFFF0F0F0),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image(
                                    image: AssetImage(
                                        'assets/products/${product['image']}'),
                                    fit: BoxFit.contain,
                                  ),
                                )),
                            Positioned(
                              top: 5,
                              right: 5,
                              child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white60,
                                  ),
                                  child: Center(
                                      child: IconButton(
                                    onPressed: () {
                                      if (isFavorite) {
                                        productController.removeFromFavorites(
                                            product['id'], userData['id']);
                                      } else {
                                        productController.addToFavorites(
                                            product['id'], userData['id']);
                                      }
                                    },
                                    icon: Icon(
                                      isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      size: 20,
                                      color:
                                          isFavorite ? Colors.red : Colors.grey,
                                    ),
                                    padding: EdgeInsets.zero,
                                  ))),
                            )
                          ]),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                product['name'],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.star,
                                      size: 14, color: Colors.red),
                                  Text(
                                    '4.9',
                                    style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 14),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('\$${product['price']}',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                              )),
                        )
                      ],
                    );
                  },
                ),
              ),
            ],
          ))
        ],
      ),
    );
  }

  @override
  void initState() {
    productController.fetchProducts(userData['id']);
  }
}
