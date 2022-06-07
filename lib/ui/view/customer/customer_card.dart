import 'package:anwar_alsultan/Controller/RestManager.dart';
import 'package:anwar_alsultan/config/themes/custom_colors.dart';
import 'package:anwar_alsultan/model/models.dart';
import 'package:anwar_alsultan/ui/view/home/search_card.dart';
import 'package:flutter/material.dart';
import 'package:anwar_alsultan/ui/shared/widgets/custom_flatbtn.dart';

class CustomerCard extends StatefulWidget {
  Period periodItem;
  List<Region> _listAreas;
  List<Street> _listStreets;

  CustomerCard(this.periodItem, this._listAreas, this._listStreets);
  @override
  _CustomerCardState createState() =>
      _CustomerCardState(this.periodItem, this._listAreas, this._listStreets);
}

class _CustomerCardState extends State<CustomerCard> {
  Period periodItem;
  List<Region> _listAreas;
  List<Street> _listStreets;

  bool isloading = false;
  bool isloading2 = false;
  bool noMoreSave = false;

  String _textArea = 'اختر المنطقة';
  int _areaID = -1;
  String _textStreet = 'اختر الشارع';
  int _streetID = -1;
  TextEditingController textControlllerName;
  TextEditingController textControlllerMobile;
  TextEditingController textControlllerOrder;
  _CustomerCardState(this.periodItem, this._listAreas, this._listStreets) {
    textControlllerName = TextEditingController();
    textControlllerName.text = periodItem.customerName;

    textControlllerMobile = TextEditingController();
    textControlllerMobile.text = periodItem.customerMobile;

    textControlllerOrder = TextEditingController();
    if (this.periodItem.customerOrder != null)
      textControlllerOrder.text = this.periodItem.customerOrder.toString();

    if (this.periodItem.customerId != -1) {
      this._streetID = periodItem.streetId;
      this._areaID = periodItem.regionId;

      this._textArea = periodItem.RegionName;
      this._textStreet = periodItem.streetId.toString();
    }
  }

  void saveCustomer(BuildContext context) {
    print(">>>Start Save customer");
    print(">>> current  customer id:" + this.periodItem.customerId.toString());
    FocusManager.instance.primaryFocus?.unfocus();
    if (noMoreSave) {
      RestManager.showModel('تم حفظ هذا السجل مسبقاً', context);
      return;
    }
    if (textControlllerName.text == '') {
      RestManager.showModel("لا يمكن ترك خانة الاسم فارغة", context);
      return;
    }
    if (textControlllerMobile.text == '') {
      RestManager.showModel("لا يمكن ترك خانة الجوال فارغة", context);
      return;
    }
    if (_streetID == -1) {
      RestManager.showModel("لا يمكن ترك خانة الشارع فارغة", context);
      return;
    }
    setState(() {
      isloading = true;
    });

    RestManager.SaveCustomer(
            periodItem.customerId,
            textControlllerName.text,
            textControlllerMobile.text,
            _streetID.toString(),
            textControlllerOrder.text)
        .then((int value) {
      setState(() {
        isloading = false;
      });
      if (value == 0) {
        if (periodItem.customerId == -1) {
          noMoreSave = true;
        }
        RestManager.showModel("تم الحفظ", context);
      }
    }).catchError((e) {
      RestManager.showModel("حدث خطأ، يرجى مراجعة البيانات", context);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width * .9,
      child: ListView(
        padding: const EdgeInsets.all(8),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'اسم المشترك',
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
                  controller: textControlllerName,
                  autofocus: true,
                  style: TextStyle(
                      color: kFontPrimaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: '',
                    hintStyle: TextStyle(color: kNameLabelColor, fontSize: 14),
                  ),
                  keyboardType: TextInputType.text,
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
                  controller: textControlllerMobile,
                  autofocus: true,
                  style: TextStyle(
                      color: kFontPrimaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: '',
                    hintStyle: TextStyle(color: kNameLabelColor, fontSize: 14),
                  ),
                  keyboardType: TextInputType.text,
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
                'ترتيب المشترك',
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
                  controller: textControlllerOrder,
                  autofocus: true,
                  style: TextStyle(
                      color: kFontPrimaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: '',
                    hintStyle: TextStyle(color: kNameLabelColor, fontSize: 14),
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
            ],
          ),
          SearchCard(
            onTapArea: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    title: Text('اختر المنطقة'),
                    content: SizedBox(
                      width: size.width * 0.8,
                      child: alertDialoadArea(),
                    ),
                  );
                },
              );
            },
            onTapStreet: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    title: Text('اختر الشارع'),
                    content: SizedBox(
                      width: size.width * 0.8,
                      child: alertDialoadStreet(),
                    ),
                  );
                },
              );
            },
            textArea: _textArea,
            textStreet: _textStreet,
          ),
          const SizedBox(height: 8),
          isloading
              ? Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                  ),
                )
              : CustomFlatBtn(
                  onPressed: () {
                    saveCustomer(context);
                  },
                  color: kBtnPrimaryColor,
                  height: 50,
                  text: 'حفظ',
                  width: size.width * .9,
                ),
          const SizedBox(
            height: 8,
          ),
          this.periodItem.customerId != -1
              ? isloading2
                  ? Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                      ),
                    )
                  : CustomFlatBtn(
                      onPressed: () {
                        deleteCustomer(context);
                      },
                      color: Color(0xffee0202),
                      height: 50,
                      text: 'حذف المشترك',
                      width: size.width * .9,
                    )
              : SizedBox(),
        ],
      ),
    );
  }

  void deleteCustomer(BuildContext context) {
    String msg = "هل بالتاكيد تريد الحذف؟";
    bool yesBtn = false;

    RestManager.showAlertDialog(context, msg, () {
      Navigator.of(context).pop();
      FocusManager.instance.primaryFocus?.unfocus();
      setState(() {
        isloading2 = true;
      });

      RestManager.deleteCustomer(periodItem.customerId).then((int value) {
        setState(() {
          isloading2 = false;
        });
        print("Delete is done with value =" + value.toString());
        if (value == 0) {
          if (periodItem.customerId == -1) {
            noMoreSave = true;
          }

          RestManager.showModel("تم الحذف", context);
        }
      }).catchError((e) {
        RestManager.showModel("حدث خطأ، أثناء حذف السجل.", context);
      });
    }, () {
      Navigator.of(context).pop();
    });

/*
    setState(() {
      isloading2 = true;
    });

    RestManager.deleteCustomer(periodItem.customerId).then((int value) {
      setState(() {
        isloading2 = false;
      });
      print("Delete is done with value =" + value.toString());
      if (value == 0) {
        if (periodItem.customerId == -1) {
          noMoreSave = true;
        }
        RestManager.showModel("تم الحذف", context);
      }
    }).catchError((e) {
      RestManager.showModel("حدث خطأ، أثناء حذف السجل.", context);
    });
    */
  }

  Widget alertDialoadArea() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _listAreas.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          onTap: () {
            setState(() {
              _textArea = _listAreas[index].name;
              _areaID = _listAreas[index].id;
              _textStreet = "";
              _streetID = -1;
              var result = RestManager.listStreets
                  .where((element) => element.regionId == _areaID);
              _listStreets = result.toList();
            });

            Navigator.of(context).pop();
          },
          title: Text(_listAreas[index].name),
        );
      },
    );
  }

  Widget alertDialoadStreet() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _listStreets.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          onTap: () {
            setState(() {
              _textStreet = _listStreets[index].name;
            });
            _streetID = _listStreets[index].id;
            Navigator.of(context).pop();
          },
          title: Text(_listStreets[index].name),
        );
      },
    );
  }
}
