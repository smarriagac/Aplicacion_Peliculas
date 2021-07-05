import 'package:flutter/material.dart';

import 'package:peliculas/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Peliculas en cines')),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search_outlined),
            onPressed: (){},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
        children: [
          // tarjetas principales
          CardSwiper(),
          // slider de peliculas
          MovieSlider(),
          
          ],
        ),
      )
  );
  }
}