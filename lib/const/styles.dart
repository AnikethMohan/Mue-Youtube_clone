import 'package:flutter/material.dart';

Text TextMue(
    {required String text,
    required double fontSize,
    required FontWeight weight,
    Color color = Colors.white,
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
      color: color ?? Colors.black,
      overflow: overflow,
    ),
  );
}

Color kyellow = const Color(0xffEE8838);
Color kblack = const Color(0xff181A1F);

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
