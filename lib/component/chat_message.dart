import 'package:flutter/material.dart';
import 'package:front_nearby/thema/palette.dart';

import '../data/Chat.dart';

class ChatMessage extends StatelessWidget {
  final Chat chat;
  final Animation<double> animation;

  const ChatMessage(
      this.chat, {
        required this.animation,
        Key? key,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (chat.text == ' ' || chat.text == '' || chat.text == null)
        ? Container()
        : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            axisAlignment: -1.0,
            child: chat.who
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                    children: [
                      Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            constraints: BoxConstraints(
                              minHeight: 35,
                            ),
                            child: CircleAvatar(
                              backgroundColor: Colors.black12,
                              child: SizedBox(
                                  height: 60,
                                  width: 60,
                                  child: Image.asset('assets/logo-noback.png')
                              )
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                      SizedBox(width: 8),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: 250,
                          ),
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                                bottomRight: Radius.circular(5),
                              )
                          ),
                          child: Text(chat.text,
                              style: TextStyle(fontSize: 18)),
                        ),
                      ),
                  ],
                )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.all(8),
                          width: 250,
                          decoration: BoxDecoration(
                            color: Palette.newBlue,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                                bottomRight: Radius.circular(5),
                            )
                          ),
                          child: Text(
                            chat.text,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 18),
                    ].reversed.toList(),
                  ),
          ),
        ),
      );
  }
}
