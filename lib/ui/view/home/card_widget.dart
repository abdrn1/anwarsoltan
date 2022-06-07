import 'package:anwar_alsultan/Controller/RestManager.dart';
import 'package:anwar_alsultan/config/themes/custom_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:anwar_alsultan/model/models.dart';
import 'package:intl/intl.dart';

class CardWidget extends StatefulWidget {
  Function onTap;
  Period periodItem;
  int counter = 0;
  int screenType = 0;
  CardWidget(
      {Key key, this.onTap, this.periodItem, this.screenType, this.counter})
      : super(key: key);
  @override
  _CardWidgetState createState() => _CardWidgetState(
      onTap: this.onTap,
      periodItem: this.periodItem,
      counter: this.counter,
      screenType: this.screenType);
}

class _CardWidgetState extends State<CardWidget> {
  Function onTap;
  Period periodItem;
  int counter = 0;
  int screenType = 0;
  _CardWidgetState(
      {this.onTap, this.periodItem, this.screenType, this.counter});

  @override
  Widget build(BuildContext context) {
    print("Screen type $screenType");
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: onTap,
      onLongPress: () {
        RestManager.showModel("hello long press", context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: (periodItem.lockPayment || periodItem.lockInterval)
              ? Color(0xffd3b8ae)
              : kWhiteColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              offset: Offset(0, 0),
              color: kBtnPrimaryColor.withOpacity(0.2),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'اسم الزبون',
                      style: TextStyle(
                        color: kNameLabelColor,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: size.width * 0.5,
                      child: Text(
                        periodItem.customerName,
                        style: TextStyle(
                          color: kFontPrimaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    RestManager.showModel('call phone', context);
                  },
                  child: Row(
                    children: [
                      Text(
                        'الجوال',
                        style: TextStyle(
                          color: kNameLabelColor,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: size.width * 0.5,
                        child: Text(
                          periodItem.customerMobile,
                          style: TextStyle(
                            color: kFontPrimaryColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'تاريخ أخر قراءة',
                      style: TextStyle(
                        color: kNameLabelColor,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: size.width * 0.5,
                      child: Text(
                        periodItem.periodReadingDate != null
                            ? DateFormat('yyyy-MM-dd')
                                .format(periodItem.periodReadingDate)
                            : 'غير متوفر',
                        style: TextStyle(
                          color: kFontPrimaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'قراءة سابقة',
                      style: TextStyle(
                        color: kNameLabelColor,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: size.width * 0.5,
                      child: Text(
                        periodItem.periodPreviousReading.toString(),
                        style: TextStyle(
                          color: kFontPrimaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'القراءة الأخيرة',
                      style: TextStyle(
                        color: kNameLabelColor,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: size.width * 0.5,
                      child: Text(
                        periodItem.periodReading.toString(),
                        style: TextStyle(
                          color: kFontPrimaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'الرصص',
                      style: TextStyle(
                        color: kNameLabelColor,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: size.width * 0.5,
                      child: Text(
                        '25',
                        style: TextStyle(
                          color: kFontPrimaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  this.counter.toString(),
                  style: TextStyle(
                    color: kFontPrimaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                this.screenType == 0
                    ? SvgPicture.asset('assets/images/plug.svg')
                    : Image.asset('assets/images/wallet.png', scale: 1.2),
              ],
            )

            /* this.screenType == 1
                ? SvgPicture.asset('assets/images/plug.svg')
                : Image.asset('assets/images/wallet.png', scale: 1.2),*/
          ],
        ),
      ),
    );
  }
}
