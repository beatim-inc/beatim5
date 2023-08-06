import 'package:flutter/material.dart';

class CounterDisplay extends StatelessWidget {

  final int counter;
  final int max_count;

  const CounterDisplay(this.counter,this.max_count,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 62,
        child: Text(
          '$counter / $max_count',
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}