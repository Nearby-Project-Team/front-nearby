import 'dart:io';

import 'package:front_nearby/api/socket/connect.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../data/user.dart';

const String urlString = 'api-test.nearbycrew.com:8443';

User _user = User(elderlyId: "test");
bool _isConnect = false;

void setConnect (){
  _isConnect = !_isConnect;
}

bool getConnect (){
  return _isConnect;
}

void setResText (text) async{
  print(text);
  if(text is String) {
    _user.setResText(text);
    return;
  }
  else
  {
    _user.setResText(text["msg"]);
    return;
  }
}

String getResText (){
  return _user.resText;
}

void resetResText (){
  _user.resText = ' ';
}

void setUser (User user) async{
  _user = user;
}

void setUserID (id) async{
  _user.elderlyId = id;
}

String getUserID (){
  return _user.elderlyId;
}

void testMain() async {
  var url = Uri.https(urlString, "/auth/agreement");
  var response = await http.post(url, body: {"email" : "kimh060612@khu.ac.kr"});
  print(response.body.toString());
}

void saveWav (data) async{
  try{
    Directory tempDir = await getTemporaryDirectory();
    File resultFile = File('${tempDir.path}/message-test.wav');
    resultFile.writeAsBytes(data);
  }catch (e){
    print(e);
  }
}