import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:calling_app/core/theme/color/app_colors.dart';
import 'package:flutter/material.dart';
import '../core/util/agora_url.dart';
// import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
// import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;


 


class CallPage extends StatefulWidget {
  final String channelName;
  final ClientRoleType role;

  const CallPage({
    super.key,
    required this.channelName,
    required this.role,
  });

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  final _users = <int>[];
  final _infoString = <String>[];
  bool muted = false;
  bool viewPanel = false;
  late RtcEngine _engine;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    _users.clear();
    _engine.leaveChannel();
    _engine.release();
    super.dispose();
  }

  Future<void> initialize() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(appId: appId));

    await _engine.setChannelProfile(ChannelProfileType.channelProfileLiveBroadcasting);
    await _engine.setClientRole(role: widget.role);

    _addAgoraEventHandlers();

    const config = VideoEncoderConfiguration(dimensions: VideoDimensions(width: 1920, height: 1080));
    await _engine.setVideoEncoderConfiguration(config);

    await _engine.enableVideo();

    await _engine.joinChannel(
      token: token,
      channelId: widget.channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  void _addAgoraEventHandlers() {
    _engine.registerEventHandler(RtcEngineEventHandler(
     onError: (ErrorCodeType code, String description) {
  setState(() {
    _infoString.add('Error: $code, Description: $description');
  });
},

      onJoinChannelSuccess: (connection, elapsed) {
        setState(() {
          _infoString.add('JoinChannel: ${connection.channelId}, uid: ${connection.localUid}');
        });
      },
      onUserJoined: (connection, uid, elapsed) {
        setState(() {
          _infoString.add('User Joined: $uid');
          _users.add(uid);
        });
      },
      onUserOffline: (connection, uid, reason) {
        setState(() {
          _infoString.add('User Offline: $uid');
          _users.remove(uid);
        });
      },
    ));
  }

Widget _viewRows() {
  final List<Widget> list = [];
  if (widget.role == ClientRoleType.clientRoleBroadcaster) {
    list.add(AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: _engine,
        canvas: const VideoCanvas(uid: 0),
      ),
    ));
  }
  for (var uid in _users) {
    list.add(AgoraVideoView(
      controller: VideoViewController.remote(
        rtcEngine: _engine,
        canvas: VideoCanvas(uid: uid),
        connection: RtcConnection(channelId: widget.channelName),
      ),
    ));
  }
  return Column(
    children: List.generate(
      list.length,
      (index) => Expanded(
        child: list[index],
      ),
    ),
  );
}



  Widget _toolbar(){
    if(widget.role == ClientRoleType.clientRoleAudience) return const SizedBox();
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:<Widget> [
       RawMaterialButton(onPressed: (){
             setState(() {
              muted=!muted;
             });
        _engine.muteLocalAudioStream(muted);

       },
       shape: const CircleBorder(),
       elevation: 2,
       fillColor: muted?AppColor.toneTwo:AppColor.background,
       padding: const EdgeInsets.all(20),
       child: Icon(muted?Icons.mic_off:Icons.mic,
       color: AppColor.toneTwo,
       size: 20,
       ),
       ),
       RawMaterialButton(onPressed: ()=>Navigator.pop(context),
       shape: const CircleBorder(),
       fillColor: AppColor.toneThree,
       padding: const EdgeInsets.all(15),
       child: const Icon(
        Icons.call_end,
        size: 35,
        color: AppColor.background,
       ),
       ),
         RawMaterialButton(onPressed: (){
          _engine.switchCamera();

         },
       shape: const CircleBorder(),
       fillColor: AppColor.background,
       padding: const EdgeInsets.all(12),
         
       child: const Icon(
        Icons.switch_camera,
        size: 20,
        color: AppColor.toneTwo,
       ),
       )
        ],
      ),
    );
  }
  Widget _panel(){
    return Visibility(
      visible: viewPanel,
      child: Container(
        padding: const  EdgeInsets.symmetric(vertical: 48),
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
          heightFactor: 0.5,
          child:  Container(
             padding: const EdgeInsets.symmetric(vertical: 48),
             child: ListView.builder(
               reverse: true,
               itemCount: _infoString.length,
               itemBuilder: (BuildContext context,int index){
                   if(_infoString.isEmpty){
                    return const Text('null');
                   }
                   return Padding(
                    padding: const EdgeInsets.symmetric(
                    vertical: 3,
                    horizontal: 10,

                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                      Flexible(child: Container(
                        padding:  const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,

                        ),
                        decoration: BoxDecoration(
                          color: AppColor.background,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _infoString[index],
                          style: const TextStyle(
                            color: AppColor.toneTwo,

                          ),
                        ),
                      ))
                    ],),
                    );
               },
             ),
          ),

        ),
      )
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Call'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
        setState(() {
          viewPanel =!viewPanel;
        });
          }, icon: const Icon(
            Icons.info_outline,

          ))
        ],
      ),
      backgroundColor: AppColor.secondary,
      body: Center(
        child: Stack(
          children:<Widget> [
            _viewRows(),
            _panel(),
            _toolbar(),
          ],
        ),
      ),

    );
  }
}
