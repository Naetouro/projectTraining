import 'dart:convert';

import 'package:flutter/cupertino.dart';

class WidgetExerciseImage extends StatelessWidget{

  final String image;

  const WidgetExerciseImage({Key key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Image(
      image: MemoryImage(base64Decode(image)),
      gaplessPlayback: true,
    );
  }

}