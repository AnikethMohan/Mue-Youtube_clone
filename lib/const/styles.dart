import 'package:flutter/material.dart';

Text TextMue(
    {required String text,
    required double fontSize,
    required FontWeight weight,
    Color color = const Color(0xff181A1F),
    TextAlign? align,
    int? maxlines,
    TextOverflow? overflow}) {
  return Text(
    text,
    maxLines: maxlines,
    textAlign: align,
    style: TextStyle(
      fontFamily: 'Spotify Circular',
      fontSize: fontSize,
      fontWeight: weight,
      color: color,
      overflow: overflow,
    ),
  );
}

Color kyellow = const Color(0xffEE8838);
Color kblack = const Color(0xff181A1F);
Color kpink = const Color(0xffFF4D67);
Color kwhite = const Color(0xffFFFFFF);

TextStyle TextStyleMue(
    {required double fontSize,
    required FontWeight weight,
    Color color = Colors.white}) {
  return TextStyle(
      fontFamily: 'Spotify Circular',
      fontSize: fontSize,
      fontWeight: weight,
      color: color);
}
