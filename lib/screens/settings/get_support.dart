import 'package:fl_sevengen_society_guard_app/localization/localization_const.dart';
import 'package:fl_sevengen_society_guard_app/theme/theme.dart';
import 'package:flutter/material.dart';

class GetSupportScreen extends StatefulWidget {
  const GetSupportScreen({super.key});

  @override
  State<GetSupportScreen> createState() => _GetSupportScreenState();
}

class _GetSupportScreenState extends State<GetSupportScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0.0,
        titleSpacing: 0.0,
        centerTitle: false,
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
        title: Text(
          getTranslate(context, 'get_support.get_support'),
          style: semibold18Black33,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            fixPadding * 2.0, fixPadding, fixPadding * 2.0, fixPadding * 2.0),
        physics: const BouncingScrollPhysics(),
        children: [
          Center(
            child: Image.asset(
              "assets/getSupport/customer-care.png",
              height: size.height * 0.13,
              fit: BoxFit.cover,
            ),
          ),
          height5Space,
          Text(
            getTranslate(context, 'get_support.get_support'),
            style: semibold18Black33,
            textAlign: TextAlign.center,
          ),
          height5Space,
          Text(
            getTranslate(context, 'get_support.ask_suggest_improve'),
            style: medium16Grey,
            textAlign: TextAlign.center,
          ),
          heightSpace,
          heightSpace,
          heightSpace,
          heightSpace,
          issueTypeField(),
          heightSpace,
          heightSpace,
          messageField(size)
        ],
      ),
      bottomNavigationBar: submitButton(context),
    );
  }

  submitButton(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          margin: const EdgeInsets.all(fixPadding * 2.0),
          padding: const EdgeInsets.symmetric(
              horizontal: fixPadding * 2.0, vertical: fixPadding * 1.4),
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.1),
                blurRadius: 12.0,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Text(
            getTranslate(context, 'get_support.submit_message'),
            style: semibold18White,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  messageField(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getTranslate(context, 'get_support.message'),
          style: medium16Black33,
        ),
        height5Space,
        Container(
          height: size.height * 0.18,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: whiteColor,
            boxShadow: [
              BoxShadow(
                color: blackColor.withOpacity(0.2),
                blurRadius: 6.0,
              )
            ],
          ),
          child: TextField(
            expands: true,
            maxLines: null,
            minLines: null,
            cursorColor: primaryColor,
            style: medium14Black33,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(fixPadding * 1.5),
              hintText: getTranslate(context, 'get_support.enter_your_message'),
              hintStyle: medium14Grey,
            ),
          ),
        )
      ],
    );
  }

  issueTypeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getTranslate(context, 'get_support.issue_type'),
          style: medium16Black33,
        ),
        height5Space,
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: whiteColor,
            boxShadow: [
              BoxShadow(
                color: blackColor.withOpacity(0.2),
                blurRadius: 6.0,
              )
            ],
          ),
          child: TextField(
            cursorColor: primaryColor,
            style: medium14Black33,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: fixPadding * 1.5),
              hintText: getTranslate(context, 'get_support.enter_issue_type'),
              hintStyle: medium14Grey,
            ),
          ),
        )
      ],
    );
  }
}
