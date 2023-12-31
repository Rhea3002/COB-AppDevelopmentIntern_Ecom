import 'package:badges/badges.dart' as badges;
import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/bottombar.dart';
import '../../../common/widgets/custom_button.dart';
import '../../../common/widgets/stars.dart';
import '../../../constants/global_variables.dart';
import '../../../models/product.dart';
import '../../../providers/user_provider.dart';
import '../../cart/screens/cartscreen.dart';
import '../../search/screens/search_screen.dart';
import '../services/product_detail_services.dart';

class ProductDetailScreen extends StatefulWidget {
  static const String routeName = '/product-details';
  final Product product;
  const ProductDetailScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductDetailsServices productDetailsServices =
      ProductDetailsServices();
  double avgRating = 0;
  double myRating = 0;

  bool addedToCart = false;

  @override
  void initState() {
    super.initState();
    double totalRating = 0;
    // for (int i = 0; i < widget.product.rating!.length; i++) {
    //   totalRating += widget.product.rating![i].rating;
    //   if (widget.product.rating![i].userId ==
    //       Provider.of<UserProvider>(context, listen: false).user.id) {
    //     myRating = widget.product.rating![i].rating;
    //   }
    // }

    // if (totalRating != 0) {
    //   avgRating = totalRating / widget.product.rating!.length;
    // }
  }

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  void goToCart() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => BottomBar()));
  }

  void addToCart() {
    productDetailsServices.addToCart(
      context: context,
      product: widget.product,
    );
    addedToCart = true; // Set to true when the button is clicked
  }

  @override
  Widget build(BuildContext context) {
    final userCartLen = context.watch<UserProvider>().user.cart.length;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  margin: const EdgeInsets.only(left: 15),
                  child: Material(
                    borderRadius: BorderRadius.circular(7),
                    elevation: 1,
                    child: TextFormField(
                      onFieldSubmitted: navigateToSearchScreen,
                      decoration: InputDecoration(
                        prefixIcon: InkWell(
                          onTap: () {},
                          child: const Padding(
                            padding: EdgeInsets.only(
                              left: 6,
                            ),
                            child: Icon(
                              Icons.search,
                              color: Colors.black,
                              size: 23,
                            ),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.only(top: 10),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          borderSide: BorderSide(
                            color: Colors.black38,
                            width: 1,
                          ),
                        ),
                        hintText: 'Search?',
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Container(
              //   color: Colors.transparent,
              //   height: 42,
              //   margin: const EdgeInsets.symmetric(horizontal: 10),
              //   child: const Icon(Icons.mic, color: Colors.black, size: 25),
              // ),
            ],
          ),
          actions: [
            badges.Badge(
              badgeContent: Text(
                userCartLen.toString(),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              position: badges.BadgePosition.topEnd(top: 4, end: 6),
              badgeColor: Colors.cyan[800]!,
              animationDuration: Duration(milliseconds: 300),
              animationType: BadgeAnimationType.slide,
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CartScreen()));
                },
                icon: const Icon(Icons.shopping_cart),
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text(
            //         widget.product.id!,
            //       ),
            //       Stars(
            //         rating: avgRating,
            //       ),
            //     ],
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 10,
              ),
              child: Text(
                widget.product.name,
                style: const TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
            CarouselSlider(
              items: widget.product.images.map(
                (i) {
                  return Builder(
                    builder: (BuildContext context) => Image.network(
                      i,
                      fit: BoxFit.contain,
                      height: 200,
                    ),
                  );
                },
              ).toList(),
              options: CarouselOptions(
                viewportFraction: 1,
                height: 300,
              ),
            ),
            Container(
              color: Colors.black12,
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: RichText(
                text: TextSpan(
                  text: 'Deal Price: ',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: '\u{20B9}${NumberFormat('#,###').format(widget.product.price.toInt())}',
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.product.description),
            ),
            Container(
              color: Colors.black12,
              height: 5,
            ),
            Card(
                child: ListTile(
                    title:
                        Text("Screen Technology: ${widget.product.screentech}"),
                    leading: Icon(Icons.fit_screen_sharp))),
            Card(
                child: ListTile(
                    title: Text("Operating System: ${widget.product.os}"),
                    leading: Icon(Icons.settings))),
            Card(
                child: ListTile(
                    title: Text("RAM: ${widget.product.ram} GB"),
                    leading: Icon(Icons.memory))),
            Card(
                child: ListTile(
                    title: Text("Storage: ${widget.product.ram} GB"),
                    leading: Icon(Icons.storage_sharp))),
            Container(
              color: Colors.black12,
              height: 5,
            ),

            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Padding(
            //     padding: const EdgeInsets.all(10),
            //     child:

            // ),
            //),

            // Padding(
            //   padding: const EdgeInsets.all(10),
            //   child: CustomButton(
            //     text: 'Buy Now',
            //     onTap: () {},
            //   ),
            // ),
            //const SizedBox(height: 10),
            //------------------------------------------------------------------------------------------

            // const SizedBox(height: 10),
            // Container(
            //   color: Colors.black12,
            //   height: 5,
            // ),
            // const Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 10.0),
            //   child: Text(
            //     'Rate The Product',
            //     style: TextStyle(
            //       fontSize: 22,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
            // RatingBar.builder(
            //   initialRating: myRating,
            //   minRating: 1,
            //   direction: Axis.horizontal,
            //   allowHalfRating: true,
            //   itemCount: 5,
            //   itemPadding: const EdgeInsets.symmetric(horizontal: 4),
            //   itemBuilder: (context, _) => const Icon(
            //     Icons.star,
            //     color: GlobalVariables.secondaryColor,
            //   ),
            //   onRatingUpdate: (rating) {
            //     productDetailsServices.rateProduct(
            //       context: context,
            //       product: widget.product,
            //       rating: rating,
            //     );
            //   },
            // )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        child: CustomButton(
          text: addedToCart ? 'BROWSE FOR OTHER PRODUCTS' : 'ADD TO CART',
          onTap: addedToCart ? goToCart : addToCart,
          color: const Color.fromRGBO(254, 216, 19, 1),
        ),
      ),
    );
  }
}
