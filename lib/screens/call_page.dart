import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import '../controllers/call_provider.dart';
import '../core/theme/color/app_colors.dart';
import '../core/util/agora_url.dart';


class CallPage extends ConsumerStatefulWidget {
  final String channelName;
  final ClientRoleType role;

  const CallPage({
    super.key,
    required this.channelName,
    required this.role,
  });

  @override
  ConsumerState<CallPage> createState() => _CallPageState();
}

class _CallPageState extends ConsumerState<CallPage> {
  late RtcEngine _engine;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    ref.read(usersProvider.notifier).state.clear();
    _engine.leaveChannel();
    _engine.release();
    super.dispose();
  }

  Future<void> initialize() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(appId: appId));

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
        ref.read(infoStringProvider.notifier).update((state) => [...state, 'Error: $code, Description: $description']);
      },
      onJoinChannelSuccess: (connection, elapsed) {
        ref.read(infoStringProvider.notifier).update((state) =>
            [...state, 'JoinChannel: ${connection.channelId}, uid: ${connection.localUid}']);
      },
      onUserJoined: (connection, uid, elapsed) {
        ref.read(usersProvider.notifier).update((state) => [...state, uid]);
        ref.read(infoStringProvider.notifier).update((state) => [...state, 'User Joined: $uid']);
      },
      onUserOffline: (connection, uid, reason) {
        ref.read(usersProvider.notifier).update((state) => state..remove(uid));
        ref.read(infoStringProvider.notifier).update((state) => [...state, 'User Offline: $uid']);
      },
    ));
  }

  Widget _viewRows() {
    final users = ref.watch(usersProvider);
    final role = widget.role;
    final list = <Widget>[];

    if (role == ClientRoleType.clientRoleBroadcaster) {
      list.add(AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: _engine,
          canvas: const VideoCanvas(uid: 0),
        ),
      ));
    }

    for (var uid in users) {
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

  Widget _toolbar() {
    if (widget.role == ClientRoleType.clientRoleAudience) return const SizedBox();

    final muted = ref.watch(mutedProvider);

    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: () {
              ref.read(mutedProvider.notifier).state = !muted;
              _engine.muteLocalAudioStream(!muted);
            },
            shape: const CircleBorder(),
            elevation: 2,
            fillColor: muted ? AppColor.toneFour : AppColor.background,
            padding: const EdgeInsets.all(20),
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: AppColor.toneTwo,
              size: 20,
            ),
          ),
          RawMaterialButton(
            onPressed: () => Navigator.pop(context),
            shape: const CircleBorder(),
            fillColor: AppColor.toneThree,
            padding: const EdgeInsets.all(15),
            child: const Icon(
              Icons.call_end,
              size: 35,
              color: AppColor.background,
            ),
          ),
          RawMaterialButton(
            onPressed: () {
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
          ),
        ],
      ),
    );
  }

  Widget _panel() {
    final viewPanel = ref.watch(viewPanelProvider);
    final infoString = ref.watch(infoStringProvider);

    return Visibility(
      visible: viewPanel,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 48),
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
          heightFactor: 0.5,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: ListView.builder(
              reverse: true,
              itemCount: infoString.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                          decoration: BoxDecoration(
                            color: AppColor.background,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            infoString[index],
                            style: const TextStyle(color: AppColor.toneTwo),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Call'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              ref.read(viewPanelProvider.notifier).state = !ref.read(viewPanelProvider);
            },
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      backgroundColor: AppColor.secondary,
      body: Center(
        child: Stack(
          children: <Widget>[
            _viewRows(),
            _panel(),
            _toolbar(),
          ],
        ),
      ),
    );
  }
}
