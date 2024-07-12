import 'package:fl_sevengen_society_guard_app/localization/localization_const.dart';
import 'package:fl_sevengen_society_guard_app/theme/theme.dart';
import 'package:flutter/material.dart';

class GuestEntryScreen extends StatefulWidget {
  const GuestEntryScreen({super.key});

  @override
  State<GuestEntryScreen> createState() => _GuestEntryScreenState();
}

class _GuestEntryScreenState extends State<GuestEntryScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  // final TextEditingController _vehicleTypeController = TextEditingController();
  final TextEditingController _vehicleNumberController = TextEditingController();
  final TextEditingController _visitorRcController = TextEditingController();
  String? _selectedVehicleType;


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
          getTranslate(context, 'guest_entry.guest_entry'),
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
          guestNameField(),
          heightSpace,
          heightSpace,
          mobileNumberField(),
          heightSpace,
          heightSpace,
          vehicleTypeField(),
          heightSpace,
          heightSpace,
          vehicleNumberField(),
          heightSpace,
          heightSpace,
          // visitorRCField(),
        ],
      ),
      bottomNavigationBar: continueButton(),
    );
  }

  visitorRCField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getTranslate(context, 'Enter  Visitor RC'),
          style: medium16Grey,
        ),
        heightSpace,
        Container(
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: shadowColor.withOpacity(0.25),
                blurRadius: 6.0,
              )
            ],
          ),
          child: TextField(
            controller: _visitorRcController,
            style: semibold16Black33,
            cursorColor: primaryColor,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: fixPadding, vertical: fixPadding * 1.4),
              hintText: getTranslate(context, 'Enter Visitor RC'),
              hintStyle: medium16Grey,
            ),
          ),
        )
      ],
    );
  }


  vehicleTypeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getTranslate(context, 'guest_entry.vehicle_type'),
          style: medium16Grey,
        ),
        heightSpace,
        Container(
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: shadowColor.withOpacity(0.25),
                blurRadius: 6.0,
              )
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedVehicleType,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: fixPadding, vertical: fixPadding * 1.4),
            ),
            items: <String>['2 Wheeler', '4 Wheeler']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: semibold16Black33),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedVehicleType = newValue;
              });
            },
            hint: Text(getTranslate(context, 'guest_entry.enter_vehicle_type'), style: medium16Grey),
          ),
        ),
      ],
    );
  }

  vehicleNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getTranslate(context, 'Enter vehicle number'),
          style: medium16Grey,
        ),
        heightSpace,
        Container(
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: shadowColor.withOpacity(0.25),
                blurRadius: 6.0,
              )
            ],
          ),
          child: TextField(
            controller: _vehicleNumberController,
            style: semibold16Black33,
            cursorColor: primaryColor,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: fixPadding, vertical: fixPadding * 1.4),
              hintText: getTranslate(context, 'Enter vehicle number'),
              hintStyle: medium16Grey,
            ),
          ),
        )
      ],
    );
  }

  Widget continueButton() {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/selectEntryAddress',
            arguments: {
              'visitorName': _nameController.text,
              'visitorContact': _contactController.text,
              'visitorVehicleType': _selectedVehicleType,
              'visitorVehicleNumber': _vehicleNumberController.text,
              'visitorRC':_visitorRcController.text,
            },
          );
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
            getTranslate(context, 'guest_entry.continue'),
            style: semibold18White,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  mobileNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getTranslate(context, 'guest_entry.mobile_number'),
          style: medium16Grey,
        ),
        heightSpace,
        Container(
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: shadowColor.withOpacity(0.25),
                blurRadius: 6.0,
              )
            ],
          ),
          child: TextField(
            controller: _contactController,
            style: semibold16Black33,
            cursorColor: primaryColor,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: fixPadding, vertical: fixPadding * 1.4),
              hintText:
                  getTranslate(context, 'guest_entry.enter_mobile_number'),
              hintStyle: medium16Grey,
              suffixIcon: const Icon(
                Icons.mic_none,
                size: 20,
                color: blackColor,
              ),
            ),
          ),
        )
      ],
    );
  }

  guestNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getTranslate(context, 'guest_entry.guest_name'),
          style: medium16Grey,
        ),
        heightSpace,
        Container(
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: shadowColor.withOpacity(0.25),
                blurRadius: 6.0,
              )
            ],
          ),
          child: TextField(
            controller: _nameController,
            style: semibold16Black33,
            cursorColor: primaryColor,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: fixPadding, vertical: fixPadding * 1.4),
              hintText: getTranslate(context, 'guest_entry.enter_guest_name'),
              hintStyle: medium16Grey,
              suffixIcon: const Icon(
                Icons.mic_none,
                size: 20,
                color: blackColor,
              ),
            ),
          ),
        )
      ],
    );
  }
}