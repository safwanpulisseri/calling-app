
import 'dart:developer';

import 'package:agora_rtc_engine/rtc_engine.dart';
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
  ClientRole _role = ClientRole.Broadcaster;

  @override
  void dispose(){
    _channelController.dispose();
    super.dispose();

  }
  @override
  Widget build(BuildContext context) { 
    return Scaffold(
       appBar: AppBar(
      backgroundColor: AppColor.primary,
        title: Text('Video Call'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
         padding:EdgeInsets.symmetric(horizontal: 10,),
           child: Column(
            children: [
            kHeight40,
              Image.asset(AppPngPath.callIcon),
               kHeight20,
               TextField(
                controller: _channelController,
                decoration: InputDecoration(
                  errorText: _validateError ? 'Channel Name is Mandatory':null,
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(width: 1)
                  ),
                  hintText: 'Chnnel Name',

                ),
               ),
               RadioListTile(
                title: Text('BroadCaster'),
                value: ClientRole.Broadcaster, 
                groupValue: _role,
                 onChanged: (
                  ClientRole? value){
                 setState(() {
                   _role = value!;
                 });
                 }
              ),
                RadioListTile(
                title: Text('Audience'),
                value: ClientRole.Audience, 
                groupValue: _role,
                 onChanged: (
                  ClientRole? value){
                 setState(() {
                   _role = value!;
                 });
                 }
              ),
              ElevatedButton(
                onPressed: onJoin, 
                child: Text('Join'))
            ],
           ),
         ),
        ),
      );
  }
   Future <void>onJoin ()async{
    setState(() {
      _channelController.text.isEmpty ?
      _validateError=true
      :_validateError=false;
    });
    if(_channelController.text.isEmpty){
      await handleCameraAndMic(Permission.camera);
      await handleCameraAndMic(Permission.microphone);
      await Navigator.push(context,
       MaterialPageRoute(builder: (context)=>CallPage(
        role: _role,
        channelName: _channelController.text,
        )));
    }
  }
  Future<void> handleCameraAndMic(Permission permission)async{
   final status = await permission.request();
   log(status.toString());

  }
}