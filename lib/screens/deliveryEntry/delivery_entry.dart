import 'package:Park360/localization/localization_const.dart';
import 'package:Park360/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;


class DeliveryEntryScreen extends StatefulWidget {
  const DeliveryEntryScreen({super.key});

  @override
  State<DeliveryEntryScreen> createState() => _DeliveryEntryScreenState();
}

class _DeliveryEntryScreenState extends State<DeliveryEntryScreen> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  TextEditingController? _activeController;

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
          getTranslate(context, 'delivery_entry.delivery_entry'),
          style: semibold18Black33,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            fixPadding * 2.0, fixPadding, fixPadding * 2.0, fixPadding * 2.0),
        physics: const BouncingScrollPhysics(),
        children: [
          Image.asset(
            "assets/home/food-delivery.png",
            height: size.height * 0.13,
          ),
          heightSpace,
          heightSpace,
          heightSpace,
          heightSpace,
          deliverymanNameField(),
          heightSpace,
          heightSpace,
          phoneNumberField(),
          heightSpace,
          heightSpace,
          deliveryCompanyField(),
          heightSpace,
          heightSpace,
          // insideTimeField(),
        ],
      ),
      bottomNavigationBar: continueButton(),
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
              'company': _companyNameController.text,
              'visitorType': 'delivery',
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
            getTranslate(context, 'delivery_entry.continue'),
            style: semibold18White,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  // Widget insideTimeField() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         getTranslate(context, 'delivery_entry.inside_time'),
  //         style: medium16Grey,
  //       ),
  //       heightSpace,
  //       Container(
  //         decoration: BoxDecoration(
  //           color: whiteColor,
  //           borderRadius: BorderRadius.circular(10.0),
  //           boxShadow: [
  //             BoxShadow(
  //               color: shadowColor.withOpacity(0.25),
  //               blurRadius: 6.0,
  //             )
  //           ],
  //         ),
  //         child: TextField(
  //           style: semibold16Black33,
  //           cursorColor: primaryColor,
  //           decoration: InputDecoration(
  //             border: InputBorder.none,
  //             contentPadding: const EdgeInsets.symmetric(
  //                 horizontal: fixPadding, vertical: fixPadding * 1.4),
  //             hintText:
  //                 getTranslate(context, 'delivery_entry.enter_inside_time'),
  //             hintStyle: medium16Grey,
  //             suffixIcon: const Icon(
  //               Icons.mic_none,
  //               size: 20,
  //               color: blackColor,
  //             ),
  //           ),
  //         ),
  //       )
  //     ],
  //   );
  // }

  Widget deliveryCompanyField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getTranslate(context, 'delivery_entry.delivery_company'),
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
            controller: _companyNameController,
            style: semibold16Black33,
            cursorColor: primaryColor,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: fixPadding, vertical: fixPadding * 1.4),
              hintText:
                  getTranslate(context, 'delivery_entry.delivery_company_name'),
              hintStyle: medium16Grey,
              suffixIcon: IconButton(
                icon: Icon(
                  _isListening && _activeController == _companyNameController
                      ? Icons.mic
                      : Icons.mic_none,
                  size: 20,
                  color: blackColor,
                ),
                onPressed: () => _listen(_companyNameController),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget phoneNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getTranslate(context, 'delivery_entry.phone_number'),
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
                  getTranslate(context, 'delivery_entry.enter_phone_number'),
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

  Widget deliverymanNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getTranslate(context, 'delivery_entry.deliveryman_name'),
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
              hintText: getTranslate(
                  context, 'delivery_entry.enter_deliveryman_name'),
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
