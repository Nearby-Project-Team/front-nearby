import 'package:flutter/material.dart';
import 'package:front_nearby/palette.dart';
import 'package:logger/logger.dart';

class HomePage extends StatefulWidget{
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat App"),
      ),
      body: Column(
        children: [
          Expanded(child:ListView(),),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textEditingController,
                      decoration: InputDecoration( hintText: "메시지 입력창"),
                      onSubmitted: _handleSubmitted,
                    ),
                  ),
                  const SizedBox(
                    width: 0.8,
                  ),
                  TextButton(
                      onPressed: (){
                        _handleSubmitted(_textEditingController.text);
                      },
                      style: TextButton.styleFrom(
                          primary: Palette.newBlue),
                      child: const Text("전송"))
                ]
            ),
          ),
        ],
      )
    );
  }

  void _handleSubmitted(String text){
    Logger().d(text);
    _textEditingController.clear();
  }
}