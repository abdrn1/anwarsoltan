import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'config/routes/custom_routes.dart';
import 'config/themes/custom_colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'مولدات المدينة',
      theme: ThemeData(
        fontFamily: 'Cairo',
        backgroundColor: kScaffoldColor,
        appBarTheme: AppBarTheme(
          color: kAppbarColor,
          elevation: 0.0,
          textTheme: TextTheme(
            headline6: TextStyle(
              color: kWhiteColor,
              fontSize: 20,
              fontFamily: 'Cairo',
            ),
          ),
        ),
      ),
      initialRoute: '/', //'test-http'
      routes: customRoutes,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale("ar", ""),
      ],
    );
  }
}
