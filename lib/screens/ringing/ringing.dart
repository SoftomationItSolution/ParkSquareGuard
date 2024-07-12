import 'dart:async';

import 'package:fl_sevengen_society_guard_app/localization/localization_const.dart';
import 'package:fl_sevengen_society_guard_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


class RingingScreen extends StatefulWidget {
  const RingingScreen({super.key});

  @override
  State<RingingScreen> createState() => _RingingScreenState();
}

class _RingingScreenState extends State<RingingScreen> {
   late IO.Socket socket;

  @override
  void initState() {
    super.initState();

    // Initialize socket connection
    socket = IO.io('http://93.127.198.13:5016', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    // Connect to socket
    socket.connect();
        print('Socket connected Rec: ${socket.connected}');


    socket.on('permission_update', (data) {
      print('Permission update received: $data');
      if (data['permit'] == 1) {
        Navigator.pushReplacementNamed(context, '/allowed');
      }
    });

    Timer(const Duration(seconds: 3), () {
    
      
    });
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool key) {},

      // WillPopScope(
      //   onWillPop: () async => false,
      child: Scaffold(
        body: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(fixPadding * 2.0),
            physics: const BouncingScrollPhysics(),
            children: [
              Center(
                child: Image.asset(
                  "assets/ringing/notification.png",
                  height: 54.0,
                  fit: BoxFit.cover,
                ),
              ),
              heightSpace,
              Text(
                getTranslate(context, 'ringing.ringing'),
                style: semibold22Black33,
                textAlign: TextAlign.center,
              ),
              heightSpace,
              Text(
                getTranslate(context, 'ringing.they_are_getting_inform'),
                style: medium16Grey,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
