import 'package:anwar_alsultan/Controller/RestManager.dart';
import 'package:anwar_alsultan/config/themes/custom_colors.dart';
import 'package:anwar_alsultan/ui/shared/widgets/custom_flatbtn.dart';
import 'package:anwar_alsultan/ui/view/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChooserScreen extends StatefulWidget {
  static const routeName = 'chooser-screen';
  @override
  _ChooserScreenState createState() => _ChooserScreenState();
}

class _ChooserScreenState extends State<ChooserScreen> {
  void login(String username, String password) {}
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            bottom: -size.height * 0.5,
            right: -size.width * 0.2,
            child: Hero(
              tag: 'lightning',
              child: SvgPicture.asset('assets/images/lightning_opacity.svg'),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/images/lightning_splash.svg'),
                  Text(
                    RestManager.applicationName,
                    style: TextStyle(
                      color: kFontPrimaryColor,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 32),
                  CustomFlatBtn(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen(0)),
                      );
                    },
                    width: size.width * .6,
                    height: 50,
                    text: 'قراءة العداد',
                  ),
                  SizedBox(height: size.width * .02),
                  CustomFlatBtn(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen(1)),
                      );
                    },
                    width: size.width * .6,
                    color: nBlueColor,
                    height: 50,
                    text: 'تحصيل أرصدة',
                  ),
                  SizedBox(height: size.width * .02),
                  RestManager.userName == "Admin"
                      ? CustomFlatBtn(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen(2)),
                            );
                          },
                          width: size.width * .6,
                          color: Color(0xffE57373),
                          height: 50,
                          text: 'المشتركين',
                        )
                      : SizedBox(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
