import 'package:anwar_alsultan/config/themes/custom_colors.dart';
import 'package:flutter/material.dart';

class CustomFlatBtn extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final Color color;
  final Function onPressed;

  CustomFlatBtn({
    this.onPressed,
    this.text,
    this.width,
    this.height,
    this.color = kBtnPrimaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      minWidth: width,
      height: height,
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Text(text, style: TextStyle(color: kWhiteColor, fontSize: 18)),
    );
  }
}
