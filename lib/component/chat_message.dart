import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String txt;
  final Animation<double> animation;

  const ChatMessage(
      this.txt, {
        required this.animation,
        Key? key,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: FadeTransition(
        opacity: animation,
        child: SizeTransition(
          sizeFactor: animation,
          axisAlignment: -1.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: CircleAvatar(
                  backgroundColor: Colors.black12,
                  child: SizedBox(
                      height: 90,
                      width: 90,
                      child: Image.asset('assets/logo-noback.png')
                  )
                ),
              ),
              SizedBox(width: 18),
              Expanded(
                child: Text(txt, style: TextStyle(fontSize: 18)),
            ),
          ],),
        ),
      ),
    );
  }
}
