import 'package:flutter/material.dart';

class Palette {
  static const MaterialColor newBlue = MaterialColor(
    0xFF2945FF, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xff253ee6 ),//10%
      100: Color(0xff2137cc),//20%
      200: Color(0xff2137cc),//30%
      300: Color(0xff1d30b3),//40%
      400: Color(0xff192999),//50%
      500: Color(0xff101c66),//60%
      600: Color(0xff0c154c),//70%
      700: Color(0xff080e33),//80%
      800: Color(0xff040719),//90%
      900: Color(0xff000000),//100%
    },
  );
}