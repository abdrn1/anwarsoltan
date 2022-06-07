import 'package:anwar_alsultan/Controller/RestManager.dart';
import 'package:anwar_alsultan/config/themes/custom_colors.dart';
import 'package:anwar_alsultan/model/models.dart';
import 'package:anwar_alsultan/ui/shared/widgets/custom_flatbtn.dart';
import 'package:anwar_alsultan/ui/view/chooser_screen.dart';
import 'package:anwar_alsultan/ui/view/login/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:progress_dialog/progress_dialog.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = 'login-screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _controllerUser = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  User validUser;
  ProgressDialog pr;

  Future<void> doLogin() async {
    if (_controllerPassword.text.isEmpty || _controllerUser.text.isEmpty) {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // Retrieve the text the that user has entered by using the
            // TextEditingController.
            content: Text('الرجاء تعبئة المستخدم وكلمة المرو'),
          );
        },
      );
    }

    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.show();

    validUser =
        await RestManager.login(_controllerUser.text, _controllerPassword.text);
    if (validUser != null) {
      pr.hide();
      Navigator.of(context)
          .pushNamedAndRemoveUntil(ChooserScreen.routeName, (route) => false);
      /*Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChooseScreen()),
      );*/
    } else {
      await pr.hide();
      if (RestManager.loginStatusCode == -2) {
        RestManager.showModel(
            "هذه النسخة من التطبيق قديمة يرجى التحديث", context);
      } else {
        RestManager.showModel("اسم مستخدم وكلمة مرور خاطئة", context);
      }
    }
  }

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
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    RestManager.version,
                    style: TextStyle(
                      color: kFontPrimaryColor,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 25),
                  TextFieldWidget(
                    hint: 'اسم الستخدم',
                    controller: _controllerUser,
                    obscureText: false,
                  ),
                  const SizedBox(height: 16),
                  TextFieldWidget(
                    hint: 'كلمة المرور',
                    controller: _controllerPassword,
                    obscureText: true,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      SizedBox(width: size.width * .22),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          'هل نسيت كلمة السر؟',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  CustomFlatBtn(
                    onPressed: () {
                      //  Navigator.of(context).pushNamedAndRemoveUntil(
                      //        HomeScreen.routeName, (route) => false);
                      doLogin()
                          .then((value) => print("hello there"))
                          .catchError((e) {
                        print(e);
                        pr.hide();
                        RestManager.showModel('خطا اثناء الاتصال', context);
                      });
                    },
                    width: size.width * .6,
                    height: 50,
                    text: 'دخول',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
