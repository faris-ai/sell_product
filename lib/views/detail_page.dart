// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:sell_product/models/product.dart';

class DetailPage extends StatefulWidget {
  const DetailPage(this.product, {Key? key}) : super(key: key);
  final Product product;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late PageController _pageController;
  int activePage = 0;
  // late StreamSubscription _purchaseUpdatedSubscription;
  // late StreamSubscription _purchaseErrorSubscription;
  // late StreamSubscription _conectionSubscription;
  // String _platformVersion = 'Unknown';
  static const iapId = 'android.test.purchased';
  List<IAPItem> _items = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1, initialPage: 0);
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    // String platformVersion;
    var result = await FlutterInappPurchase.instance.initialize();
    print('result: $result');

    if (!mounted) return;

    // setState(() {
    //   _platformVersion = platformVersion;
    // });

    try {
      String msg = await FlutterInappPurchase.instance.consumeAll();
      print('consumeAllItems: $msg');
    } catch (err) {
      print('consumeAllItems error: $err');
    }

    await _getProduct();

    // _conectionSubscription =
    //     FlutterInappPurchase.connectionUpdated.listen((connected) {
    //   print('connected: $connected');
    // });

    // _purchaseUpdatedSubscription =
    //     FlutterInappPurchase.purchaseUpdated.listen((productItem) {
    //   print('purchase-updated: $productItem');
    // });

    // _purchaseErrorSubscription =
    //     FlutterInappPurchase.purchaseError.listen((purchaseError) {
    //   print('purchase-error: $purchaseError');
    // });
  }

  Future<void> _getProduct() async {
    List<IAPItem> items =
        await FlutterInappPurchase.instance.getProducts([iapId]);
    for (var item in items) {
      print(item.toString());
      _items.add(item);
    }

    setState(() {
      _items = items;
    });
  }

  Future<void> _buyProduct(IAPItem item) async {
    try {
      PurchasedItem purchased = await FlutterInappPurchase.instance
          .requestPurchase(item.productId.toString());
      print(purchased);
      String msg = await FlutterInappPurchase.instance.consumeAll();
      print('consumeAllItems: $msg');
    } catch (err) {
      print('consumeAllItems error: $err');
    }
  }

  List<Widget> _renderPurchases() {
    List<Widget> widgets = _items
        .map(
          (item) => SingleChildScrollView(
            child: Column(children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 2.5,
                width: MediaQuery.of(context).size.width,
                child: PageView.builder(
                  itemCount: widget.product.images.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image:
                                  NetworkImage(widget.product.images[index]))),
                    );
                  },
                  controller: _pageController,
                  onPageChanged: (page) {
                    setState(() {
                      activePage = page;
                    });
                  },
                ),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                      indicators(widget.product.images.length, activePage)),
              Container(
                margin: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.title,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        "\$${widget.product.price}",
                        style: const TextStyle(
                            fontSize: 20, color: Colors.deepPurple),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          widget.product.rating.toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "|",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Stok: ${widget.product.stock}",
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Text(
                        widget.product.description,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Text(
                        "Brand: ${widget.product.brand}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _buyProduct(item);
                },
                child: Text('Buy ${item.price} ${item.currency}'),
              ),
            ]),
          ),
        )
        .toList();
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(AppBar().preferredSize.height),
          child: CustomAppBar(
            rating: widget.product.rating,
          ),
        ),
        body: Column(
          children: _renderPurchases(),
        ));
  }
}

double getProportionateScreenWidth(BuildContext context, double inputWidth) {
  double screenWidth = MediaQuery.of(context).size.width;
  // 375 is the layout width that designer use
  return (inputWidth / 375.0) * screenWidth;
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key, this.rating}) : super(key: key);
  final double? rating;
  // AppBar().preferredSize.height provide us the height that appy on our app bar
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(context, 20)),
        child: Row(
          children: [
            SizedBox(
              height: getProportionateScreenWidth(context, 40),
              width: getProportionateScreenWidth(context, 40),
              child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60),
                    ),
                    primary: Colors.black,
                    backgroundColor: Colors.grey.shade50,
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back)),
            ),
          ],
        ),
      ),
    );
  }
}

List<Widget> indicators(imagesLength, currentIndex) {
  return List<Widget>.generate(imagesLength, (index) {
    return Container(
      margin: const EdgeInsets.all(3),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
          color: currentIndex == index ? Colors.black : Colors.black26,
          shape: BoxShape.circle),
    );
  });
}
