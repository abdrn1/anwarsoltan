import 'package:anwar_alsultan/config/themes/custom_colors.dart';
import 'package:anwar_alsultan/model/models.dart';
import 'package:anwar_alsultan/ui/shared/widgets/custom_flatbtn.dart';
import 'package:anwar_alsultan/ui/view/customer/customer_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:anwar_alsultan/Controller/RestManager.dart';

class CustomerScreen extends StatefulWidget {
  static const routeName = 'customer-screen';
  Period priodItem;
  List<Region> listAreas;
  List<Street> listStreets;

  CustomerScreen(this.priodItem, this.listAreas, this.listStreets);
  @override
  _CustomerScreenState createState() =>
      _CustomerScreenState(this.priodItem, listAreas, listStreets);
}

class _CustomerScreenState extends State<CustomerScreen> {
  Period priodItem;
  List<Region> listAreas;
  List<Street> listStreets;
  TextEditingController textControllerNewReading = TextEditingController();
  _CustomerScreenState(this.priodItem, this.listAreas, this.listStreets);
  bool isloading = false;

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
                        'إضافة او تعديل مشترك',
                        style: TextStyle(
                          color: kFontPrimaryColor,
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  CustomerCard(this.priodItem, listAreas, listStreets)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
