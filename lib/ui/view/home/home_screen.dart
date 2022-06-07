import 'dart:math';

import 'package:anwar_alsultan/Controller/RestManager.dart';
import 'package:anwar_alsultan/config/themes/custom_colors.dart';
import 'package:anwar_alsultan/model/models.dart';
import 'package:anwar_alsultan/ui/shared/widgets/custom_flatbtn.dart';
import 'package:anwar_alsultan/ui/view/collect/collect_screen.dart';
import 'package:anwar_alsultan/ui/view/customer/customer_screen.dart';
import 'package:anwar_alsultan/ui/view/home/appbar_widget.dart';
import 'package:anwar_alsultan/ui/view/home/card_widget.dart';
import 'package:anwar_alsultan/ui/view/home/search_card.dart';
import 'package:anwar_alsultan/ui/view/login/login_screen.dart';
import 'package:anwar_alsultan/ui/view/read/read_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:intent/intent.dart' as androidIntent;
import 'package:intent/action.dart' as android_action;
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = 'home-screen';
  int screenType = 0; //0: reading 1: payment
  String userName = 'Test User';
  HomeScreen(this.screenType);
  @override
  _HomeScreenState createState() => _HomeScreenState(screenType);
}

class _HomeScreenState extends State<HomeScreen> {
  Size size;
  int screenType = 0;

  String _textArea = 'اختر المنطقة';
  int _areaID = -1;
  String _textStreet = 'اختر الشارع';
  int _streetID = -1;
  // List<Region> _listAreas = [new Region(-1, "لا بيانات")];
  List<Region> _listAreas = RestManager.listRegion;

  /* List<Street> _listStreets = [
    Street(-1, "حدد المنطقة اولا", -1),
  ];*/
  List<Street> _listStreets = RestManager.listStreets;

  List<Period> listAllPeriods = [];
  List<Period> listFilterPriod = [];

  bool _isSearch = false;
  int _searchStatus = 0;
  int widgetCounter = 0;

  Future<void> getRegionsAndStreets({bool showprogress = false}) async {
    var pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    if (showprogress) {
      pr.show();
    }
    final listRegions = await RestManager.getAllRegions();
    setState(() {
      _listAreas = listRegions;
    });
    if (RestManager.userName == "Admin") {
      await RestManager.getAllStreets();
    } else {
      await RestManager.getRegionStreets(listRegions[0].id.toString());
    }

    if (showprogress) {
      pr.hide();
    }
  }

  _HomeScreenState(this.screenType);

  @override
  void initState() {
    //getRegionsAndStreets(showprogress: true);
  }

  @override
  Widget build(BuildContext context) {
    widgetCounter = 0;

    size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: SafeArea(
          child: AppBar(
            brightness: Brightness.light, // status bar brightness
            flexibleSpace: AppBarWidget(
              // TODO for logout dialog
              onTapRefresh: () {
                getRegionsAndStreets(showprogress: true);
              },
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      content: SizedBox(
                        width: size.width * 0.8,
                        child: alertDialoadLogout(),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
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
            const SizedBox(height: 5),
            SizedBox(
              width: size.width * .9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomFlatBtn(
                    height: 50,
                    onPressed: () {
                      setState(() {
                        if (_searchStatus != 1) {
                          getAllCustomersPeriod();
                        }
                      });
                    },
                    text: _isSearch ? 'الغاء' : 'بحث',
                    width: screenType == 2 ? size.width * .7 : size.width * .9,
                    color: screenType == 0 ? kBtnPrimaryColor : nBlueColor,
                  ),
                  screenType == 2
                      ? IconButton(
                          icon: Icon(Icons.add),
                          tooltip: "إضافة مشترك جديد",
                          onPressed: () {
                            Period newPeriod = Period();
                            newPeriod.customerId = -1;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CustomerScreen(
                                      newPeriod, _listAreas, _listStreets)),
                            );
                          },
                        )
                      : SizedBox()
                ],
              ),
            ),
            const SizedBox(height: 10),
            (_searchStatus == 2)
                ? Container(
                    width: size.width * .86,
                    height: 35,
                    padding: const EdgeInsets.only(right: 8, left: 8, top: 10),
                    decoration: BoxDecoration(
                      color: kWhiteColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      onChanged: (text) {
                        filterPeriodList(text);
                      },
                      style: TextStyle(
                          color: kNameLabelColor,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                          hintText: 'بحث بإسم الزبون',
                          border: InputBorder.none,
                          hintStyle:
                              TextStyle(color: kNameLabelColor, fontSize: 14),
                          suffixIcon: Icon(Icons.search)),
                    ),
                  )
                : SizedBox(),
            (_searchStatus == 2)
                ? Expanded(
                    child: SizedBox(
                      width: size.width * 0.9,
                      child: (listAllPeriods.length > 0)
                          ? ListView.builder(
                              itemCount: listAllPeriods.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) => GestureDetector(
                                    onLongPress: () {
                                      var pitem = listAllPeriods[index];
                                      intentMakeCall(pitem.customerMobile);
                                    },
                                    onTap: () {
                                      var pitem = listAllPeriods[index];
                                      if (screenType == 0) {
                                        if (pitem.lockInterval) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'تم ادخال قراءة هذا السجل مسبقاً')));
                                          return;
                                        }

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ReadScreen(
                                                    priodItem: pitem,
                                                  )),
                                        );
                                      } else if (screenType == 1) {
                                        if (pitem.lockPayment) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'تم للتو ادخال دفعة مالية لهذا البند مسبقاً')));
                                          return;
                                        }
                                        /*if (pitem.billPaid > 0) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'تم ادخال دفعة مالية لهذا البند مسبقاً')));
                                          return;
                                        }*/
                                        if (pitem.customerBillSum <= 0) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'لا ديون مستحقة لهذا الزبون')));
                                          return;
                                        }

                                        if (pitem.periodReadingDate == null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'لم يتم ادخال قراءة عداد لهذا الزبون  ')));
                                          return;
                                        }
                                        // Navigator.of(context).pushNamed(CollectScreen.routeName);
                                        //   Navigator.pop(context);

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CollectScreen(
                                                    periodItem: pitem,
                                                  )),
                                        );
                                      } else if (screenType == 2) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CustomerScreen(
                                                      pitem,
                                                      _listAreas,
                                                      _listStreets)),
                                        );
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 8),
                                      decoration: BoxDecoration(
                                        color: (listAllPeriods[index]
                                                    .lockPayment ||
                                                listAllPeriods[index]
                                                    .lockInterval)
                                            ? Color(0xffd3b8ae)
                                            : kWhiteColor,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 5,
                                            offset: Offset(0, 0),
                                            color: kBtnPrimaryColor
                                                .withOpacity(0.2),
                                          )
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                      listAllPeriods[index]
                                                          .customerName,
                                                      style: TextStyle(
                                                        color:
                                                            kFontPrimaryColor,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
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
                                                      listAllPeriods[index]
                                                          .customerMobile,
                                                      style: TextStyle(
                                                        color:
                                                            kFontPrimaryColor,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ],
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
                                                      listAllPeriods[index]
                                                                  .periodReadingDate !=
                                                              null
                                                          ? DateFormat(
                                                                  'yyyy-MM-dd')
                                                              .format(listAllPeriods[
                                                                      index]
                                                                  .periodReadingDate)
                                                          : 'غير متوفر',
                                                      style: TextStyle(
                                                        color:
                                                            kFontPrimaryColor,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              screenType == 1
                                                  ? Row(
                                                      children: [
                                                        Text(
                                                          'قراءة سابقة',
                                                          style: TextStyle(
                                                            color:
                                                                kNameLabelColor,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 8),
                                                        SizedBox(
                                                          width:
                                                              size.width * 0.5,
                                                          child: Text(
                                                            listAllPeriods[
                                                                    index]
                                                                .periodPreviousReading
                                                                .toString(),
                                                            style: TextStyle(
                                                              color:
                                                                  kFontPrimaryColor,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : const SizedBox(height: 0),
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
                                                      listAllPeriods[index]
                                                          .periodReading
                                                          .toString(),
                                                      style: TextStyle(
                                                        color:
                                                            kFontPrimaryColor,
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
                                                    'الرصيد',
                                                    style: TextStyle(
                                                      color: kNameLabelColor,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  SizedBox(
                                                    width: size.width * 0.5,
                                                    child: Text(
                                                      listAllPeriods[index]
                                                          .customerBillSum
                                                          .toStringAsFixed(2),
                                                      style: TextStyle(
                                                        color:
                                                            kFontPrimaryColor,
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                (index + 1).toString(),
                                                style: TextStyle(
                                                  color: kFontPrimaryColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              this.screenType == 0
                                                  ? SvgPicture.asset(
                                                      'assets/images/plug.svg')
                                                  : Image.asset(
                                                      'assets/images/wallet.png',
                                                      scale: 1.2),
                                            ],
                                          )

                                          /* this.screenType == 1
                ? SvgPicture.asset('assets/images/plug.svg')
                : Image.asset('assets/images/wallet.png', scale: 1.2),*/
                                        ],
                                      ),
                                    ),
                                  ))
                          : Center(
                              child: Text(
                                  screenType == 0
                                      ? 'لا سجلات للإدخال بتاريخ اليوم'
                                      : 'لا يوجد سجلات لعرضها',
                                  style: TextStyle(
                                      fontSize: 20, color: kFontPrimaryColor)),
                            ),
                    ),
                  )
                : (_searchStatus == 1)
                    ? Center(
                        child: Container(
                          height: this.size.width - (size.width / 2),
                          width: this.size.width - (size.width / 2),
                          child: CircularProgressIndicator(
                            strokeWidth: 9,
                            backgroundColor: kBtnPrimaryColor,
                          ),
                        ),
                      )
                    : SizedBox()
          ],
        ),
      ),
    );
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

  Widget alertDialoadSearch(Period pitem) {
    return ListView(
      shrinkWrap: true,
      children: [
        CustomFlatBtn(
          height: 50,
          text: 'قراءة',
          width: size.width * .5,
          onPressed: () {
            Navigator.pop(context);
            if (pitem.lockInterval) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تم ادخال قراءة هذا السجل مسبقاً')));
              return;
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ReadScreen(
                        priodItem: pitem,
                      )),
            );
            /*Navigator.of(context).pushNamed(ReadScreen.routeName,
            

               );*/
          },
        ),
        const SizedBox(height: 8),
        CustomFlatBtn(
          height: 50,
          text: 'دفعة مالية',
          width: size.width * .5,
          onPressed: () {
            if (pitem.lockPayment) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('تم ادخال دفعة مالية لهذا البند مسبقاً')));
              return;
            }
            // Navigator.of(context).pushNamed(CollectScreen.routeName);
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CollectScreen(
                        periodItem: pitem,
                      )),
            );
          },
        ),
      ],
    );
  }

  Widget alertDialoadLogout() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset('assets/images/Logout.svg'),
        const SizedBox(height: 8),
        const Text(
          'هل تريد تسجيل الخروج ؟',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: size.width * .6,
          child: const Text(
            'عند تسجيل الخروج سيتم ارسالك الى واجهة تسجيل الدخول من جديد',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 12,
              color: kNameLabelColor,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomFlatBtn(
              height: 40,
              text: 'تأكيد',
              width: size.width * .3,
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, LoginScreen.routeName, (route) => false);
              },
            ),
            SizedBox(
              width: size.width * .3,
              height: 40,
              child: OutlineButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'إلغاء',
                  style: TextStyle(
                    color: kNameLabelColor,
                    fontSize: 18,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
      ],
    );
  }

  ///
  void getAllCustomersPeriod() async {
    String _msg = '';
    widgetCounter = 0;
    bool conError = false;

    if (_areaID == -1) {
      RestManager.showModel('الرجاء تحديد المنطقة', context);
      return;
    }
    if (_streetID == -1 && screenType != 2) {
      RestManager.showModel('الرجاء تحديد الشارع', context);
      return;
    }
    setState(() {
      _searchStatus = 1;
    });
    try {
      listFilterPriod = await RestManager.getAllCustomersPeriods(
          _streetID, screenType, _areaID);

      listAllPeriods = listFilterPriod;
      setState(() {
        _searchStatus = 2;
      });
    } catch (e) {
      _msg = e.toString();
      setState(() {
        _searchStatus = 0;
      });
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // Retrieve the text the that user has entered by using the
            // TextEditingController.
            content: Text(_msg),
          );
        },
      );
    }
  }

  Future<void> intentMakeCall(String phoneNumber) async {
    if (await Permission.phone.request().isGranted) {
      androidIntent.Intent intentMakeCall = androidIntent.Intent()
        ..setAction(android_action.Action.ACTION_CALL)
        ..setData(Uri.parse("tel:0" + phoneNumber))
        ..startActivity().then((value) => null);
      // Either the permission was already granted before or the user just granted it.
    }
  }

  void filterPeriodList(text) {
    var result = listFilterPriod.where((element) {
      if (element.customerName.contains(text)) {
        print("valid user: " + element.customerName);
        return true;
      }
      return false;
    });
    print("result count " + result.length.toString());

    setState(() {
      listAllPeriods = List.from(result.toList());
    });
  }
}
