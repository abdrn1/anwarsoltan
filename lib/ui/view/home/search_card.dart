import 'package:anwar_alsultan/config/themes/custom_colors.dart';
import 'package:flutter/material.dart';

class SearchCard extends StatelessWidget {
  final Function onTapArea;
  final Function onTapStreet;
  final String textArea, textStreet;

  SearchCard({
    this.onTapArea,
    this.onTapStreet,
    this.textArea,
    this.textStreet,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width * .9,
      child: Column(
        children: [
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'المنطقة',
                style: TextStyle(fontSize: 14, color: kNameLabelColor),
              ),
              GestureDetector(
                onTap: onTapArea,
                child: Container(
                  width: size.width * .6,
                  height: 35,
                  padding: const EdgeInsets.only(right: 8, left: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        textArea,
                        style: TextStyle(color: kFontPrimaryColor),
                      ),
                      RotatedBox(
                        quarterTurns: 1,
                        child: Icon(
                          Icons.chevron_right_rounded,
                          color: kFontPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الشارع',
                style: TextStyle(fontSize: 14, color: kNameLabelColor),
              ),
              GestureDetector(
                onTap: onTapStreet,
                child: Container(
                  width: size.width * .6,
                  height: 35,
                  padding: const EdgeInsets.only(right: 8, left: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        textStreet,
                        style: TextStyle(color: kFontPrimaryColor),
                      ),
                      RotatedBox(
                        quarterTurns: 1,
                        child: Icon(
                          Icons.chevron_right_rounded,
                          color: kFontPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
