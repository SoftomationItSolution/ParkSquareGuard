import 'dart:convert';

import 'package:Park360/localization/localization_const.dart';
import 'package:Park360/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api.dart';
import 'qrView.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>with WidgetsBindingObserver {
  final TextEditingController pinController = TextEditingController();

  Future<Map<String, dynamic>> getGuestData(String entryCode) async {
    final response = await http
        .get(Uri.parse('${ApiConfig.baseUrl}api/visitor/getGatePass'));
    if (response.statusCode == 200) {
      List<dynamic> visitors = json.decode(response.body);
      for (var visitor in visitors) {
        if (visitor['entryCode'].toString() == entryCode) {
          return visitor;
        }
      }
    }
    throw Exception('Guest not found');
  }

  final pinTheme = const PinTheme(
    width: 40,
    height: 45,
    textStyle: semibold18Primary,
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(color: greyB4Color, width: 2.0),
      ),
    ),
  );

  String userName = '';
  String blockName = '';
  String towerName = '';

   @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadUserData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    pinController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      clearPinCode();
    }
  }

  void clearPinCode() {
    setState(() {
      pinController.clear();
    });
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? '';
      blockName = prefs.getString('block_name') ?? '';
      towerName = prefs.getString('tower_name') ?? '';
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  void _handleQRCodeResult(String scannedCode) async {
    if (scannedCode.length == 6) {
      setState(() {
        pinController.text = scannedCode;
      });
      try {
        final guestData = await getGuestData(scannedCode);
        Navigator.pushNamed(
          context,
          '/confirm',
          arguments: guestData,
         ).then((_) => clearPinCode());
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Guest not found')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid QR code')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        backgroundColor: whiteColor,
        centerTitle: false,
        titleSpacing: 20.0,
        title: Row(
          children: [
            Container(
              height: 48.0,
              width: 48.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: whiteColor,
                border: Border.all(color: whiteColor, width: 2.0),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor.withOpacity(0.2),
                    blurRadius: 6.0,
                  )
                ],
                image: const DecorationImage(
                  image: AssetImage("assets/guardImg.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            widthSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: semibold16Black33,
                    overflow: TextOverflow.ellipsis,
                  ),
                  heightBox(3.0),
                  Text(
                    (blockName.isNotEmpty && towerName.isNotEmpty)
                        ? "$blockName | $towerName"
                        : "No Data Available",
                    style: medium14Grey,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          ],
        ),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.logout, color: redColor),
        //     onPressed: _logout,
        //   ),
        // ],
      ),
      body: Column(
        children: [
          visitorEntryBox(),
          addNewVisitor(size),
        ],
      ),
    );
  }

  addNewVisitor(Size size) {
    return Expanded(
      child: Container(
        width: double.maxFinite,
        color: greyF6F3Color,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(fixPadding * 2.0),
          children: [
            Text(
              getTranslate(context, 'home.add_new_visitor'),
              style: semibold18Black33,
            ),
            heightSpace,
            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: fixPadding * 2.0,
                crossAxisSpacing: fixPadding * 2.0,
                childAspectRatio: 1.3,
              ),
              children: [
                visitorType(size, "assets/home/guests.png",
                    getTranslate(context, 'home.guest_entry'), () {
                  Navigator.pushNamed(context, '/guestEntry');
                }),
                visitorType(size, "assets/home/cab.png",
                    getTranslate(context, 'home.cab_entry'), () {
                  Navigator.pushNamed(context, '/cabEntry');
                }),
                visitorType(size, "assets/home/food-delivery.png",
                    getTranslate(context, 'home.delivery_entry'), () {
                  Navigator.pushNamed(context, '/deliveryEntry');
                }),
                visitorType(size, "assets/home/maid.png",
                    getTranslate(context, 'home.service_entry'), () {
                  Navigator.pushNamed(context, '/serviceEntry');
                }),
              ],
            )
          ],
        ),
      ),
    );
  }

  visitorType(Size size, String image, String title, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            BoxShadow(
              color: shadowColor.withOpacity(0.2),
              blurRadius: 6.0,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              image,
              height: size.height * 0.065,
              width: size.height * 0.065,
            ),
            heightSpace,
            Text(
              title,
              style: semibold16Black33,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }

  visitorEntryBox() {
    return Container(
      margin: const EdgeInsets.fromLTRB(fixPadding * 2.0, fixPadding * 1.5,
          fixPadding * 2.0, fixPadding * 1.6),
      padding: const EdgeInsets.symmetric(
          horizontal: fixPadding * 2.0, vertical: fixPadding * 2.5),
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: const Color(0xFFE8F2F9),
        border: Border.all(color: const Color(0xFFD2E3EF)),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          Text(
            getTranslate(context, 'home.visitor_entry'),
            style: semibold18Primary,
            textAlign: TextAlign.center,
          ),
          heightSpace,
          Text(
            getTranslate(context, 'home.enter_visitor_entry'),
            style: medium14Grey,
            textAlign: TextAlign.center,
          ),
          heightSpace,
          heightSpace,
          height5Space,
          Pinput(
            length: 6,
            controller: pinController,
            defaultPinTheme: pinTheme,
            focusedPinTheme: pinTheme.copyWith(
              decoration: const BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: primaryColor, width: 2.0)),
              ),
            ),
            submittedPinTheme: pinTheme.copyWith(
              decoration: const BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: primaryColor, width: 2.0)),
              ),
            ),
          ),
          heightSpace,
          heightSpace,
          heightSpace,
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    try {
                      final guestData = await getGuestData(pinController.text);
                      Navigator.pushNamed(
                        context,
                        '/confirm',
                        arguments: guestData,
                       ).then((_) => clearPinCode());
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Guest not found')),
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: fixPadding * 0.9,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: whiteColor,
                      boxShadow: [
                        BoxShadow(
                          color: shadowColor.withOpacity(0.2),
                          blurRadius: 6.0,
                        )
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      getTranslate(context, 'home.confirm'),
                      style: semibold18Primary,
                    ),
                  ),
                ),
              ),
              widthSpace,
              GestureDetector(
                onTap: () async {
                  final scannedCode = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QRViewExample(),
                    ),
                  );
                  if (scannedCode != null) {
                    _handleQRCodeResult(scannedCode);
                  } else {
                    setState(() {
                      pinController.clear();
                    });
                  }
                },
                child: Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.2),
                        blurRadius: 6.0,
                      )
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Iconify(
                    Carbon.qr_code,
                    color: whiteColor,
                    size: 30.0,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
