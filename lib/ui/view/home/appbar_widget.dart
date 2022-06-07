import 'package:anwar_alsultan/Controller/RestManager.dart';
import 'package:anwar_alsultan/config/themes/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppBarWidget extends StatelessWidget {
  final Function onTap;
  final Function onTapRefresh;
  final String userName;
  AppBarWidget({this.onTap, this.onTapRefresh, this.userName});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Column(
        children: <Widget>[
          Row(
            children: [
              SvgPicture.asset('assets/images/lightning_small.svg'),
              const SizedBox(width: 4),
              const Text(RestManager.applicationName),
              const SizedBox(width: 4),
              IconButton(
                  icon: Icon(
                    Icons.refresh,
                    color: Colors.white,
                  ),
                  onPressed: onTapRefresh)
            ],
          ),
        ],
      ),
      flexibleSpace: Column(
        children: <Widget>[
          const SizedBox(
            height: 80,
          ),
          GestureDetector(
            onTap: onTap,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 50,
                ),
                Text(
                  'مرحبا',
                  style: TextStyle(
                    height: 1.0,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                    color: kWhiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  RestManager.userName,
                  style: TextStyle(
                    height: 1.0,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                    color: kWhiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(25),
        ),
      ),
      actions: [],
    );
  }
}
