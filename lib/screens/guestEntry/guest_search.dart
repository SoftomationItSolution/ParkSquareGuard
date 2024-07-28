import 'package:Park360/localization/localization_const.dart';
import 'package:Park360/theme/theme.dart';
import 'package:flutter/material.dart';

class GuestSearchScreen extends StatefulWidget {
  const GuestSearchScreen({super.key});

  @override
  State<GuestSearchScreen> createState() => _GuestSearchScreenState();
}

class _GuestSearchScreenState extends State<GuestSearchScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: whiteColor,
        elevation: 0.0,
        titleSpacing: 0.0,
        centerTitle: false,
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
          getTranslate(context, 'guest_search.guest_search'),
          style: semibold18Black33,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            fixPadding * 2.0, fixPadding, fixPadding * 2.0, fixPadding * 2.0),
        physics: const BouncingScrollPhysics(),
        children: [
          Image.asset(
            "assets/home/guests.png",
            height: size.height * 0.13,
          ),
          heightSpace,
          heightSpace,
          heightSpace,
          heightSpace,
          towerAndFlatNumberField(),
          Divider(height: 20, thickness: 1),
          contactNumberField(),
          Divider(height: 20, thickness: 1),
          ownerNameField(),
        ],
      ),
      bottomNavigationBar: continueButton(),
    );
  }

  Widget towerAndFlatNumberField() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            style: semibold16Black33,
            cursorColor: primaryColor,
            decoration: InputDecoration(
              labelText: 'Tower',
              labelStyle: medium16Grey,
              border: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(width: fixPadding),
        Expanded(
          child: TextField(
            style: semibold16Black33,
            cursorColor: primaryColor,
            decoration: InputDecoration(
              labelText: 'Flat Number',
              labelStyle: medium16Grey,
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Widget contactNumberField() {
    return TextField(
      style: semibold16Black33,
      cursorColor: primaryColor,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: getTranslate(context, 'guest_search.mobile_number'),
        labelStyle: medium16Grey,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget ownerNameField() {
    return TextField(
      style: semibold16Black33,
      cursorColor: primaryColor,
      decoration: InputDecoration(
        labelText: 'Owner Name',
        labelStyle: medium16Grey,
        border: OutlineInputBorder(),
      ),
    );
  }

  continueButton() {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/selectEntryAddress');
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
              )
            ],
          ),
          child: Text(
            getTranslate(context, 'guest_search.continue'),
            style: semibold18White,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}