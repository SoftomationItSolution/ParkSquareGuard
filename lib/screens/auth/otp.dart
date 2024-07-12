import 'dart:async';
import 'package:fl_sevengen_society_guard_app/localization/localization_const.dart';
import 'package:fl_sevengen_society_guard_app/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  Timer? countdownTimer;
  Duration myDuration = const Duration(minutes: 2);

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  void stopTimer() {
    setState(() => countdownTimer!.cancel());
  }

  void resetTimer() {
    stopTimer();
    setState(() => myDuration = const Duration(minutes: 2));
  }

  void setCountDown() {
    const reduceSecondsBy = 1;
    if (mounted) {
      setState(
        () {
          final seconds = myDuration.inSeconds - reduceSecondsBy;
          if (seconds < 0) {
            countdownTimer!.cancel();
          } else {
            myDuration = Duration(seconds: seconds);
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/auth/bg.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heightSpace,
            heightSpace,
            heightSpace,
            backbutton(context),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
                children: [
                  otpText(),
                  heightSpace,
                  pleaseText(),
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  height5Space,
                  otpField(),
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  height5Space,
                  timer(minutes, seconds),
                  heightSpace,
                  heightSpace,
                  height5Space,
                  verifyButton(),
                  heightSpace,
                  resendText(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  resendText() {
    return Text.rich(
      TextSpan(
        text: getTranslate(context, 'otp.receive_text'),
        style: medium16Primary,
        children: [
          const TextSpan(text: " "),
          TextSpan(
              text: getTranslate(context, 'otp.resend'),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  if (myDuration == const Duration(seconds: 0)) {
                    resetTimer();
                    startTimer();
                  }
                }),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  verifyButton() {
    return GestureDetector(
      onTap: () {
        Timer(const Duration(seconds: 3), () {
          stopTimer();
          Navigator.popAndPushNamed(context, '/bottombar');
        });

        pleaseWaitDialog();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: fixPadding * 2.0, vertical: fixPadding * 1.5),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.1),
              blurRadius: 12.0,
              offset: const Offset(0, 6),
            )
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          getTranslate(context, 'otp.verify'),
          style: semibold18White,
        ),
      ),
    );
  }

  pleaseWaitDialog() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: whiteColor,
          insetPadding: const EdgeInsets.all(fixPadding * 4.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: fixPadding * 2.0, vertical: fixPadding * 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CupertinoActivityIndicator(
                  color: primaryColor,
                  radius: 15,
                ),
                widthSpace,
                Text(
                  getTranslate(context, 'otp.please_wait'),
                  style: semibold18Primary,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  timer(minutes, seconds) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: fixPadding * 1.5, vertical: fixPadding / 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40.0),
          color: const Color(0xFFD6E9F5),
        ),
        child: Text(
          "$minutes:$seconds",
          style: regular16Black,
        ),
      ),
    );
  }

  otpField() {
    return Pinput(
      cursor: Container(
        height: 22,
        width: 2,
        color: primaryColor,
      ),
      onCompleted: (value) {
        Timer(const Duration(seconds: 3), () {
          stopTimer();
          Navigator.popAndPushNamed(context, '/bottombar');
        });

        pleaseWaitDialog();
      },
      defaultPinTheme: PinTheme(
        height: 50.0,
        width: 50.0,
        margin: const EdgeInsets.symmetric(horizontal: fixPadding / 2),
        textStyle: medium20Black33,
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            BoxShadow(
              color: greyColor.withOpacity(0.25),
              blurRadius: 6.0,
            )
          ],
        ),
      ),
    );
  }

  pleaseText() {
    return Text(
      getTranslate(context, 'otp.please_text'),
      textAlign: TextAlign.center,
      style: medium14Grey77,
    );
  }

  otpText() {
    return Text(
      getTranslate(context, 'otp.OTP_VERIFICATION'),
      style: semibold21Primary,
      textAlign: TextAlign.center,
    );
  }

  backbutton(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      padding: const EdgeInsets.all(fixPadding * 2.0),
      icon: const Icon(
        Icons.arrow_back,
        color: black33Color,
      ),
    );
  }
}
