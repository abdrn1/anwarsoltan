import 'package:anwar_alsultan/Controller/RestManager.dart';
import 'package:anwar_alsultan/config/themes/custom_colors.dart';
import 'package:anwar_alsultan/model/models.dart';
import 'package:flutter/material.dart';

class ReadCard extends StatefulWidget {
  Period periodItem;
  TextEditingController textControlllerNewReading;

  ReadCard({this.periodItem, this.textControlllerNewReading});
  @override
  _ReadCardState createState() =>
      _ReadCardState(this.periodItem, this.textControlllerNewReading);
}

class _ReadCardState extends State<ReadCard> {
  Period periodItem;
  TextEditingController textControlllerNewReading;
  _ReadCardState(this.periodItem, this.textControlllerNewReading);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width * .9,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'اسم الزبون',
                style: TextStyle(fontSize: 14, color: kNameLabelColor),
              ),
              Container(
                width: size.width * .6,
                height: 30,
                padding: const EdgeInsets.only(right: 8, left: 8),
                decoration: BoxDecoration(
                  color: kLabelColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  periodItem.customerName,
                  style: TextStyle(color: kFontPrimaryColor),
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
              const Text(
                'الجوال',
                style: TextStyle(fontSize: 14, color: kNameLabelColor),
              ),
              Container(
                width: size.width * .6,
                height: 30,
                padding: const EdgeInsets.only(right: 8, left: 8),
                decoration: BoxDecoration(
                  color: kLabelColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  periodItem.customerMobile,
                  style: TextStyle(color: kFontPrimaryColor),
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
              const Text(
                'رقم العداد',
                style: TextStyle(fontSize: 14, color: kNameLabelColor),
              ),
              Container(
                width: size.width * .6,
                height: 30,
                padding: const EdgeInsets.only(right: 8, left: 8),
                decoration: BoxDecoration(
                  color: kLabelColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  periodItem.customerCounterId == -1
                      ? ''
                      : periodItem.customerCounterId.toString(),
                  style: TextStyle(color: kFontPrimaryColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'الرصيد',
                style: TextStyle(fontSize: 14, color: kNameLabelColor),
              ),
              Container(
                width: size.width * .6,
                height: 30,
                padding: const EdgeInsets.only(right: 8, left: 8),
                decoration: BoxDecoration(
                  color: kLabelColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  periodItem.customerBillSum.toString(),
                  style: TextStyle(color: kFontPrimaryColor),
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
              const Text(
                'تصفير قراءة سابقة',
                style: TextStyle(fontSize: 14, color: kNameLabelColor),
              ),
              Container(
                width: size.width * .6,
                height: 30,
                alignment: Alignment.centerRight,
                decoration: BoxDecoration(
                  color: kLabelColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Switch(
                  value: this.periodItem.zeroPeriod,
                  activeColor: Colors.lightBlue,
                  onChanged: (bool val) {
                    if (RestManager.userName == "Admin") {
                      setState(() {
                        this.periodItem.zeroPeriod = val;
                      });
                    } else {
                      RestManager.showModel(
                          'ليس لديك الصلاحية للتصفير', context);
                    }
                  },
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
              const Text(
                'القراءة السابقة',
                style: TextStyle(fontSize: 14, color: kNameLabelColor),
              ),
              Container(
                width: size.width * .6,
                height: 30,
                padding: const EdgeInsets.only(right: 8, left: 8),
                decoration: BoxDecoration(
                  color: kLabelColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  this.periodItem.zeroPeriod
                      ? '0'
                      : periodItem.periodReading.toString(),
                  style: TextStyle(color: kFontPrimaryColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'القراءة الحالية',
                style: TextStyle(fontSize: 14, color: kFontPrimaryColor),
              ),
              Container(
                width: size.width * .6,
                height: 45,
                padding: const EdgeInsets.only(right: 8, left: 8, bottom: 4),
                decoration: BoxDecoration(
                  color: kWhiteColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: this.textControlllerNewReading,
                  autofocus: true,
                  style: TextStyle(
                      color: kFontPrimaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: 'ادخل القراءة الحالية',
                    hintStyle: TextStyle(color: kNameLabelColor, fontSize: 14),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
