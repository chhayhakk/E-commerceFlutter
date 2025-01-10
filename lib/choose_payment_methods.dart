import 'package:finalflutter/controllers/productcontroller.dart';
import 'package:finalflutter/controllers/usercontroller.dart';
import 'package:finalflutter/paypal.dart';
import 'package:finalflutter/successful_payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:get/get.dart';
import 'package:uni_links/uni_links.dart';

class ChoosePaymentMethods extends StatefulWidget {
  const ChoosePaymentMethods({super.key});

  @override
  State<ChoosePaymentMethods> createState() => _ChoosePaymentMethodsState();
}

var _selectPayment = 'paypal';

class _ChoosePaymentMethodsState extends State<ChoosePaymentMethods> {
  @override
  void initState() {
    super.initState();
    _initDeepLink();
  }

  void _initDeepLink() async {
    final initialLink = await getInitialLink();
    if (initialLink != null) {
      _handleDeepLink(initialLink);
    }

    // Listen to any incoming deep link after app launch
    linkStream.listen((String? link) {
      if (link != null) {
        _handleDeepLink(link);
      }
    });
  }

  void _handleDeepLink(String link) {
    if (link.contains('payment-success')) {
      Get.offAll(() => SuccessfulPayment(),
          transition: Transition.fadeIn, duration: Duration(milliseconds: 10));
    } else {
      print("Payment was canceled or failed.");
    }
  }

  ProductController productController = Get.put(ProductController());
  UserController userController = Get.put(UserController());
  void _handlePaypalPayment(BuildContext context) {
    final cartData = productController.cart.value;
    final userData = userController.userData.value!;

    List<Map<String, dynamic>> items = [];
    for (var item in cartData) {
      items.add({
        "name": item['product_name'],
        "quantity": item['quantity'].toString(),
        "price": item['price'],
        "currency": "USD",
      });
    }
    final Map<String, String> shippingAddress = {
      "recipient_name": userData['name'],
      "line1": "Cambodia",
      "line2": "",
      "city": "Phnom Penh",
      "country_code": "KH",
      "postal_code": "120012",
      "phone": userData['phone'],
      "state": "Phnom Penh"
    };
    final totalPrice =
        double.parse(productController.totalPrice.value.toString())
            .toStringAsFixed(2);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => UsePaypal(
          sandboxMode: true,
          clientId:
              "Aft42vJ2GOGTBOq2rGU5C30The6fKDE34yznpvkdcyUpYz2RGliuacx0KacCPL2Woq3ViNi8REiaGMQ2",
          secretKey:
              "ECfYdk-raOk7A3C52E73pPetm4BkApY-CwnDxTMEByII-PEjEDNHgHLaZEr9rNPeGcQJG_GFKzT__8wY",
          returnURL: "finalflutter://payment-success", // The deep link
          cancelURL: "https://samplesite.com/cancel",
          transactions: [
            {
              "amount": {
                "total": totalPrice,
                "currency": "USD",
                "details": {
                  "subtotal": totalPrice,
                  "shipping": '0',
                  "shipping_discount": 0
                }
              },
              "description": "The payment transaction description.",
              "item_list": {
                "items": items,
                "shipping_address": {
                  "recipient_name": userData['name'],
                  "line1": "Cambodia",
                  "line2": "",
                  "city": "Phnom Penh",
                  "country_code": "KH",
                  "postal_code": "120012",
                  "phone": userData['phone'],
                  "state": "Texas"
                },
              }
            }
          ],
          note: "Contact us for any questions on your order.",
          onSuccess: (Map params) async {
            await productController.createOrder(
                userData['id'], _selectPayment, shippingAddress);
            Future.delayed(Duration(microseconds: 1), () {
              Get.off(
                () => SuccessfulPayment(),
                transition: Transition.fadeIn,
              );
            });
          },
          onError: (error) {
            print("onError: $error");
          },
          onCancel: (params) {
            print('cancelled: $params');
          },
        ),
      ),
    );
  }

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
                      'Checkout',
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
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Credit & Debit Card',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                Card(
                  color: Colors.white,
                  child: ListTile(
                    leading: Icon(
                      Icons.credit_card,
                      size: 22,
                      color: Colors.brown,
                    ),
                    title: Text(
                      'Add New Card',
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'More Payment Options',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Card(
                  color: Colors.white,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.paypal,
                          size: 24,
                          color: Colors.blue.shade900,
                        ),
                        title: Text(
                          'Paypal',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                        trailing: Radio(
                            activeColor: Colors.brown,
                            value: 'paypal',
                            groupValue: _selectPayment,
                            onChanged: (value) {
                              setState(() {
                                _selectPayment = value!;
                              });
                            }),
                      ),
                      ListTile(
                          leading: Icon(
                            Icons.store,
                            size: 24,
                            color: Colors.green,
                          ),
                          title: Text(
                            'Google Pay',
                            style: TextStyle(color: Colors.grey.shade500),
                          ),
                          trailing: Radio(
                              activeColor: Colors.brown,
                              value: 'google pay',
                              groupValue: _selectPayment,
                              onChanged: (value) {
                                setState(() {
                                  _selectPayment = value!;
                                });
                              })),
                      ListTile(
                        leading: Icon(
                          Icons.apple,
                          size: 24,
                          color: Colors.black,
                        ),
                        title: Text(
                          'Apple Pay',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                        trailing: Radio(
                            activeColor: Colors.brown,
                            value: 'apple pay',
                            groupValue: _selectPayment,
                            onChanged: (value) {
                              setState(() {
                                _selectPayment = value!;
                              });
                            }),
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                ),
                onPressed: () {
                  if (_selectPayment == 'paypal') {
                    _handlePaypalPayment(context);
                  } else {}
                },
                child: Text(
                  'Continue to Payment',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                )),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
