import 'package:ParkSquare/localization/localization_const.dart';
import 'package:ParkSquare/theme/theme.dart';
import 'package:flutter/material.dart';

class ConfirmScreen extends StatefulWidget {
  final Map<String, dynamic> guestData;

  const ConfirmScreen({Key? key, required this.guestData}) : super(key: key);
  

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: whiteColor,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: black33Color,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            fixPadding * 2.0, fixPadding, fixPadding * 2.0, fixPadding * 2.0),
        physics: const BouncingScrollPhysics(),
        children: [
          visitorImage(size),
          heightSpace,
          heightSpace,
          heightSpace,
          heightSpace,
          Row(
            children: [
              detailBox(getTranslate(context, 'confirm.guest'), widget.guestData['guestName']),
              widthSpace,
              widthSpace,
              detailBox(getTranslate(context, 'confirm.visiting'), "A-102"),
              widthSpace,
              widthSpace,
              detailBox(getTranslate(context, 'confirm.gatepass'), widget.guestData['entryCode'].toString()),
            ],
          ),
          heightSpace,
          heightSpace,
          detailBox("Phone", widget.guestData['guestPhone']),
          heightSpace,
          heightSpace,
          detailBox("Enter Date", widget.guestData['enterDate']),
          heightSpace,
          heightSpace,
          detailBox("Enter Time", widget.guestData['enterTime']),
          heightSpace,
          heightSpace,
          confirmAndSendinButton(context)
        ],
      ),
    );
  }

  visitorImage(Size size) {
    return Center(
      child: Container(
        height: size.width * 0.28,
        width: size.width * 0.28,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage(
              "assets/confirm/image.png",
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  confirmAndSendinButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(fixPadding * 1.4),
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
          getTranslate(context, 'confirm.confirm_send_in'),
          style: semibold18White,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  detailBox(String title, String detail) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: fixPadding * 2.0, horizontal: fixPadding),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: shadowColor.withOpacity(0.2),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              title,
              style: medium16Grey,
              overflow: TextOverflow.ellipsis,
            ),
            heightSpace,
            Text(
              detail,
              style: semibold16Black33,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }
}
