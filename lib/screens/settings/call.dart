import 'package:fl_sevengen_society_guard_app/localization/localization_const.dart';
import 'package:fl_sevengen_society_guard_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ri.dart';
import 'package:im_animations/im_animations.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({super.key});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  bool volumOff = true;
  bool mute = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(fixPadding * 2.0),
        children: [
          SizedBox(
            height: size.height,
            width: size.width,
            child: Column(
              children: [
                heightBox(size.height * 0.07),
                Text(
                  getTranslate(context, 'call.Calling'),
                  style: medium18Grey,
                  textAlign: TextAlign.center,
                ),
                heightSpace,
                const Text(
                  "Brooklyn Simmons",
                  style: semibold18Black33,
                  textAlign: TextAlign.center,
                ),
                image(),
                heightSpace,
                heightSpace,
                callOptions(),
                heightSpace,
                heightSpace,
                heightSpace,
                endCallButton(context),
                heightBox(size.height * 0.1)
              ],
            ),
          ),
        ],
      ),
    );
  }

  endCallButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        height: 50.0,
        width: 50.0,
        decoration: const BoxDecoration(
          color: Color(0xFFFC1515),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.call_end,
          color: whiteColor,
        ),
      ),
    );
  }

  callOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              mute = !mute;
            });
          },
          child: Container(
            height: 50.0,
            width: 50.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: mute ? greyColor.withOpacity(0.5) : primaryColor,
            ),
            alignment: Alignment.center,
            child: Icon(
              mute ? Icons.mic_off_outlined : Icons.mic_none_outlined,
              color: whiteColor,
              size: 28,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              volumOff = !volumOff;
            });
          },
          child: Container(
            height: 50.0,
            width: 50.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: volumOff ? greyColor.withOpacity(0.5) : primaryColor,
            ),
            alignment: Alignment.center,
            child: Icon(
              volumOff ? Icons.volume_off_outlined : Icons.volume_up_outlined,
              color: whiteColor,
              size: 28,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/chat');
          },
          child: Container(
            height: 50.0,
            width: 50.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: greyColor.withOpacity(0.5),
            ),
            alignment: Alignment.center,
            child: const Iconify(
              Ri.message_3_line,
              color: whiteColor,
              size: 28,
            ),
          ),
        ),
      ],
    );
  }

  image() {
    return Expanded(
        child: Container(
      margin: const EdgeInsets.only(top: fixPadding * 4.0),
      child: ColorSonar(
        contentAreaRadius: 80.0,
        waveFall: 30.0,
        innerWaveColor: const Color(0xFF5195B7).withOpacity(0.17),
        middleWaveColor: const Color(0xFF5195B7).withOpacity(0.13),
        outerWaveColor: const Color(0xFF5195B7).withOpacity(0.09),
        waveMotion: WaveMotion.synced,
        duration: const Duration(seconds: 2),
        waveMotionEffect: Curves.easeInOut,
        child: CircleAvatar(
          radius: 90.0,
          backgroundColor: const Color(0xFF7A99AD).withOpacity(0.35),
          child: Image.asset(
            "assets/call/image.png",
            fit: BoxFit.cover,
          ),
        ),
      ),
    ));
  }
}
