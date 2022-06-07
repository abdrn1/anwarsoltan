import 'package:anwar_alsultan/config/themes/custom_colors.dart';
import 'package:anwar_alsultan/model/models.dart';
import 'package:anwar_alsultan/ui/shared/widgets/custom_flatbtn.dart';
import 'package:anwar_alsultan/ui/view/read/read_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:anwar_alsultan/Controller/RestManager.dart';

class ReadScreen extends StatefulWidget {
  static const routeName = 'read-screen';
  Period priodItem;
  ReadScreen({this.priodItem});
  @override
  _ReadScreenState createState() => _ReadScreenState(this.priodItem);
}

class _ReadScreenState extends State<ReadScreen> {
  Period priodItem;
  TextEditingController textControllerNewReading = TextEditingController();
  _ReadScreenState(this.priodItem);
  bool isloading = false;

  void saveNewReading(BuildContext context) {
    double newRead = double.parse(textControllerNewReading.text);
    print(priodItem.periodReading);

    if (newRead < priodItem.periodReading && priodItem.zeroPeriod == false) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("تنبه"),
              content: Text("قيمة القراءة الحالية اقل من السابقة"),
              actions: <Widget>[
                TextButton(
                  child: Text('تـم'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    } else {
      setState(() {
        isloading = true;
      });

      RestManager.saveNewReading(newRead, priodItem).then((int value) {
        FocusManager.instance.primaryFocus?.unfocus();
        setState(() {
          isloading = false;
        });
        if (value == 0) {
          var oldReading = priodItem.periodReading;
          if (priodItem.zeroPeriod) {
            oldReading = 0;
          }
          priodItem.lockInterval = true;

          priodItem.periodReadingDate = priodItem.periodReadingDate;

          //priodItem.customerBillSum +=
           //   ((newRead - oldReading) * RestManager.costPrice);
           
          priodItem.periodReading = newRead;

          Navigator.pop(context);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('تم الحفظ بنحاج')));
        } else {
          RestManager.showModel('لا يمكن الحفظ', context);
        }
      }).catchError((e) {
        print("error done here");
        RestManager.showModel('حدث خطأ اثناء عملية الحفظ', context);
        setState(() {
          isloading = false;
        });
      });
    }
    // Now send result to server
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print(priodItem != null ? this.priodItem.customerName : '');

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
                  SizedBox(height: size.height * .07),
                  Row(
                    children: [
                      const SizedBox(width: 24),
                      Text(
                        'قراءة',
                        style: TextStyle(
                          color: kFontPrimaryColor,
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ReadCard(
                    periodItem: this.priodItem,
                    textControlllerNewReading: this.textControllerNewReading,
                  ),
                  const SizedBox(height: 16),
                  isloading
                      ? CircularProgressIndicator(
                          strokeWidth: 3,
                        )
                      : CustomFlatBtn(
                          onPressed: () {
                            //Navigator.pop(context);
                            saveNewReading(context);
                          },
                          color: kBtnPrimaryColor,
                          height: 50,
                          text: 'حفظ',
                          width: size.width * .9,
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
