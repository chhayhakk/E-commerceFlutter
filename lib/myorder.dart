import 'package:finalflutter/bottomNavigatorMenu.dart';
import 'package:finalflutter/controllers/productcontroller.dart';
import 'package:finalflutter/controllers/usercontroller.dart';
import 'package:finalflutter/order_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyOrder extends StatefulWidget {
  const MyOrder({super.key});

  @override
  State<MyOrder> createState() => _MyOrderState();
}

UserController userController = Get.put(UserController());
ProductController productController = Get.put(ProductController());

class _MyOrderState extends State<MyOrder> {
  final userData = userController.userData.value!;
  String selectedTab = 'Pending';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
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
                Padding(
                  padding: const EdgeInsets.only(top: 9),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'My Orders',
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedTab = 'Pending';
                  });
                },
                child: Text(
                  'Pending',
                  style: TextStyle(
                    color:
                        selectedTab == 'Pending' ? Colors.brown : Colors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedTab = 'Completed';
                  });
                },
                child: Text(
                  'Completed',
                  style: TextStyle(
                    color:
                        selectedTab == 'Completed' ? Colors.brown : Colors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            thickness: 1,
            color: Colors.grey.shade400,
          ),
          SizedBox(
            height: 15,
          ),
          Expanded(
            child: Obx(() {
              if (productController.orders.isEmpty) {
                return Center(
                  child: Text(
                    'You have no order',
                    style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 18,
                        fontWeight: FontWeight.normal),
                  ),
                );
              }
              var filteredOrders = productController.orders.where((order) {
                if (selectedTab == 'Pending') {
                  return order['status'] == 'Pending' ||
                      order['status'] == 'Shipped';
                } else if (selectedTab == 'Completed') {
                  return order['status'] == 'Completed';
                }
                return false;
              }).toList();

              return ListView.builder(
                itemCount: filteredOrders.length,
                itemBuilder: (context, index) {
                  var order = filteredOrders[index];
                  var firstItem = order['items'][0];
                  var productImage = firstItem['image'];
                  var orderDate = order['created_at'];
                  var orderStatus = order['status'];

                  List<String> productNames = order['items']
                      .map<String>((item) => item['product_name'] as String)
                      .toList();
                  String productNamesText = productNames.join(', ');

                  var totalPrice = order['total_price'];

                  return Column(
                    children: [
                      Card(
                        color: Colors.white,
                        margin: EdgeInsets.only(right: 15, left: 15),
                        elevation: 3,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20, bottom: 20, left: 20),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        'assets/products/$productImage',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                productNamesText,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Text(
                                                '\$ $totalPrice',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            'Delivery on $orderDate',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 18,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            orderStatus, // Order status
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 18,
                                              color: Colors.grey.shade500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  right: 15, left: 15, bottom: 15),
                              width: double.infinity,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.brown,
                              ),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () async {
                                    if (selectedTab == 'Pending') {
                                      await productController.fetchOrderById(
                                          order['order_id'], userData['id']);
                                      Get.to(() => OrderDetail(
                                            orderId: order['order_id'],
                                            userId: userData['id'],
                                          ));
                                    }
                                  },
                                  child: Text(
                                    selectedTab == 'Completed'
                                        ? 'Leave Review'
                                        : 'Track Order',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    productController
        .fetchOrder(userData['id']); // Fetch the orders when the page loads
  }
}
