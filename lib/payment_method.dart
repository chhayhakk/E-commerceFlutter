import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentMethod extends StatefulWidget {
  const PaymentMethod({super.key});

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
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
                      'Payment Methods',
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
                    trailing: InkWell(
                      onTap: () {},
                      child: Text(
                        'Link',
                        style: TextStyle(
                            color: Colors.brown,
                            fontWeight: FontWeight.normal,
                            fontSize: 15),
                      ),
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
                        trailing: InkWell(
                          child: Text(
                            'Link',
                            style: TextStyle(
                                color: Colors.brown,
                                fontWeight: FontWeight.normal,
                                fontSize: 15),
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.store,
                          size: 24,
                          color: Colors.green,
                        ),
                        title: Text(
                          'Google Play',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                        trailing: InkWell(
                          child: Text(
                            'Link',
                            style: TextStyle(
                                color: Colors.brown,
                                fontWeight: FontWeight.normal,
                                fontSize: 15),
                          ),
                        ),
                      ),
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
                        trailing: InkWell(
                          child: Text(
                            'Link',
                            style: TextStyle(
                                color: Colors.brown,
                                fontWeight: FontWeight.normal,
                                fontSize: 15),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
