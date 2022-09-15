import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:front_nearby/component/chat_message.dart';
import 'package:front_nearby/data/Chat.dart';
import 'package:front_nearby/pages/auth_page.dart';
import 'package:front_nearby/provider/page_notifier.dart';
import 'package:front_nearby/thema/palette.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../api/init.dart';
import '../api/socket/StreamSocket.dart';
import '../api/socket/connect.dart';

class HomePage extends StatefulWidget{
  static final String pageName = 'Homepage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<AnimatedListState> _animListKey = GlobalKey<AnimatedListState>();
  List<Chat> _chats = [];
  static final storage = FlutterSecureStorage();

  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _isWaiting = false;
  String _text = ' ';

  FlutterSoundPlayer? myPlayer;
  bool playCheck = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    Future.microtask(() async{
      myPlayer = (await FlutterSoundPlayer().openAudioSession())!;
    });

    WidgetsBinding.instance.addPostFrameCallback((_){
      connectAndListen();
    });
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
  }

  @override
  void dispose(){
    if (myPlayer != null)
    {
      myPlayer?.closeAudioSession();
      myPlayer = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("벗",
          style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: (){
            storage.delete(key: "login");
            storage.delete(key: "userId");
            Provider.of<PageNotifier>(context, listen: false)
                .goToOtherPage(AuthPage.pageName);
            disconnectSocket();
          })
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child:AnimatedList(
                padding: EdgeInsets.only(top: 8.0),
                key: _animListKey,
                reverse: true,
                itemBuilder: _buildItem,
              )),
          //BuildWithSocketStream(),
          Container(
            padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 130.0),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(_text, style: TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(
            width: 0.8,
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 55.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
              onPressed: _isWaiting ? (){}:_listen,
              child: _isWaiting ? Icon(Icons.downloading)
              : Icon(_isListening ? Icons.mic : Icons.mic_none),
              backgroundColor: _isWaiting? Colors.grey:Palette.newBlue,
        ),
      ),
    );
  }



  Widget _buildItem(context, index, animation){
    return ChatMessage(_chats[index], animation: animation);
  }

  void _handleSubmitted (String text, bool who) async {
    _chats.insert(0, Chat(text: text, who: who));
    _animListKey.currentState?.insertItem(0);
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      _text = ' ';
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
          }),
          localeId: 'ko',
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();

      _handleSubmitted(_text, false);
      sendMessage(_text);

      playMyFile();
    }
  }

  Future<void> playMyFile() async{
    PermissionStatus status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) throw RecordingPermissionException("Microphone permission not granted");
    setState((){_isWaiting = !_isWaiting;});

    print(_isWaiting);
    Future.delayed(const Duration(milliseconds: 3000), () async
    {
      _handleSubmitted(getResText(), true);
      setState((){_isWaiting = !_isWaiting;});
      print(_isWaiting);
      setState((){_text = ' ';});
      if(playCheck){
        Directory tempDir = await getTemporaryDirectory();
        String outputFile = '${tempDir.path}/message-test.wav';
        try{
          setState(() {
            playCheck = !playCheck;
          });
          await myPlayer?.startPlayer
            (
                fromURI: outputFile,
                codec: Codec.pcm16,
                numChannels: 1,
                sampleRate: 22050, // Used only with codec == Codec.pcm16
                whenFinished: ()=>{},
            );
          }
        catch(e){print("NO Data");}
        return;
     }
    });

    await myPlayer?.stopPlayer();
    setState(() {
      playCheck = !playCheck;
    });
    print("PLAY STOP!!");

    return;
  }
}


StreamSocket streamSocket = StreamSocket();
Stream<String> stream = streamSocket.getResponse;


class BuildWithSocketStream extends StatelessWidget {
  const BuildWithSocketStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot){
        return Container(
          child: Text(snapshot.data.toString()),
        );
      },
    );
  }
}