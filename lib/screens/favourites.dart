import 'package:flutter/material.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 2, vsync: this);
    return Scaffold(
        body: Column(
      children: [
        Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.black.withOpacity(0.1),
            ),
            child: TabBar(
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.amber),
                controller: tabController,
                tabs: const [
                  Text(
                    'Posts',
                    style: TextStyle(color: Colors.black),
                  ),
                  Text(
                    'Vibrants',
                    style: TextStyle(color: Colors.black),
                  )
                ]),
          ),
        ),
        Expanded(
            child: TabBarView(
          controller: tabController,
          children: [
            Center(child: Text('Posts content here')),
            Center(child: Text('Vibrants content here'))
          ],
        ))
      ],
    ));
  }
}
