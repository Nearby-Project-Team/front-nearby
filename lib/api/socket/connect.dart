import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

import '../init.dart';

IO.Socket socket = IO.io('wss://ws-test.nearbycrew.com:8443/chat');

void connectAndListen(){
// 26f0e561-f107-4870-a11f-0e5ad78a19c0
// userInfo.split(" ")[1]
  socket = IO.io('wss://ws-test.nearbycrew.com:8443/chat',
      OptionBuilder()
          .setTransports(['websocket']) // for Flutter or Dart VM
          .setExtraHeaders({'cookie': 'user_type=Elderly; user_info=26f0e561-f107-4870-a11f-0e5ad78a19c0'}) // optional
          .build());

  socket.onConnect((_) {
    setConnect();
    print('connect');
    socket.emit('enter_chat_room', '26f0e561-f107-4870-a11f-0e5ad78a19c0');
  });

  //When an event received from server, data is added to the stream
  socket.on('receive_message', (data) => {
    setResText(data)
  });

  socket.on('receive_voice', (data) => {
    saveWav(data)
  });
  socket.onDisconnect((_) => print('disconnect'));
}

void disconnectSocket(){
  socket.onDisconnect((_) => print('disconnect'));
}

void sendMessage(String text) {
  socket.emit('send_message_elderly', text);
}