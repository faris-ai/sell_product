import 'package:flutter/material.dart';
import 'package:sell_product/models/product.dart';
import 'package:sell_product/services/remote_service.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product>? products;

  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    products = await RemoteService().getProducts();
    if (products != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sell Product App"),
      ),
      body: Visibility(
          replacement: const Center(
            child: CircularProgressIndicator(),
          ),
          visible: isLoaded,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 1.5)),
            itemCount: products?.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.all(2),
                child: Card(
                    color: Colors.white,
                    elevation: 3,
                    child: TextButton(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.network(
                            products![index].thumbnail,
                            scale: 0.1,
                          ),
                          Text(
                            products![index].title,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black),
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            "\$${products![index].price}",
                            style: const TextStyle(fontSize: 14),
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                      onPressed: () {},
                    )),
              );
            },
          )),
    );
  }
}
