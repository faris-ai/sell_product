import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1, initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 2.5,
            width: MediaQuery.of(context).size.width,
            child: PageView.builder(
              itemCount: widget.product.images.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(widget.product.images[index]))),
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
              children: indicators(widget.product.images.length, activePage)),
          Container(
            margin: const EdgeInsets.all(10),
            child: Text(
              widget.product.title,
              style: const TextStyle(fontSize: 24),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: Text(
              widget.product.description,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ]),
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
