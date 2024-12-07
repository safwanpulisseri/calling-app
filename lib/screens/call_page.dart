import 'dart:async';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:calling_app/core/theme/color/app_colors.dart';
import 'package:flutter/material.dart';
import '../core/util/agora_url.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;


 

class CallPage extends StatefulWidget {
  final String? channelName;
  final ClientRole? role;

  const CallPage({super.key, this.channelName, required this.role});

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
    _engine.destroy();
    super.dispose();
  }

  Future<void> initialize() async {
    if (appId.isEmpty) {
      setState(() {
        _infoString.add('APP ID IS MISSING, PLEASE ADD APP ID IN settings.dart');
        _infoString.add('Agora Engine is Not Starting');
      });
      return;
    }

    _engine = await RtcEngine.create(appId);

    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(widget.role!);

    _addAgoraEventHandlers();

    VideoEncoderConfiguration configuration =  VideoEncoderConfiguration();
    configuration.dimensions = const VideoDimensions(width: 1920,height: 1080);
    await _engine.setVideoEncoderConfiguration(configuration);

    await _engine.joinChannel(
       token,
       widget.channelName!,
      null,
      0,
    );
  }

  void _addAgoraEventHandlers() {
    _engine.setEventHandler(
      RtcEngineEventHandler(
      error: (code) {
        setState(() {
          final info = 'Error: $code';
          _infoString.add(info);
        });
      },
     joinChannelSuccess: (channel, uid, elapsed) {
  setState(() {
    final info = 'JoinChannel: $channel, uid: $uid';
    _infoString.add(info);
  });
},

      leaveChannel: (stats) {
        setState(() {
          _infoString.add('Leave Channel');
          _users.clear();
        });
      },
      userJoined: (uid, elapsed) {
        setState(() {
          final info = 'User Joined: $uid';
          _infoString.add(info);
          _users.add(uid);
        });
      },
      userOffline: (uid, reason) {
        setState(() {
          final info = ' User Offilne $uid';
          _infoString.add(info);
          _users.remove(uid);
        });
      },
      firstRemoteVideoFrame: (uid, width, height, elapsed) {
        final info = 'First Remote Video : $uid ${width}x $height';
        _infoString.add(info);
      },
    ));
  }
 Widget _viewRows() {
  final List<Widget> list = [];
  if (widget.role == ClientRole.Broadcaster) {
    list.add(const rtc_local_view.SurfaceView());
  }
  for (var uid in _users) {
    list.add(rtc_remote_view.SurfaceView(
      uid: uid,
      channelId: widget.channelName!,
    ));
  }
  final view = list;
  return Column(
    children: List.generate(
      view.length,
      (index) => Expanded(
        child: view[index],
        ),
    ),
  );
}


  Widget _toolbar(){
    if(widget.role == ClientRole.Audience) return const SizedBox();
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
