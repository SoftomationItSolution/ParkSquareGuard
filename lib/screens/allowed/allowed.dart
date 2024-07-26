import 'package:ParkSquare/localization/localization_const.dart';
import 'package:ParkSquare/theme/theme.dart';
import 'package:flutter/material.dart';

class AllowedScreen extends StatefulWidget {
  const AllowedScreen({super.key});

  @override
  State<AllowedScreen> createState() => _AllowedScreenState();
}

class _AllowedScreenState extends State<AllowedScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool key) => onWillPop(),
      // onWillPop: () async => onWillPop(),
      child: Scaffold(
        body: Center(
          child: ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(fixPadding * 2.0),
            children: [
              Image.asset(
                "assets/allowed/check.png",
                height: 80.0,
                width: 80.0,
              ),
              heightSpace,
              height5Space,
              Text(
                getTranslate(context, 'allowed.allowed'),
                style: semibold24Black33,
                textAlign: TextAlign.center,
              ),
              heightSpace,
              Text(
                getTranslate(context, 'allowed.text'),
                style: semibold16Grey,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
        bottomNavigationBar: backToHomeButton(),
      ),
    );
  }

  backToHomeButton() {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/bottombar');
      },
      child: Text(
        getTranslate(context, 'allowed.back_to_home'),
        style: semibold16Primary,
      ),
    );
  }

  onWillPop() {
    Navigator.pushNamed(context, '/bottombar');
  }
}
