import 'package:finalflutter/controllers/productcontroller.dart';
import 'package:finalflutter/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/usercontroller.dart';

class ProductDetail extends StatefulWidget {
  final int productId;
  const ProductDetail({super.key, required this.productId});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final ProductController productController = Get.put(ProductController());
  final UserController userController = Get.find<UserController>();
  @override
  void initState() {
    super.initState();
    productController.fetchProductById(widget.productId);
  }

  List<String> size = ['S', 'M', 'L', 'XL', 'XXL', '3XL'];
  String selectedItem = 'S';
  @override
  Widget build(BuildContext context) {
    final productDetail = productController.productDetails.value!;
    final userData = userController.userData.value!;
    int id = userData['id'];
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                  height: 540,
                  width: double.infinity,
                  color: Color(0xFFEDEDED),
                  child: Image(
                    image:
                        AssetImage('assets/products/${productDetail['image']}'),
                    fit: BoxFit.contain,
                    width: 300,
                    height: 300,
                  )),
              Positioned(
                top: 50,
                left: 20,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(Icons.arrow_back, size: 24)),
                ),
              ),
              Positioned(
                top: 50,
                right: 20,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.favorite_outline, size: 24),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      productDetail['cat_name'],
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 24,
                          color: Color(0xFFFBAE23),
                        ),
                        Text(
                          '4.5',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(height: 15),
                Text(
                  productDetail?['name'],
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: 15),
                Text('\$${productDetail?['price']}',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 21,
                    )),
                SizedBox(
                  height: 10,
                ),
                Text(productDetail?['description'],
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                    )),
                SizedBox(
                  height: 5,
                ),
                Divider(
                  color: Colors.grey.shade300,
                  thickness: 1,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Select Size',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 5),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: size.map((item) {
                      final bool isSelected = item == selectedItem;
                      return Flexible(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedItem = item;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.brown : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 4.0),
                                child: Center(
                                  child: Text(
                                    item,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList()),
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        productController.addToCart(productDetail['id'],
                            userData['id'], selectedItem, 1);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF704F38),
                        elevation: 5,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_shopping_cart,
                            size: 26,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Add to Cart',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontSize: 20,
                            ),
                          )
                        ],
                      )),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
