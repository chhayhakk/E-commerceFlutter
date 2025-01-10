import 'package:finalflutter/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeline_tile/timeline_tile.dart';

import 'controllers/productcontroller.dart';
import 'controllers/usercontroller.dart';

class OrderDetail extends StatefulWidget {
  final int orderId;
  final int userId;
  const OrderDetail({super.key, required this.orderId, required this.userId});

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

List<String> orderStatuses = [
  'Placed Order',
  'Pending',
  'Shipped',
  'Completed'
];

class _OrderDetailState extends State<OrderDetail> {
  @override
  Widget build(BuildContext context) {
    final orderData = productController.orderDetails.value;
    List<bool> isCompleted = List.generate(orderStatuses.length, (index) {
      if (orderData['status'] == 'Placed Order' && index >= 0)
        return index == 0;
      if (orderData['status'] == 'Pending' && index >= 0) return index <= 1;
      if (orderData['status'] == 'Shipped' && index >= 0) return index <= 2;
      if (orderData['status'] == 'Completed' && index >= 0) return index <= 3;
      return false;
    });
    List<String> productNames = orderData['items']
        .map<String>((item) => item['product_name'] as String)
        .toList();
    String productNamesText = productNames.join(', ');
    int totalQuantity =
        orderData['items'].fold(0, (sum, item) => sum + item['quantity']);
    print(orderData);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                          Get.back();
                        },
                        icon: Icon(Icons.arrow_back, size: 24)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 9),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Track Order',
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
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
                        child:
                            Image(image: AssetImage('assets/products/D6.jpg')),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  '\$ ${orderData['total_price']}',
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
                              'Qty: ${totalQuantity} Pcs',
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
                              orderData['status'], // Order status
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
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Divider(
            thickness: 1,
            color: Colors.grey.shade300,
            indent: 20,
            endIndent: 20,
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order Details',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Expected Delivery Date',
                  style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 18,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Divider(
            thickness: 1,
            color: Colors.grey.shade300,
            indent: 20,
            endIndent: 20,
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order Status',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  children: List.generate(orderStatuses.length, (index) {
                    return TimelineTile(
                      axis: TimelineAxis.vertical,
                      alignment: TimelineAlign.start,
                      isFirst: index == 0,
                      isLast: index == orderStatuses.length - 1,
                      indicatorStyle: IndicatorStyle(
                        width: 25,
                        color: isCompleted[index] ? Colors.brown : Colors.grey,
                        iconStyle: IconStyle(
                          color: Colors.white,
                          iconData:
                              isCompleted[index] ? Icons.check : Icons.check,
                        ),
                      ),
                      endChild: Padding(
                          padding: const EdgeInsets.only(left: 16.0, top: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                orderStatuses[index],
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: isCompleted[index]
                                      ? Colors.black
                                      : Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                              Text('23 Aug 2024, 04:25 PM'),
                              SizedBox(
                                height: 25,
                              ),
                            ],
                          )),
                    );
                  }),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    productController.fetchOrderById(widget.orderId, widget.userId);
  }
}
