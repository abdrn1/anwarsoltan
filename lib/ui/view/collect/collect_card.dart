import 'package:anwar_alsultan/config/themes/custom_colors.dart';
import 'package:anwar_alsultan/model/models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CollectCard extends StatelessWidget {
  Period periodItem;
  CollectCard({this.periodItem, this.textEditingController});
  TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (periodItem.billPaid > 0) {
      // textEditingController.text = periodItem.billPaid.toString();
    }

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
                'تاريخ أخر قراءة',
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
                  periodItem.periodReadingDate != null
                      ? DateFormat('yyyy-MM-dd')
                          .format(periodItem.periodReadingDate)
                      : '0000-00-00',
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
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'الدفعة المالية',
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
                  controller: textEditingController,
                  autofocus: true,
                  style: TextStyle(
                      color: kFontPrimaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: 'ادخل قيمة الدفعة المالية',
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
