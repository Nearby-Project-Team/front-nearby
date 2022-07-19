import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class speechButton extends StatelessWidget {

  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = '버튼을 누르고 말하세요!';
  double _confidenct = 1.0;

  @override
  void initState() {
    _speech = stt.SpeechToText();
  }


  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
