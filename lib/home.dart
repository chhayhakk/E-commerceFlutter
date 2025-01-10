import 'package:finalflutter/complete_profile.dart';
import 'package:finalflutter/controllers/productcontroller.dart';
import 'package:finalflutter/mycart.dart';
import 'package:finalflutter/product_detail.dart';
import 'package:finalflutter/profile.dart';
import 'package:finalflutter/signin.dart';
import 'package:finalflutter/signup.dart';
import 'package:finalflutter/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  final Map<String, dynamic> userData;
  const Home({super.key, required this.userData});

  @override
  State<Home> createState() => _HomeState();
}

final imgList = [
  'assets/images/A1.jpg',
  'assets/images/A2.jpg',
  'assets/images/A3.jpg',
  'assets/images/A4.jpg',
  'assets/images/A5.jpg',
  'assets/images/A6.jpg',
];
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

int _selectedCatIndex = 0;
Widget MyCategory(FaIcon myIcon, String myCategory) {
  return Column(
    children: [
      Container(
        width: 75,
        height: 75,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFF6F1EC),
        ),
        child: Center(
          child: myIcon,
        ),
      ),
      const SizedBox(
        height: 5,
      ),
      Text(
        myCategory,
        style: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.normal, fontSize: 16),
      )
    ],
  );
}

int _current = 0;
final List<Widget> imageSliders = imgList.map((item) {
  return Container(
    margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
    width: double.infinity,
    height: 200,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color(0xFFEDE4DA)),
    child: Row(
      children: [
        Flexible(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'New Collection',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'Discount 50% for',
                  style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 18,
                      fontWeight: FontWeight.normal),
                ),
                Text(
                  'the first transaction',
                  style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 18,
                      fontWeight: FontWeight.normal),
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF704F38),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () {},
                    child: const Text(
                      'Shop Now',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ))
              ],
            ),
          ),
        ),
        const Expanded(
          flex: 1,
          child: Image(
            image: AssetImage('assets/images/model.png'),
            width: 180,
            height: 200,
            fit: BoxFit.cover,
          ),
        )
      ],
    ),
  );
}).toList();
final CarouselSliderController _controller = CarouselSliderController();
final ProductController productController = Get.put(ProductController());

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 45),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Location',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_pin,
                          size: 22,
                          color: Colors.brown,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'New York, USA',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        Icon(Icons.arrow_drop_down)
                      ],
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Color(0xFFF0F0F0)),
                      child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.notifications_on_sharp,
                            size: 28,
                            color: Color(0xFF494141),
                          )),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Color(0xFFF0F0F0)),
                      child: IconButton(
                          onPressed: () async {
                            final productController =
                                Get.find<ProductController>();
                            await productController
                                .fetchAddToCart(widget.userData['id']);
                            Get.to(() => MyCart(userId: widget.userData['id']));
                          },
                          icon: const Icon(
                            Icons.add_shopping_cart,
                            size: 28,
                            color: Color(0xFF494141),
                          )),
                    ),
                  ],
                )
              ],
            ),
          ),
          Row(
            children: [
              Flexible(
                child: Form(
                    child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35),
                            borderSide:
                                const BorderSide(color: Color(0xFF704F38))),
                        prefixIcon: const Icon(
                          Icons.search,
                          size: 26,
                        ),
                        hintText: 'Search',
                        hintStyle: TextStyle(
                            color: Colors.grey.shade500, fontSize: 18),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35),
                            borderSide: BorderSide(
                                color: Colors.grey.shade300,
                                style: BorderStyle.none))),
                  ),
                )),
              ),
              Container(
                margin: const EdgeInsets.only(right: 20),
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: Color(0xFF704F38),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.filter_alt,
                  size: 32,
                  color: Colors.white,
                ),
              )
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                CarouselSlider(
                  items: imageSliders,
                  options: CarouselOptions(
                      viewportFraction: 1.0,
                      onPageChanged: (index, reason) {
                        setState(() => _current = index);
                      }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: imgList.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _controller.animateToPage(entry.key),
                      child: Container(
                        width: 10,
                        height: 10,
                        margin: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : const Color(0xFF704F38))
                              .withOpacity(_current == entry.key ? 0.9 : 0.3),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Category',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 22,
                        ),
                      ),
                      Text(
                        'See All',
                        style: TextStyle(
                          color: Color(0xFF704F38),
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyCategory(
                          const FaIcon(
                            FontAwesomeIcons.person,
                            size: 32,
                            color: Color(0xFF704F38),
                          ),
                          'Men'),
                      MyCategory(
                          const FaIcon(
                            FontAwesomeIcons.personDress,
                            size: 32,
                            color: Color(0xFF704F38),
                          ),
                          'Women'),
                      MyCategory(
                          const FaIcon(
                            FontAwesomeIcons.stopwatch,
                            size: 32,
                            color: Color(0xFF704F38),
                          ),
                          'Accessories'),
                      MyCategory(
                          const FaIcon(
                            FontAwesomeIcons.bagShopping,
                            size: 32,
                            color: Color(0xFF704F38),
                          ),
                          'Bag'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
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
                          child:
                              PopularCategory('Newest', _selectedCatIndex == 1),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCatIndex = 2;
                            });
                          },
                          child: PopularCategory(
                              'Popular', _selectedCatIndex == 2),
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
                          child:
                              PopularCategory('Women', _selectedCatIndex == 4),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                                  product['id'], widget.userData['id']);

                              Get.to(() =>
                                  ProductDetail(productId: product['id']));
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
                                              product['id'],
                                              widget.userData['id']);
                                        } else {
                                          productController.addToFavorites(
                                              product['id'],
                                              widget.userData['id']);
                                        }
                                      },
                                      icon: Icon(
                                        isFavorite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        size: 20,
                                        color: isFavorite
                                            ? Colors.red
                                            : Colors.grey,
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
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
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    productController.fetchProducts(widget.userData['id']);
  }
}
