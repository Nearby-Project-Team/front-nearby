import 'dart:convert';

import 'package:front_nearby/data/User.dart';

import '../init.dart';
import 'package:http/http.dart' as http;

Future<String> loginUser(email, name) async {
  var url = Uri.https(urlString, '/elderly/login');
  final response = await http.post(url, body: {'email': email, 'name': name});
  if(response.statusCode == 201)
  {
    final userMap = await json.decode(response.body);
    User.fromJson(userMap);
    setUserID(userMap['elderly_id']);

    return userMap['elderly_id'];
  }
  return response.statusCode.toString();
}