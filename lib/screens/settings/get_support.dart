import 'dart:convert';

import 'package:Park360/localization/localization_const.dart';
import 'package:Park360/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../api.dart';

class GetSupportScreen extends StatefulWidget {
  const GetSupportScreen({super.key});

  @override
  State<GetSupportScreen> createState() => _GetSupportScreenState();
}

class _GetSupportScreenState extends State<GetSupportScreen> {
  final TextEditingController issueTypeFieldController = TextEditingController();
  final TextEditingController messageFieldController = TextEditingController();

   Future<void> submitIssue() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not logged in')),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}api/societyManagement/submitComplaint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'complaintType': issueTypeFieldController.text,
        'breif_complaint': messageFieldController.text,
        'userId': userId,
        "status":1
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Issue submitted successfully')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit Issue')),
      );
    }
  }
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
        // onTap: () {
        //   Navigator.pop(context);
        // },
        onTap: submitIssue,
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
            controller: messageFieldController,
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
            controller: issueTypeFieldController,
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
