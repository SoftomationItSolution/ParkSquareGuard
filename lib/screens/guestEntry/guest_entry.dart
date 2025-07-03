import 'dart:io';

import 'package:Park360/localization/localization_const.dart';
import 'package:Park360/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class GuestEntryScreen extends StatefulWidget {
  const GuestEntryScreen({super.key});

  @override
  State<GuestEntryScreen> createState() => _GuestEntryScreenState();
}

class _GuestEntryScreenState extends State<GuestEntryScreen> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _vehicleNumberController =
      TextEditingController();
  final TextEditingController _visitorRcController = TextEditingController();
  String? _selectedVehicleType;
  TextEditingController? _activeController;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    _isListening = await _speech.initialize();
    setState(() {});
  }

  void _listen(TextEditingController controller) async {
    if (_activeController != null && _activeController != controller) {
      _speech.stop();
      _activeController = null;
      setState(() {
        _isListening = false;
      });
      return;
    }

    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) => print('onStatus: $status'),
        onError: (errorNotification) => print('onError: $errorNotification'),
      );
      if (available) {
        setState(() {
          _isListening = true;
          _activeController = controller;
        });
        _speech.listen(
          onResult: (result) => setState(() {
            controller.text = result.recognizedWords;
          }),
        );
      }
    } else {
      setState(() {
        _isListening = false;
        _activeController = null;
      });
      _speech.stop();
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

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
          // Image.asset(
          //   "assets/home/guests.png",
          //   height: size.height * 0.13,
          // ),
          cameraButton(),
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

  Widget cameraButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (_imageFile != null)
          Image.file(
            _imageFile!,
            height: 150,
          )
        else
          Image.asset(
            "assets/home/guests.png",
            height: 150,
          ),
        IconButton(
          icon: const Icon(Icons.camera_alt),
          onPressed: _pickImage,
        ),
      ],
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
              suffixIcon: IconButton(
                icon: Icon(
                  _isListening && _activeController == _visitorRcController
                      ? Icons.mic
                      : Icons.mic_none,
                  size: 20,
                  color: blackColor,
                ),
                onPressed: () => _listen(_visitorRcController),
              ),
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
          getTranslate(context, 'vehicle Type'),
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
            hint: Text(getTranslate(context, 'Enter Vehicle Type'),
                style: medium16Grey),
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
              suffixIcon: IconButton(
                icon: Icon(
                  _isListening && _activeController == _vehicleNumberController
                      ? Icons.mic
                      : Icons.mic_none,
                  size: 20,
                  color: blackColor,
                ),
                onPressed: () => _listen(_vehicleNumberController),
              ),
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
        onTap: () async {
          Navigator.pushNamed(
            context,
            '/selectEntryAddress',
            arguments: {
              'visitorName': _nameController.text,
              'visitorContact': _contactController.text,
              'visitorVehicleType': _selectedVehicleType,
              'visitorVehicleNumber': _vehicleNumberController.text,
              'visitorRC': _visitorRcController.text,
              'visitorType': 'Guest',
              'visitorImage': _imageFile?.path ?? '',
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
              suffixIcon: IconButton(
                icon: Icon(
                  _isListening && _activeController == _contactController
                      ? Icons.mic
                      : Icons.mic_none,
                  size: 20,
                  color: blackColor,
                ),
                onPressed: () => _listen(_contactController),
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
              suffixIcon: IconButton(
                icon: Icon(
                  _isListening && _activeController == _nameController
                      ? Icons.mic
                      : Icons.mic_none,
                  size: 20,
                  color: blackColor,
                ),
                onPressed: () => _listen(_nameController),
              ),
            ),
          ),
        )
      ],
    );
  }
}
