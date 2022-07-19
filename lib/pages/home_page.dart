import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:front_nearby/component/chat_message.dart';
import 'package:front_nearby/pages/auth_page.dart';
import 'package:front_nearby/palette.dart';
import 'package:front_nearby/provider/page_notifier.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class HomePage extends StatefulWidget{
  static final String pageName = 'Homepage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<AnimatedListState> _animListKey = GlobalKey<AnimatedListState>();
  final TextEditingController _textEditingController = TextEditingController();
  List<String> _chats = [];


  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = '버튼을 누르고 말하세요!';
  double _confidence = 1.0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("confident: ${(_confidence*100.0).toStringAsFixed(1)}%",
          style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: (){
            Provider.of<PageNotifier>(context, listen: false)
                .goToOtherPage(AuthPage.pageName);
          })
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child:AnimatedList(
              key: _animListKey,
              reverse: true,
              itemBuilder: _buildItem,
          )),
          //inputSendContainer(),
        ],
      )
    );
  }

  Container inputSendContainer() {
    return Container( // 입력창 & 전송버튼
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
                ),
              ]
          ),
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

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      _handleSubmitted(_text);
    }
  }
}