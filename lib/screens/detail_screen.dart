import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {

  final int index;
  const DetailScreen({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Screen'),
      ),

      body: Column(
        children: [
          const FlutterLogo(size: 50,),
          Text(index.toString(), style: const TextStyle(fontSize: 20),),
        ],
      ),
    );
  }
}
