import 'package:ausa/config/config.dart';
import 'package:ausa/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() {
  // DependencyInject().init();
  runApp(
    Container(
      alignment: Alignment.center,
      color: Colors.grey[200],
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 375, maxHeight: 812),
        child: MyApp(),
      ),
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ausa Health',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
          ),
        ),
      ),
      initialBinding: AppBinding(),
      initialRoute: AppPages.initialRoute,
      getPages: AppPages.pages,
      unknownRoute: AppPages.unknownRoute,
    );
  }
}
