import 'package:flutter/material.dart';

class MusicControllButton extends StatelessWidget {
  const MusicControllButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 310,
        height: 101,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            IconButton(
              onPressed: null,
              icon: Icon(Icons.fast_rewind),
              iconSize: 60.0,
            ),
            IconButton(
              onPressed: null,
              icon: Icon(Icons.pause),
              iconSize: 60.0,
            ),
            IconButton(
              onPressed: null,
              icon: Icon(Icons.fast_forward),
              iconSize: 60.0,
            )
          ],
        ),
      ),
    );
  }
}
