import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:anwar_alsultan/model/models.dart';
import 'package:intl/intl.dart';

class RestManager {
  static const String applicationName = "أنوار السلطان";
  static List<Region> listRegion;
  static List<Street> listStreets = List.empty();
  static String theSite = "anwarsoltan.com";
  static String version = "V1.2";

  static String apiKey = '2242021';
  static String userName = '';
  static double costPrice = 0;
  static int sendSms = 0;
  static int loginStatusCode = 0;

  static void showModel(String msg, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(msg),
        );
      },
    );
  }

  static showAlertDialog(
      BuildContext context, String msg, Function yesFun, Function noFunc) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("نعم"),
      onPressed: yesFun,
    );
    Widget continueButton = TextButton(
      child: Text("لا"),
      onPressed: noFunc,
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("تنبيه"),
      content: Text(msg),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static Future<User> login(String username, String password) async {
    loginStatusCode = 0;
    Map<String, String> queryparm = {
      'username': username.trim(),
      'password': password.trim(),
      'api_key': 'appv3.2'
    };
    final uri = Uri.https(theSite, 'ci/mobile/emplogin', queryparm);

    final response = await http.get(uri).timeout(new Duration(seconds: 10));
    print("response code :" + response.statusCode.toString());
    if (response.statusCode == 200) {
      print("response code :" + response.body);
      final users = parseUsers(response.body);
      if (users.length > 0) {
        loginStatusCode = 1;
        RestManager.userName = users[0].username;
        await getAllRegions();
        // print("current region:" + listRegion[0].id.toString());
        if (RestManager.userName == "Admin") {
          await getAllStreets();
        } else {
          await getRegionStreets(listRegion[0].id.toString());
        }

        await getPrice();

        return users[0];
      } else {
        print("no user found");

        //  print("response code :" + response.body);
        loginStatusCode = -1;
        return null;
      }
    } else {
      loginStatusCode = -2; // invalid version
      return null;
    }
  }

  static Future<List<User>> fetchUsers() async {
    //Uri.https(theSite, '/ci/mobile/emplogin?username=abd&password=123&api_key=2242021')
    Map<String, String> queryparm = {
      'username': 'abd',
      'password': '123',
      'api_key': '2242021'
    };
    final uri = Uri.https(theSite, 'ci/mobile/emplogin', queryparm);

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      // print("response code :" + response.body);
      return parseUsers(response.body);
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  static List<User> parseUsers(String response) {
    Iterable parsed = json.decode(response);
    List<User> validUsers = List.from(parsed.map((e) => User.fromMap(e)));
    // print("List count = :" + validUsers.length.toString());
    return validUsers;
  }

  static Future<List<Region>> getAllRegions() async {
    listRegion = List.empty(growable: true);
    Map<String, String> queryparm = {
      'api_key': '2242021',
      'region_name': RestManager.userName
    };
    print("curretn username :" + RestManager.userName);
    final uri = Uri.https(theSite, 'ci/mobile/getallregions', queryparm);

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      // print(response.body);
      Iterable parsed = json.decode(response.body);
      listRegion = List.from(parsed.map((e) => Region.fromMap(e)));
    }
    return listRegion;
  }

  static Future<List<Street>> getRegionStreets(String regionId) async {
    listStreets = List.empty(growable: true);
    Map<String, String> queryparm = {
      'api_key': '2242021',
      'region_id': regionId
    };
    final uri = Uri.https(theSite, 'ci/mobile/getRegionStreets', queryparm);

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      // print(response.body);
      Iterable parsed = json.decode(response.body);
      listStreets = List.from(parsed.map((e) => Street.fromMap(e)));
    }
    return listStreets;
  }

  static Future<List<Street>> getAllStreets() async {
    listStreets = List.empty(growable: true);
    Map<String, String> queryparm = {'api_key': '2242021'};
    final uri = Uri.https(theSite, 'ci/mobile/getallstreets', queryparm);

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      // print(response.body);
      Iterable parsed = json.decode(response.body);
      listStreets = List.from(parsed.map((e) => Street.fromMap(e)));
    }
    return listStreets;
  }

  static getPrice() async {
    final uri = Uri.https(theSite, 'ci/mobile/getprice');

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      Map<String, dynamic> result = json.decode(response.body);
      costPrice = double.parse(result['cost_price']);
    }
  }

  static Future<int> saveNewPayment(
      // حفظ دفعة مالية خاصة بالزبون
      double payvalue,
      Period currentPeriod) async {
    Map<String, String> queryparm = {
      'api_key': '2242021',
      'bill_id': currentPeriod.billId.toString(),
      'payment_value': payvalue.toString(),
      'payment_discount': '0',
      'payment_note': 'تطبيق الموبايل'
    };

    //print('payment value :$payvalue and billid:$currentPeriod.billId');
    var response;
    try {
      final uri = Uri.https(theSite, 'ci/mobile/payment_insert');
      response = await http
          .post(uri, body: queryparm)
          .timeout(new Duration(seconds: 20));
    } on TimeoutException catch (_) {
      throw MyException(msg: 'حدث خطأ اثناء الاتصال', exceptionType: 1);
    } on SocketException catch (_) {
      throw MyException(msg: 'حدث خطأ اثناء الاتصال', exceptionType: 2);
    }
    //  print(response.body);
    if (response.statusCode == 200) {
      //  print(response.body);
      Map<String, dynamic> result = json.decode(response.body);
      if (result['status'].toString() == 'Success') {
        return 0;
      } else if (result['complete'].toString() == 'true') {
        return 1;
      }
      //  print(result.toString());
    } else {
      return -1;
    }

    return -1;
  }

  static Future<int> SaveCustomer(
      int customerid,
      String customerName,
      String customerMobile,
      String customerStreet,
      String customerOrder) async {
    int retvalue = -1;
    print("\n >>> Customer Order value:" + customerOrder);

    Map<String, String> queryparm = {
      'customer_id': customerid.toString(),
      'customer_name': customerName,
      'customer_jawwal': customerMobile,
      'customer_street': customerStreet,
      'customer_order': customerOrder,
    };

    var response;
    var uri = Uri.https(theSite, 'ci/mobile/customer_insert');
    try {
      if (customerid != -1) {
        uri = Uri.https(theSite, 'ci/mobile/customer_update');
      }
      print(">>> current operation:" + customerid.toString());

      response = await http.post(uri, body: queryparm);
      print(">>>>");
      print(response.body);
    } on TimeoutException catch (_) {
      throw Exception("Error, check internet connection");
    } on SocketException catch (_) {
      throw Exception("Error, check internet connection");
    }

    if (response.statusCode == 200) {
      print(response.body);
      Map<String, dynamic> result = json.decode(response.body);
      if (result['status'].toString() == 'error') {
        throw MyException(msg: 'unable to save', exceptionType: 1);
      } else if (result['status'].toString() == 'Success') {
        retvalue = 0;
      }
    } else {
      // print(response.body);
      throw new Exception("Invalid data type");
    }

    return retvalue;
  }

  static Future<int> deleteCustomer(int customerid) async {
    int retvalue = -1;

    Map<String, String> queryparm = {
      'customer_id': customerid.toString(),
      'api_key': '306090306090',
    };

    var response;
    var uri = Uri.https(theSite, 'ci/mobile/customer_delete');
    try {
      print(">>> current operation:" + customerid.toString());

      response = await http.post(uri, body: queryparm);
      print(">>>>");
      print(response.body);
    } on TimeoutException catch (_) {
      throw Exception("Error, check internet connection");
    } on SocketException catch (_) {
      throw Exception("Error, check internet connection");
    }

    if (response.statusCode == 200) {
      print(response.body);
      Map<String, dynamic> result = json.decode(response.body);
      if (result['status'].toString() == 'error') {
        throw MyException(msg: 'unable to save', exceptionType: 1);
      } else if (result['status'].toString() == 'success') {
        retvalue = 0;
      }
    } else {
      // print(response.body);
      throw new Exception("Invalid data type");
    }

    print(">> delete customer done: " + retvalue.toString());

    return retvalue;
  }

  static Future<int> saveNewReading(double newReading, Period oldperiod) async {
    int retvalue = -1;
    double oldReading = 0;
    if (!oldperiod.zeroPeriod) {
      oldReading = oldperiod.periodReading;
    }
    var currentDate = DateTime.now();
    // Map<String, String> headers = {"Content-type": "application/json"};
    Map<String, String> queryparm = {
      'api_key': '2242021',
      'period_reading_date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'period_date': DateFormat('yyyy-MM-01').format(currentDate),
      'period_customer': oldperiod.customerId.toString(),
      'period_reading': newReading.toString(),
      'period_previous_reading': oldReading.toString(),
      'payment_value': '',
      'period_price': '',
      'payment_discount': '',
      'period_note': '',
      'period_add_money': ''
    };
    // send request to .main/period_insert
    var response;
    try {
      final uri = Uri.https(theSite, 'ci/mobile/period_insert');
      response = await http.post(uri, body: queryparm);
      // print(response.body);
    } on TimeoutException catch (_) {
      throw Exception("Error, check internet connection");
    } on SocketException catch (_) {
      throw Exception("Error, check internet connection");
    }

    if (response.statusCode == 200) {
      print(response.body);
      Map<String, dynamic> result = json.decode(response.body);
      if (result['complete'].toString() == 'false') {
        throw MyException(msg: 'unable to save', exceptionType: 1);
      } else if (result['complete'].toString() == 'true') {
        oldperiod.periodReadingDate = currentDate;
        if (result.containsKey('bill_sum')) {
          try {
            oldperiod.customerBillSum +=
                double.parse(result['bill_sum'].toString());
          } catch (ee) {}
        }

        retvalue = 0;
      }
    } else {
      // print(response.body);
      throw new Exception("Invalid data type");
    }
    return retvalue;
  }

  static Future<List<Period>> getAllCustomersPeriods(
      int streetId, int screenType, int regionID) async {
    List<Period> listPeriods = List.empty(growable: true);
    Map<String, String> queryparm = {
      'api_key': '2242021',
      'street_id': streetId.toString(),
      'region_id': regionID.toString(),
      'current_date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'screen_type': screenType.toString()
    };

    //print("Current Street ID: " + streetId.toString());
    var response;
    try {
      final uri =
          Uri.https(theSite, 'ci/mobile/GetPeriodForAllCustomers', queryparm);
      response = await http.get(uri).timeout(new Duration(seconds: 10));
    } on TimeoutException catch (_) {
      throw MyException(msg: 'حدث خطأ اثناء الاتصال', exceptionType: 1);
    } on SocketException catch (_) {
      throw MyException(msg: 'حدث خطأ اثناء الاتصال', exceptionType: 1);
    }
    if (response.statusCode == 200) {
      // print("Periods here");
      print(response.body);
      Iterable parsed = json.decode(response.body);
      listPeriods = List.from(parsed.map((e) => Period.fromMap(e)));
    } else {
      // print(response.body);
      throw new Exception("Invalid data type");
    }
    return listPeriods;
  }
}
