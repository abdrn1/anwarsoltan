class User {
  String get userState {
    if (userstate == null) {
      return "";
    } else {
      return userstate;
    }
  }

  User(this.userId, this.username, this.password, this.userType);
  int id;
  String userId;
  String username;
  String password;
  String userstate;
  int userType;

  factory User.fromMap(Map<String, dynamic> data) {
    return User(data['userid'], data['username'], data['passwrod'],
        int.parse(data['user_type']));
  }
}

class Region {
  int id;
  String name;
  Region(this.id, this.name);
  factory Region.fromMap(Map<String, dynamic> data) {
    return Region(int.parse(data['region_id']), data['region_name']);
  }
  @override
  String toString() {
    return this.name;
  }
}

class Street {
  int id;
  String name;
  int regionId;
  Street(this.id, this.name, this.regionId);
  factory Street.fromMap(Map<String, dynamic> data) {
    return Street(int.parse(data['street_id']), data['street_name'],
        int.parse(data['street_region']));
  }

  @override
  String toString() {
    return this.name;
  }
}

class Period {
  int customerId;
  String customerName;
  String customerMobile;
  int customerSerial = 1;
  int customerOrder;
  double customerPrice = 0.0;
  double customerBillSum = 0.0;
  int customerCounterId = -1;
  int periodId;
  DateTime periodReadingDate;
  DateTime periodMonthDate;
  double periodReading;
  double periodPreviousReading;
  String periodNote;
  int billId;
  double billConsumption;
  double billPaid;
  double billDiscount;
  double billReminder;
  int streetId;
  String streetName;
  int regionId;
  String RegionName;
  bool lockInterval = false;
  bool lockPayment = false;
  bool zeroPeriod = false;
  bool lockme = false;

  Period();
  factory Period.fromMap(Map<String, dynamic> data) {
    var per = Period();
    per.customerId = int.parse(data['customer_id']);
    per.customerName = data['customer_name'];
    per.customerMobile =
        data['customer_jawwal'] != null ? data['customer_jawwal'] : '';
    per.customerPrice = data['customer_price'] != null
        ? double.parse(data['customer_price'])
        : 0;
    per.customerBillSum =
        data['bill_sum'] != null ? double.parse(data['bill_sum']) : 0;
    per.periodId =
        data['period_id'] != null ? int.parse(data['period_id']) : -1;
    per.periodReadingDate = data['period_reading_date'] != null
        ? DateTime.tryParse(data['period_reading_date'])
        : null;
    per.periodMonthDate = data['period_date'] != null
        ? DateTime.parse(data['period_date'])
        : null;
    per.periodPreviousReading = data['period_previous_reading'] != null
        ? double.parse(data['period_previous_reading'])
        : 0;
    per.periodReading = data['period_reading'] != null
        ? double.parse(data['period_reading'])
        : 0;
    per.billId = data['bill_id'] != null ? int.parse(data['bill_id']) : -1;
    per.billConsumption = data['bill_consumption'] != null
        ? double.parse(data['bill_consumption'])
        : 0;
    per.billDiscount =
        data['bill_discount'] != null ? double.parse(data['bill_discount']) : 0;
    per.billPaid =
        data['bill_paid'] != null ? double.parse(data['bill_paid']) : 0;
    per.billReminder =
        data['bill_reminder'] != null ? double.parse(data['bill_reminder']) : 0;
    per.regionId = int.parse(data['region_id']);
    per.streetId = int.parse(data['street_id']);
    per.RegionName = data['region_name'];
    per.streetName = data['street_name'];
    per.customerOrder = data['customer_order'] != null
        ? int.parse(data['customer_order'])
        : null;
    return per;
  }
}

class MyException implements Exception {
  String msg;
  int exceptionType = -1;

  get message => this.msg;
  MyException({this.msg, this.exceptionType});
  String toString() {
    return msg;
  }
}
