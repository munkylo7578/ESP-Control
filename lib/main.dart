import 'package:ecommerce/pages/mainPage.dart';
import 'package:ecommerce/pages/screen/BalancingRobotScreen.dart';
import 'package:ecommerce/pages/screen/CategoryScreen.dart';
import 'package:ecommerce/pages/welcomePage.dart';
import 'package:ecommerce/pages/welcomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/utils/utils.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  await Hive.initFlutter();
  var box = await Hive.openBox('userInfo');
  dynamic isLogin = box.get('token');
  runApp(ecommerce(
    isLogin: isLogin,
  ));
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class ecommerce extends StatelessWidget {
  dynamic isLogin;
  ecommerce({Key? key, required this.isLogin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      builder: FToastBuilder(),
      debugShowCheckedModeBanner: false,
      home: isLogin != null ? CategoryScreen() : welcomeScreen(),
      theme: ThemeData(primarySwatch: Colors.purple),
    );
  }
}
