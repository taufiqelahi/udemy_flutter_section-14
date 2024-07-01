import 'package:flutter/material.dart';
import 'package:udemy_flutter_section14/components/new_messages.dart';
import 'package:udemy_flutter_section14/screen/message_screen.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class UserChatScreen extends StatefulWidget {
  const UserChatScreen({super.key, required this.userId, required this.userName});
  final String userId;
  final String userName;

  @override
  State<UserChatScreen> createState() => _UserChatScreenState();

}

class _UserChatScreenState extends State<UserChatScreen> {
  @override
  // void initState() {
  //   // TODO: implement initState
  //   ZegoUIKitPrebuiltCallInvitationService().init(
  //     appID: 1645737866 /*input your AppID*/,
  //     appSign: '8ad90ea594b0dcbf17a80f842142001274f087cfd2dba8492746745ff1c5a348' /*input your AppSign*/,
  //     userID: widget.userId,
  //     userName: widget.userName,
  //     plugins: [ZegoUIKitSignalingPlugin()],
  //     requireConfig: (ZegoCallInvitationData data) {
  //       final config = ZegoUIKitPrebuiltCallConfig.groupVideoCall();
  //       config.videoConfig = ZegoUIKitVideoConfig.preset1080P();
  //       return config;
  //     },
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('Chat with ${widget.userName}'),

        actions: [
          ZegoSendCallInvitationButton(
            iconSize: Size(50, 50),
            isVideoCall: true,
            //You need to use the resourceID that you created in the subsequent steps.
            //Please continue reading this document.
            resourceID: "zegouikit_call",
            invitees: [
              ZegoUIKitUser(
                id: widget.userId,
                name: widget.userName,
              ),


            ],
          )

        ],

      ),
      body: Column(children: [
        Expanded(child: MessageScreen(userId: widget.userId, userName: widget.userName,),),
        NewMessages()
      ],),
    );
  }
}
