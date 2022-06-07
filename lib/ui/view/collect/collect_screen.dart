import 'package:anwar_alsultan/Controller/RestManager.dart';
import 'package:anwar_alsultan/config/themes/custom_colors.dart';
import 'package:anwar_alsultan/model/models.dart';
import 'package:anwar_alsultan/ui/shared/widgets/custom_flatbtn.dart';
import 'package:anwar_alsultan/ui/view/collect/collect_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CollectScreen extends StatefulWidget {
  static const routeName = 'collect-screen';
  Period periodItem;
  CollectScreen({this.periodItem});

  @override
  _CollectScreenState createState() =>
      _CollectScreenState(periodItem: this.periodItem);
}

class _CollectScreenState extends State<CollectScreen> {
  TextEditingController textEditingController = TextEditingController();
  Period periodItem;
  bool isLoading = false;
  _CollectScreenState({this.periodItem});

  void saveNewPayment(bool zeroCredit) {
    if (periodItem.customerBillSum <= 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('لا يوجد ديون لهذا الزبون')));
      return;
    }
    if (periodItem.lockPayment) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('تم الحفظ مسبقاً')));
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      isLoading = true;
    });
    double payvalue = 0;
    if (zeroCredit) {
      payvalue = periodItem.customerBillSum;
    } else {
      payvalue = double.parse(textEditingController.text);
    }

    if (payvalue <= 0) {
      RestManager.showModel('الرجاء ادخال قمية اكبر من صفر', context);
      textEditingController.text = '';
      setState(() {
        isLoading = false;
      });
      return;
    } else if (payvalue > periodItem.customerBillSum) {
      RestManager.showModel('قيمة الدفعة أكبر من ديون الزبون', context);
      textEditingController.text = '';
      setState(() {
        isLoading = false;
      });
      return;
    }

    RestManager.saveNewPayment(payvalue, periodItem).then((int value) {
      setState(() {
        isLoading = false;
      });
      if (value == 0) {
        setState(() {
          periodItem.lockPayment = true;
          periodItem.customerBillSum -= payvalue;
        });

        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('تم الحفظ بنحاج')));
      } else {
        RestManager.showModel('لا يمكن حفظ هذا السجل', context);
      }
    }).catchError((e) {
      setState(() {
        isLoading = false;
      });
      RestManager.showModel('حدث خطأ اثناء الحفظ', context);
    });
  }

  @override
  Widget build(BuildContext context) {
    print(this.periodItem.customerName);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -size.height * 0.3,
              left: -size.width * 0.2,
              child: SvgPicture.asset('assets/images/lightning_opacity.svg'),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: kFontPrimaryColor,
                  size: 28,
                ),
              ),
            ),
            Center(
              child: Column(
                children: [
                  SizedBox(height: size.height * .1),
                  Row(
                    children: [
                      const SizedBox(width: 24),
                      Text(
                        'دفعة مالية',
                        style: TextStyle(
                          color: kFontPrimaryColor,
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CollectCard(
                    periodItem: this.periodItem,
                    textEditingController: this.textEditingController,
                  ),
                  const SizedBox(height: 16),
                  isLoading
                      ? CircularProgressIndicator(
                          strokeWidth: 3,
                        )
                      : CustomFlatBtn(
                          onPressed: () {
                            //Navigator.pop(context);
                            saveNewPayment(false);
                          },
                          color: kBtnPrimaryColor,
                          height: 50,
                          text: 'حفظ',
                          width: size.width * .9,
                        ),
                  const SizedBox(height: 10),
                  !isLoading
                      ? CustomFlatBtn(
                          onPressed: () {
                            saveNewPayment(true);
                            //Navigator.pop(context);
                            // saveNewPayment();
                          },
                          color: Colors.blue[400],
                          height: 50,
                          text: 'تصفير الرصيد',
                          width: size.width * .9,
                        )
                      : const SizedBox(height: 5),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
