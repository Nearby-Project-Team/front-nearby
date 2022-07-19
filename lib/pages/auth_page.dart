import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:front_nearby/palette.dart';

import '../provider/page_notifier.dart';

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
                  padding: EdgeInsets.all(16),
                  children: [
                    SizedBox(height: 50),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black26, spreadRadius: 3)],
                      ),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 36,
                        child: Image.asset('assets/logo-noback.png'),
                      ),
                    ),
                    SizedBox(height: 50),
                    Text("Log in",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Palette.newBlue,

                      ),
                    ),
                    SizedBox(height: 16),
                    _buildTextFormField("보호자 이메일", _caregiverEmailController),
                    SizedBox(height: 8),
                    _buildTextFormField("본인 이름", _elderlyNameController),
                    SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        if(_formkey.currentState!.validate())
                          {
                            // Logger().d('모든 값이 올바름!');
                            Provider.of<PageNotifier>(context, listen: false)
                                .goToMain();
                          }
                      },
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Palette.newBlue,
                        textStyle: TextStyle(fontSize: 20), 
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(_cornerRadius)
                        )// foreground
                      ),
                      child: Text("LOGIN"),)
                  ],
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
