import 'dart:developer';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:calling_app/core/theme/color/app_colors.dart';
import 'package:calling_app/core/util/png_assets.dart';
import 'package:calling_app/core/widget/const_sizes.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'call_page.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final _channelController = TextEditingController();
  bool _validateError = false;
  ClientRoleType _role = ClientRoleType.clientRoleBroadcaster;

  @override
  void dispose() {
    _channelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        title: const Text('Video Call'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              kHeight40,
              Image.asset(AppPngPath.callIcon),
              kHeight20,
              TextField(
                controller: _channelController,
                decoration: InputDecoration(
                  errorText: _validateError ? 'Channel Name is Mandatory' : null,
                  border: const UnderlineInputBorder(),
                  hintText: 'Channel Name',
                ),
              ),
              RadioListTile(
                title: const Text('Broadcaster'),
                value: ClientRoleType.clientRoleBroadcaster,
                groupValue: _role,
                onChanged: (ClientRoleType? value) {
                  setState(() {
                    _role = value!;
                  });
                },
              ),
              RadioListTile(
                title: const Text('Audience'),
                value: ClientRoleType.clientRoleAudience,
                groupValue: _role,
                onChanged: (ClientRoleType? value) {
                  setState(() {
                    _role = value!;
                  });
                },
              ),
              ElevatedButton(
                onPressed: onJoin,
                child: const Text('Join'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onJoin() async {
    setState(() {
      _validateError = _channelController.text.isEmpty;
    });

    if (!_validateError) {
      await handleCameraAndMic(Permission.camera);
      await handleCameraAndMic(Permission.microphone);

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(
            role: _role,
            channelName: _channelController.text,
          ),
        ),
      );
    }
  }

  Future<void> handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    log('Permission status for ${permission.value}: $status');
  }
}
