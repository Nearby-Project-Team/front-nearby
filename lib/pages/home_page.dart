import 'package:flutter/material.dart';
import 'package:front_nearby/component/chat_message.dart';
import 'package:front_nearby/pages/auth_page.dart';
import 'package:front_nearby/palette.dart';
import 'package:front_nearby/provider/page_notifier.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget{
  static final String pageName = 'Homepage';
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<AnimatedListState> _animListKey = GlobalKey<AnimatedListState>();
  final TextEditingController _textEditingController = TextEditingController();
  List<String> _chats = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("벗",
          style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: (){
            Provider.of<PageNotifier>(context, listen: false)
                .goToOtherPage(AuthPage.pageName);
          })
        ],
      ),
      
      body: Column(
        children: [
          Expanded(
            child:AnimatedList(
              key: _animListKey,
              reverse: true,
              itemBuilder: _buildItem,
          )),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textEditingController,
                      decoration: InputDecoration(hintText: "메시지 입력창"),
                      onSubmitted: _handleSubmitted,
                    ),
                  ),
                  const SizedBox(
                    width: 0.8,
                  ),
                  IconButton(onPressed: (){
                    _handleSubmitted(_textEditingController.text);
                  },
                    icon: Icon(Icons.send),
                    color: Palette.newBlue,
                  )
                ]
            ),
          ),
        ],
      )
    );
  }

  Widget _buildItem(context, index, animation){
    return ChatMessage(_chats[index], animation: animation);
  }

  void _handleSubmitted(String text){
    Logger().d(text);
    _textEditingController.clear();
    _chats.insert(0, text);
    _animListKey.currentState?.insertItem(0);
  }
}