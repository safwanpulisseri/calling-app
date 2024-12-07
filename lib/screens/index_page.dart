import 'dart:developer';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:calling_app/core/theme/color/app_colors.dart';
import 'package:calling_app/core/util/png_assets.dart';
import 'package:calling_app/core/widget/const_sizes.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/index_provider.dart';
import 'call_page.dart';


class IndexPage extends ConsumerWidget {
  const IndexPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channelController = TextEditingController();
    final validateError = ref.watch(validateErrorProvider);
    final role = ref.watch(roleProvider);

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
                controller: channelController,
                decoration: InputDecoration(
                  errorText: validateError ? 'Channel Name is Mandatory' : null,
                  border: const UnderlineInputBorder(),
                  hintText: 'Channel Name',
                ),
              ),
              RadioListTile(
                title: const Text('Broadcaster'),
                value: ClientRoleType.clientRoleBroadcaster,
                groupValue: role,
                onChanged: (ClientRoleType? value) {
                  if (value != null) {
                    ref.read(roleProvider.notifier).state = value;
                  }
                },
              ),
              RadioListTile(
                title: const Text('Audience'),
                value: ClientRoleType.clientRoleAudience,
                groupValue: role,
                onChanged: (ClientRoleType? value) {
                  if (value != null) {
                    ref.read(roleProvider.notifier).state = value;
                  }
                },
              ),
              ElevatedButton(
                onPressed: () => onJoin(ref, channelController),
                child: const Text('Join'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onJoin(WidgetRef ref, TextEditingController channelController) async {
    ref.read(validateErrorProvider.notifier).state = channelController.text.isEmpty;

    if (!ref.read(validateErrorProvider)) {
      await handleCameraAndMic(Permission.camera);
      await handleCameraAndMic(Permission.microphone);

      await Navigator.push(
        ref.context,
        MaterialPageRoute(
          builder: (context) => CallPage(
            role: ref.read(roleProvider),
            channelName: channelController.text,
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
