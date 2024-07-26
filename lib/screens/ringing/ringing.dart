import 'dart:async';

import 'package:ParkSquare/localization/localization_const.dart';
import 'package:ParkSquare/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


class RingingScreen extends StatefulWidget {
  const RingingScreen({super.key});

  @override
  State<RingingScreen> createState() => _RingingScreenState();
}

class _RingingScreenState extends State<RingingScreen> {
  late IO.Socket socket;
  bool isNavigated = false; // Flag to prevent multiple navigations

  @override
  void initState() {
    super.initState();

    // Initialize socket connection
    socket = IO.io('http://93.127.198.13:3005', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    // Connect to socket
    socket.connect();
    print('Socket connected Receiver: ${socket.connected}');

    // socket.on('permission_update', (data) {
    //   print('Permission update received: $data');
    //   if (data['permit'] == 1) {
    //     Navigator.pushReplacementNamed(context, '/allowed');
    //   }
    // });

    socket.on('connect', (_) {
      print('Connected to socket (ReConfirm)');
    });

    socket.on('disconnect', (_) {
      print('Disconnected from socket');
    });

    socket.on('permission_update', (data) {
      print('Permission update received: $data');
      if (data['permit'] == 1 && !isNavigated) {
        isNavigated = true;
        Navigator.pushNamed(context, '/allowed');
      }
    });

    // Error handling
    socket.on('connect_error', (error) {
      print('Socket connection error: $error');
    });

    socket.on('error', (error) {
      print('Socket error: $error');
    });

    Timer(const Duration(seconds: 3), () {});
  }

  @override
  void dispose() {
    socket.disconnect();
    socket.close();
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
        bottomNavigationBar: backToHomeButton(),
      ),
    );
  }

  Widget backToHomeButton() {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/bottombar');
      },
      child: Text(
        'Back to Home',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
      ),

      // child: Text(
      //   getTranslate(context, 'allowed.back_to_home'),
      //   style: semibold16Primary,
      // ),
    );
  }
}