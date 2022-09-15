import 'package:flutter/material.dart';
import 'package:front_nearby/pages/auth_page.dart';
import 'package:front_nearby/pages/home_page.dart';
import 'package:front_nearby/thema/palette.dart';
import 'package:front_nearby/provider/page_notifier.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_)=>PageNotifier())],
      child: MaterialApp(
        title: 'Nearby project elderly.ver',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Palette.newBlue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Consumer<PageNotifier>(
          builder: (context, pageNotifier, child){
            return Navigator(
              pages:[
                MaterialPage(
                    key: ValueKey(AuthPage.pageName),
                    child: HomePage()),
                if(pageNotifier.currentPage == AuthPage.pageName)  AuthPage(),
              ],
              onPopPage: (route, result){
                if(!route.didPop(result)){
                  return false;
                }
                return true;
              },
            );
          },
        ),
      ),
    );
  }
}


