import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:front_nearby/thema/palette.dart';

import '../api/auth/login.dart';
import '../provider/page_notifier.dart';
import 'home_page.dart';

class AuthPage extends Page{

  static final pageName = 'AuthPage';

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(settings:this, builder: (context)=>AuthWidget());
  }
}

class AuthWidget extends StatefulWidget {
  const AuthWidget({Key? key}) : super(key: key);

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController _caregiverEmailController = TextEditingController();
  TextEditingController _elderlyNameController = TextEditingController();

  String userInfo = "";
  static final storage = new FlutterSecureStorage();

  @override
  void initState(){
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_){
      _asyncMethod();
    });
  }

  _asyncMethod() async {
    userInfo = (await storage.read(key: "login"))!;

    if(userInfo != null)
    {
      loginUser(userInfo.split(" ")[1], userInfo.split(" ")[3]);

      Provider.of<PageNotifier>(context, listen: false)
          .goToOtherPage(HomePage.pageName);
    }
  }

  static final double _cornerRadius = 3.0;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Form(
                key: _formkey,
                child: ListView(
                  reverse: true,
                  padding: EdgeInsets.all(16),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 5,
                                  color: Colors.black26,
                                  spreadRadius: 3)
                            ],
                          ),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 36,
                            child: Image.asset('assets/logo-noback.png'),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          "벗",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Palette.newBlue),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("친근한 목소리를 가진",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,)),
                        Text("노인 맞춤 인공지능 비서",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,)),
                      ],
                    ),
                    SizedBox(height: 100),
                    Text("로그인",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Palette.newBlue,

                      ),
                    ),
                    SizedBox(height: 16),
                    _buildTextFormField("보호자 이메일", _caregiverEmailController),
                    SizedBox(height: 8),
                    _buildTextFormField("본인 이름", _elderlyNameController),
                    SizedBox(height: 8),
                    TextButton(
                      onPressed: () async {
                        var check = "";
                        if(_formkey.currentState!.validate())
                          {
                             await loginUser(
                                _caregiverEmailController.text,
                              _elderlyNameController.text
                            ).then((value) => {
                              setState((){
                                check = value;
                              })
                            });

                            if((check != "400") && (check != "402") && (check != "500") && (check != ""))
                              {
                                await storage.write(key: "userId", value: check);
                                await storage.write(
                                    key: "login",
                                    value: "email ${_caregiverEmailController.text} name ${_elderlyNameController.text}"
                                );

                                await permission();
                                Provider.of<PageNotifier>(context, listen: false)
                                    .goToMain();
                              }
                          }
                      },
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Palette.newBlue,
                        textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(_cornerRadius)),
                        padding: EdgeInsets.all(16),
                      ),
                      child: Text("LOGIN"),),
                    SizedBox(height: 30),
                  ].reversed.toList(),
                ),
              ),
            ),
          )
        )
      ),
    );
  }

  TextFormField _buildTextFormField(String lableText, TextEditingController controller) {
    return TextFormField(
        controller: controller,
        validator: (text){
          if(text == null || text.isEmpty)
            {
              return "입력창이 비어있어요!";
            }
          return null;
        },
        style: TextStyle(fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          labelText: lableText,
          border: OutlineInputBorder(
              borderSide: BorderSide(width: 10),
              borderRadius: BorderRadius.circular(_cornerRadius)),
          labelStyle: TextStyle(color: Colors.black54)
        )
      );
  }
}


Future<bool> permission() async {
  Map<Permission, PermissionStatus> status =
  await [Permission.speech, Permission.storage].request(); // [] 권한배열에 권한을 작성

  if (await Permission.speech.isGranted && await Permission.storage.isGranted) {
    return Future.value(true);
  } else {
    return Future.value(false);
  }
}
