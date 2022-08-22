import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sell Product App"),
      ),
      body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.all(2),
              child: Card(
                  color: Colors.white,
                  elevation: 3,
                  child: TextButton(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(
                          Icons.abc,
                          color: Colors.deepOrange,
                          size: 100,
                        ),
                        const Text(
                          "Hello",
                          style: TextStyle(fontSize: 20),
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                    onPressed: () {},
                  )),
            );
          }),
    );
  }
}
