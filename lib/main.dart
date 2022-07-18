import 'package:flutter/material.dart';
import 'package:front_nearby/pages/home_page.dart';
import 'package:front_nearby/palette.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Palette.newBlue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Navigator(
          pages:[
            MaterialPage(
                key: ValueKey(HomePage.pageName),
                child: HomePage())
          ],
        onPopPage: (route, result){
            if(!route.didPop(result)){
              return false;
            }
            return true;
        },
      ),
    );
  }
}


